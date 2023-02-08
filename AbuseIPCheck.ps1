# Define the API endpoint
$url = "https://api.abuseipdb.com/api/v2/check"

# Read the list of IPs from a file
$ips = Get-Content -Path "AbuseIPs.txt"

# Loop through the list of IPs and retrieve information from abuseipdb.com
foreach ($ip in $ips) {
  # Send the API request
  $response = Invoke-WebRequest -Uri "$url+$ip" -Method Get -Headers @{ "Key" = "4c0b559d3b4b87f66b80f8b8b1ee582532880a988ad0833cb2c6b6c552d75704deea210fd4322350" }

  # Parse the JSON response
  $result = $response.Content | ConvertFrom-Json

  # Write the result to the console
  Write-Output "IP: $ip, IsAbused: $($result.data.abused), TotalReports: $($result.data.totalReports)"
}
