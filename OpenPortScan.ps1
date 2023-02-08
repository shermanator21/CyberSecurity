# Check for open ports on a remote computer
$computer = Read-Host "Enter the name or IP address of the remote computer"
$ports = Read-Host "Enter a comma-separated list of ports to check"

$ports = $ports.Split(',') | ForEach-Object { [int]$_ }

$openPorts = @()
foreach ($port in $ports)
{
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    try
    {
        $tcpClient.Connect($computer, $port)
        $openPorts += $port
    }
    catch
    {
    }
    finally
    {
        $tcpClient.Close()
    }
}

if ($openPorts.Count -gt 0)
{
    Write-Host "The following ports are open on $computer"
    Write-Host $openPorts
}
else
{
    Write-Host "No open ports were found on $computer."
}

<#
This script allows you to check for open ports on a remote computer. 
You enter the name or IP address of the remote computer, as well as a commma-separated list of ports to check (ex: 135,445).
The script then uses the System.Net.Sockets.TcpClient class to check if a connection can be made to each specified port on the remote computer. 
If a connection can be made, the port is considered open and is added to the list of open ports. 
Finally, the script outputs the list of open ports, if any.


Why is this relevant? It is more of a red team aciton, but knowing which ports are open on a remote computer can be useful for a cybersecurity analyst in a number of ways, including:

-Identifying open ports that are potentially vulnerable to attack
-Verifying the firewall configuration on the remote computer
-Investigating network-related security issues by determining which ports are open and what services they correspond to
