########################################################################
# Date : 2018-11-01
# Get VM's IP Address
# 
########################################################################
function PCW-Get-AzureVmInformation {
    Param ([String] $resourceGroup)
    $array = @()
    $innerArray = @()
    if($resourceGroup.Length -eq 0) {
        $pubIps = Get-AzureRmPublicIpAddress
        $ipconfigs = $pubips.IpConfiguration.id
        $vms = Get-AzureRmVM
        $nics = Get-AzureRmNetworkInterface
        $flag = $false
        $ip = ""
    } else {
        $pubIps = Get-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup
        $ipconfigs = $pubips.IpConfiguration.id
        $vms = Get-AzureRmVM -ResourceGroupName $resourceGroup
        $nics = $vms.NetworkProfile
        $flag = $false
        $ip = ""
    }
        ForEach ($vm in $vms) {
            $nicString = $vm.NetworkProfile.NetworkInterfaces.id
            $lastSlash = $nicString.LastIndexOf("/")
            $nic = $nicString.Substring($lastSlash + 1, $nicString.Length - $lastSlash - 1)

            ForEach ($ipconfigs in $pubIps) {
                $ipconfig = $ipconfigs.IpConfiguration.id
                $a = ( $ipconfig | Select-String "/networkInterfaces/" -AllMatches).Matches.Index
                $b = ( $ipconfig | Select-String "/ipConfigurations/" -AllMatches).Matches.Index
                $pubIpNIC = $ipconfig.Substring($a + 19, $b - $a - 19)
                #$ipconfigs.IpAddress
                $ip = $ipconfigs.IpAddress
                if ($nic -match $pubIpNIC) {
                    $nicInfo = Get-AzureRmNetworkInterface -Name $nic -ResourceGroupName $vm.ResourceGroupName
                    $ourObject = New-Object -TypeName psobject 
                    $ourObject | Add-Member -MemberType NoteProperty -Name ResourceGroup -Value $vm.ResourceGroupName
                    $ourObject | Add-Member -MemberType NoteProperty -Name VmName -Value $vm.Name
                    $ourObject | Add-Member -MemberType NoteProperty -Name VmSize -Value $vm.HardwareProfile.VmSize
                    #$ourObject | Add-Member -MemberType NoteProperty -Name Method -Value $nicInfo.IpConfigurations.PrivateIpAllocationMethod
                    if($vm.OSProfile.WindowsConfiguration -ne $null) {
                        $ourObject | Add-Member -MemberType NoteProperty -Name Os -Value "windows"
                    } elseif ($vm.OSProfile.LinuxConfiguration -ne $null) {
                        $ourObject | Add-Member -MemberType NoteProperty -Name Os -Value "linux"
                    }
                    $ourObject | Add-Member -MemberType NoteProperty -Name PublicIP -Value $ip
                    $ourObject | Add-Member -MemberType NoteProperty -Name PublicIPMethod -Value $ipconfigs.PublicIpAllocationMethod
                    #$ourObject | Add-Member -MemberType NoteProperty -Name Method -Value $ipconfigs.PublicIpAllocationMethod
                    $ourObject | Add-Member -MemberType NoteProperty -Name PrivateIP -Value $nicInfo.IpConfigurations.PrivateIPAddress
                    $ourObject | Add-Member -MemberType NoteProperty -Name PrivateIPMethod -Value $nicInfo.IpConfigurations.PrivateIpAllocationMethod
                    $ourObject | Add-Member -MemberType NoteProperty -Name Location -Value $vm.Location
                    $array += $ourObject
                    break;
                }
            }
        }
        return $array
    }

