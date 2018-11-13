[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
## Download PsTools
$pspingOut =  "C:\Users\$env:UserName\Downloads\PSTools.zip"
## PsPing 압축 해제 경로
$pspingUnZip = "C:\PSTools"
Invoke-WebRequest -Uri "https://download.sysinternals.com/files/PSTools.zip" -OutFile $pspingOut
Expand-Archive "$pspingOut" -DestinationPath $pspingUnZip 
$pscmd = "$pspingUnZip\psping.exe -accepteula | Out-Null"
Invoke-Expression -Command $pscmd 
## PsPing 환경변수 설정
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\PSTools", "Machine")

## Download InfluxDB
$influxdbLocation = "C:\Users\$env:USERNAME\Downloads\influxdb-1.7.0_windows_amd64.zip"
Invoke-WebRequest https://dl.influxdata.com/influxdb/releases/influxdb-1.7.0_windows_amd64.zip -OutFile $influxdbLocation
Start-Sleep -Seconds 1
Expand-Archive "$influxdbLocation" -DestinationPath "C:\influxDB"
Start-Sleep -Seconds 2

## Download NSSM
$nssmLocation = "C:\Users\$env:USERNAME\Downloads\nssm-2.24.zip"
Invoke-WebRequest https://nssm.cc/release/nssm-2.24.zip -OutFile $nssmLocation
Start-Sleep -Seconds 1
Expand-Archive "$nssmLocation" -DestinationPath "C:\nssm"
Start-Sleep -Seconds 2
C:\nssm\nssm-2.24\win64\nssm.exe install influxdb C:\influxDB\influxdb-1.7.0-1\influxd.exe
Start-Sleep -Seconds 1

## Download Grafana
$grafanaLocation = "C:\Users\$env:USERNAME\Downloads\grafana-5.3.2.windows-amd64.zip"
Invoke-WebRequest https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-5.3.2.windows-amd64.zip -OutFile $grafanaLocation
Start-Sleep -Seconds 1
Expand-Archive "$grafanaLocation" -DestinationPath "C:\grafana"
Start-Sleep -Seconds 2
C:\nssm\nssm-2.24\win64\nssm.exe install grafana C:\grafana\grafana-5.3.2\bin\grafana-server.exe
Start-Sleep -Seconds 1

Start-Service -Name influxdb
Start-Service -Name grafana

C:\influxDB\influxdb-1.7.0-1\influx.exe -execute "create database network"
Start-Sleep -Seconds 1
C:\influxDB\influxdb-1.7.0-1\influx.exe -execute "show databases"