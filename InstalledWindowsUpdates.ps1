# Get a list of all the installed Windows updates
Get-WmiObject -Class Win32_QuickFixEngineering | Select-Object HotFixID, Description, InstalledOn | Sort InstalledOn

<#
This script uses the Get-WmiObject cmdlet to retrieve a list of all the installed Windows updates on the local computer. 
The information retrieved includes the HotFixID (the KB number), Description, and InstalledOn date.

Having a list of installed updates can be useful for a cybersecurity analyst in a number of ways, including:

-Verifying that critical security updates have been installed
-Investigating the root cause of a security issue by determining which updates were installed before or af
ter the issue occurred
-Keeping track of when updates were installed to ensure compliance with security policies or regulations

Remember that monthy security KB rollups drop on the second Tuesday of the month. Verify you have the latest kb installed for this workstation/server
#>
