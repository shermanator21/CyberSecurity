$ipRange = Read-Host "Enter the IP range to scan (e.g. 192.168.1.1-192.168.1.255)"
$results = @()
$ipAddresses = New-Object System.Collections.ArrayList

$startIP = [System.Net.IPAddress]::Parse((Get-Content $ipRange -TotalCount 1).TrimEnd())
$endIP = [System.Net.IPAddress]::Parse((Get-Content $ipRange -Tail 1 -TotalCount 1).TrimEnd())

for ($i = $startIP.GetAddressBytes(); $i -le $endIP.GetAddressBytes(); $i = [BitConverter]::GetBytes([BitConverter]::ToInt32($i, 0) + 1))
{
    $ipAddresses.Add([System.Net.IPAddress]$i)
}

foreach ($ipAddress in $ipAddresses)
{
    $ping = New-Object System.Net.NetworkInformation.Ping
    $reply = $ping.Send($ipAddress.ToString(), 100)

    if ($reply.Status -eq "Success")
    {
        $results += New-Object PSObject -Property @{
            IP = $ipAddress.ToString()
            Status = "Success"
        }
    }
}

$results | Export-Csv -Path "C:\VulnerabilityScanResults.csv" -NoTypeInformation

<#
This script scans a specified IP range for responsive hosts and exports the results to a CSV file. 
This can be useful for discovering devices on a network and identifying potential security vulnerabilities.
#>
