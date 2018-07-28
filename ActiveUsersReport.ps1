Import-Module ActiveDirectory
#List of keywords in Name of each user to exclude
$blacklist "svc|Mailbox|srvc|admin|billing|support|lab|ctac|scan|sharepoint|windows|window|n-able|nable|cluster"

#Find all users that are enabled and logged in within the past 90 days.
$AllUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true} | Get-ADUser -Properties Name,lastlogondate | Select-Object Name,lastlogondate | Export-Csv -NoTypeInformation -Path c:\temp\allusers.csv

#Find all users that are enabled and logged in within the past 90 days where names don't contain strings in the $blacklist
$ActiveUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true -and $_.Name -inotmatch $blacklist} | Get-ADUser -Properties Name,lastlogondate | Select-Object Name,lastlogondate | Export-Csv -NoTypeInformation -Path c:\temp\activeusers.csv