# Define your API key
$apiKey = "4c0b559d3b4b87f66b80f8b8b1ee582532880a988ad0833cb2c6b6c552d75704deea210fd4322350"

<#
Note: you will need an API key to complete this. They are free after you sign up for an account on abuseipdb.com. 
If you would like mine and know my personally, just ask.
#>

# Define the file path for the IP address list
$filePath = "abuseips.txt"
<#
Note: you will need to have a list of IPs (one per row) in a text document. Make sure the name is abuseips.txt and you are currently in the directory the file is in
#>

# Define the file path for the .csv file. This just exports to current directory
$csvFilePath = "abuseipdb_results.csv"

# Check if the results file already exists
$fileCounter = 0
while (Test-Path $csvFilePath) {
  # Modify the file name to avoid overwriting the existing file
  $fileCounter++
  $csvFilePath = "abuseipdb_results_$fileCounter.csv"
}

# Read the IP address list from the file
$ipList = Get-Content -Path $filePath

# Create an empty array to store the response content
$results = @()

# Loop through each IP address in the list
foreach ($ip in $ipList) {

  # Define the API endpoint URL
  $url = "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip&maxAgeInDays=365"

  # Create a new instance of the WebClient class
  $client = New-Object System.Net.WebClient

  # Add the API key to the request headers
  $client.Headers.Add("Key", $apiKey)

  # Make the API request and retrieve the response content
  $content = $client.DownloadString($url)

  # Parse the response content as JSON
  $json = ConvertFrom-Json $content

  # Store the parsed JSON data in the results array
  $results += $json.data
}

# Export the results to a .csv file
$results | Export-Csv -Path $csvFilePath -NoTypeInformation
