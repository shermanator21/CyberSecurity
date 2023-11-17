# Input Group Name and outputs Username (SamAccountName) of members
# This short script was created to query groups with large membership due to the limit restraints of Get-ADGroupMembers (5,000)

# Specify Group Here
$group = "group_name" 

# Gets DN of group
$GroupDN = (Get-ADGroup -Identity $group).DistinguishedName

# Gets DN of memebrs of group
$members = DSget group $GroupDN -members

# Strips Quotation marks to help parse below
$members = $members.Replace("`"","")

# Cycle through each member and output SamAccountName and DN
Foreach ($member in $members) {
Get-AdUser -Filter {DistinguishedName -eq $member} | select SAMAccountName
}
