Import-Module C:\Users\cwpark\netmon\99_get_azure_vm_infomation.ps1
$config = Get-Content -Raw -Path "C:\Users\$env:USERNAME\netmon\configuration.json" | ConvertFrom-Json
$servers = ""
$interval = $config.interval

if ($config.azure.flag -match $true) {
    $servers = PCW-Get-AzureVmInformation -resourceGroup $config.azure.resourceGroup
} elseif ($config.other.flag -match $true) {
    $servers = "C:\Users\$env:USERNAME" + $config.other.serverListPath
}

foreach ($server in $servers) {
    $address = $server.PublicIP + ":" + $config.azure.servicePort
    Invoke-Expression "psping -n 100 -i $interval -w 0 $address" -ErrorVariable badoutput `
                        | Select-String connecting `
                            | ForEach-Object { $result=("{0} - {1}" -f (Get-Date), $_) `
                                                    | Where-Object{ $_ -match 'connecting'} 
                                                        $destination_ip = ($result | Select-String -Pattern "to \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}"| %{$_.Matches} | %{$_.Value}).Replace("to ", "").Replace(" ", "")
                                                        $destination_port = ($result | Select-String -Pattern "to \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:\d{1,9}" | %{$_.Matches} | %{$_.Value} `
                                                                                                | Select-String -Pattern ":\d{1,9}" | %{$_.Matches} | %{$_.Value}).Replace(":", "").Replace(" ", "")
                                                        $speed = $result | Select-String -Pattern "\d{1,9}.\d{1,9}ms" | %{$_.Matches} | %{$_.Value}
                                                        if ($speed -eq $null) {
                                                           $speed = "0ms";
                                                        }
                                                  }
}

