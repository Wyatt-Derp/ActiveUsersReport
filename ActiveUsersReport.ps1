Import-Module ActiveDirectory
#List of keywords in Name of each user to exclude
$blacklist = "svc|Mailbox|srvc|admin|backups|billing|support|lab|ctac|scan|sharepoint|windows|window|n-able|nable|cluster|test|local|ACE|AAD|ncentral|MSOL|Open DNS|opendns|OneLogin|Airwatch|Temp|service|mastercontrol|copier|scan|fax|room|calendar|conference|accounting|training|conf|central|concierge|nurse|staff|backups|psa|sso|noc|ctac|centrex|connectivity"

#Find all users that are enabled and logged in within the past 90 days.
$AllUsers = Get-ADUser -filter * -Properties name,lastlogondate,enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true} | Select-Object Name,lastlogondate

$AllUsersCount = $AllUsers | measure
$AllUsersTotal = New-Object -TypeName psobject -Property @{
    Name = 'User Total:'
    lastlogondate = $AllUsersCount.Count
}
$AllUsers += $AllUsersTotal

#Find all users that are enabled and logged in within the past 90 days where names don't contain strings in the $blacklist
$ActiveUsers = Get-ADUser -filter * -Properties name,lastlogondate,enabled | Where-Object {$_.lastlogondate -gt (get-date).adddays(-90) -and $_.Enabled -eq $true -and $_.Name -inotmatch $blacklist} | Select-Object Name,lastlogondate

$ActiveUsersCount = $ActiveUsers | measure
$ActiveUsersTotal = New-Object -TypeName psobject -Property @{
    Name = 'User Total:'
    lastlogondate = $ActiveUsersCount.Count
}
$ActiveUsers += $ActiveUsersTotal

#Create objects to store at the end of the $allusers variable to demarcate beginning of next list
$breakDelimiter = New-Object -TypeName psobject -Property @{
    Name = '=========='
    lastlogondate = '=========='
}
$activeUsersdelimiter = New-Object -TypeName psobject -Property @{
    Name = 'Active Users'
    lastlogondate = ''
}

#Add objects to $allusers array for a break
$reportBreak = @()
$reportBreak += $breakDelimiter
$reportBreak += $activeUsersdelimiter
$reportBreak += $breakDelimiter

#Combine both user reports, create filename and export to csv
$userReport = $AllUsers + $reportBreak + $ActiveUsers
$userReport
#$filepath = "c:\temp\UserReport_" + (get-date).ToString("MM-dd-yyyy") + ".csv"
#$userReport | Export-Csv -NoTypeInformation -Path $filepath