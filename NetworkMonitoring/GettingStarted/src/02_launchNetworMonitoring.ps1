## Azure 특정 리소스 그룹의 VM 네트워크 정보를 읽어오는 스크립트 
Import-Module C:\Users\$env:USERNAME\netmon\99_get_azure_vm_infomation.ps1;
$config = Get-Content -Raw -Path "C:\Users\$env:USERNAME\netmon\configuration.json" | ConvertFrom-Json;
$servers = "";
$interval = $config.interval;
$requestBody = "";
$influxURI = "http://" + $config.influxDB.url + "/write?db=" + $config.influxDB.database;
$azServerPath = "C:\Users\$env:USERNAME" + "/" + $config.home +"/" + "azserverlist.csv"
$fileCsvPath = "C:\Users\$env:USERNAME" + "/" + $config.home +"/" + $config.other.serverListPath

## config 파일의 서버 정보들을 AzureVM 으로 할것인지.. 아닌지
if ($config.azure.flag -match $true) {
    $servers = PCW-Get-AzureVmInformation -resourceGroup $config.azure.resourceGroup;
    $servers | Export-Csv -Path $azServerPath -NoTypeInformation
} elseif ($config.other.flag -match $true) {
    $servers = Get-Content -Raw -Path $fileCsvPath | ConvertFrom-Csv
}

## 서버 갯수만큼 반복작업
foreach ($server in $servers) {
    Start-Job -Name $server.privateip -ScriptBlock {
        Param($server, $influxURI, $requestBody)
        while ($true) {
            $config = Get-Content -Raw -Path "C:\Users\$env:USERNAME\netmon\configuration.json" | ConvertFrom-Json;
            if ($config.azure.flag -match $true) {
                if ($server.Os -match "windows") {
                    $address = $server.privateip + ":" + "3389"
                } else {
                    $address = $server.privateip + ":" + $config.azure.servicePort;
                }
            } elseif ($config.other.flag -match $true) {
                if ($server.Os -match "windows") {
                    $address = $server.privateip + ":" + "3389"
                } else {
                    $address = $server.privateip + ":" + $config.azure.servicePort;
                }
            }
            Invoke-Expression "psping -n 1 -i 0 -w 0 $address" -ErrorVariable badoutput `
                | Select-String connecting `
                    | ForEach-Object { $result=("{0} - {1}" -f (Get-Date), $_) `
                        | Where-Object{ $_ -match 'connecting'} 
                            $destination_ip = ($result | Select-String -Pattern "to \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}"| %{$_.Matches} | %{$_.Value}).Replace("to ", "").Replace(" ", "");
                            $destination_port = ($result | Select-String -Pattern "to \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,9}" | %{$_.Matches} | %{$_.Value} `
                                                                    | Select-String -Pattern ":\d{1,9}" | %{$_.Matches} | %{$_.Value}).Replace(":", "").Replace(" ", "");
                            $speed = $result | Select-String -Pattern "\d{1,9}.\d{1,9}ms" | %{$_.Matches} | %{$_.Value};
                            $destination_ip
                            $destination_port
                            if ($speed -eq $null) {
                                $speed = "0ms";
                            }
                            $speed = $speed.Replace("ms","");
                            $requestBody = "network,destination_ip=$destination_ip,destination_port=$destination_port speed=$speed"
                            if($config.influxDB.Auth -match $true) {

                            } elseif ($config.influxDB.Auth -match $false) {
                                Invoke-WebRequest -Uri "$influxURI" `
                                                    -Method Post `
                                                    -Body $requestBody

                                                    Write-Host "hello"
                            }
                        }
            Start-Sleep -Seconds 1;
        }
    } -ArgumentList $server, $influxURI, $requestBody
}