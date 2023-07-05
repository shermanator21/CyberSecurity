# This script imports a list of users in a text file and outputs some information about them into a csv. Just update the imported text file location below for it to work

# Import the list of users from a text file
$users = Get-Content -Path "C:\Users\jrsherman\Downloads\hardtoken users 7-5-2023.txt"

# Create an array to store the user information
$userInfo = @()

# Iterate through each user and retrieve information from Active Directory
foreach ($user in $users) {
   # Get the user object from Active Directory
   $adUser = Get-ADUser -Filter "SamAccountName -eq '$user'" -Properties Title, DistinguishedName

   if ($adUser) {
       # Retrieve the user's job title and OU location
       $jobTitle = $adUser.Title
       $ouLocation = ($adUser.DistinguishedName -split ',', 2)[1].Trim()

       # Create a custom object with the user information
       $userObject = [PSCustomObject]@{
           User = $user
           JobTitle = $jobTitle
           OULocation = $ouLocation
       }

       # Add the user object to the array
       $userInfo += $userObject
   }
}

# Export the user information to a CSV file
$userInfo | Export-Csv -Path "C:\Users\jrsherman\Downloads\ADUsers_Info_Results.csv" -NoTypeInformation

Write-Output "User information exported to ADUsers_Info_Results.csv."