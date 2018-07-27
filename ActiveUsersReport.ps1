Import-Module ActiveDirectory
#List of keywords in Name of each user to exclude
$blacklist = $blacklist = "svc|Mailbox|srvc"

#Find all users that are enabled and logged in within the past 90 days.
$AllUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true} | Get-ADUser -Properties Name,lastlogondate | Select-Object Name,lastlogondate

#Find all users that are enabled and logged in within the past 90 days where names don't contain strings in the $blacklist
$ActiveUsers = Get-ADUser –filter * -Properties passwordLastSet,whencreated,lastlogondate,Enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true -and $_.Name -inotmatch $blacklist} | Get-ADUser -Properties Name,lastlogondate | Select-Object Name,lastlogondate