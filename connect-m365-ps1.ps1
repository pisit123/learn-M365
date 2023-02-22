# Find og installere moduler #
Find-Module -Name AzureAD | Install-Module
Import-Module AzureAD
Connect-AzureAD
# Må så logge inn tenanteten sondena

Find-Module -Name MSOnline | Install-Module
Import-Module MSOnline
Connect-MsolService


# Sjekk hvilke kommandoner en har tilgjengelig samt list ut brukere (demobrukere)
Get-Command -Module MSOnline
Get-Command -Module AzureAD
Get-MsolUser
Get-Help New-MsolUser -Examples

#Opprette ny bruker;  (legg inn navn osv i "")
New-MsolUser `
    -UserPrincipalName "" `
    -DisplayName "" `
    -FirstName "" `
    -LastName ""

# Opprett gruppe for testing med selv-service reset passord med MSol-modulen
Get-Help New-MsolGroup -Examples
New-MsolGroup -DisplayName "" -Description ""
Get-MsolGroup

Get-MsolUser 
Get-MsolUser | Select-Object ObjectID, UserPrincipalName
Get-Help Add-MsolGroupMember -Examples

Add-MsolGroupMember -groupObjectid "" `
    -groupmemberType "User" `
    -groupMemberObjectId ""

Get-Help Get-MsolGroupMember -Examples
Get-MsolGroupMember -groupObjectid ""

# Legg til flere brukere i en gruppe ved bruk av en ForEach løkke:
Get-MsolUser | Select-Object ObjectID, UserPrincipalName
$users = Get-MsolUser | Select-Object ObjectID, UserPrincipalName
foreach ($user in $users) {
Add-MsolGroupMember -GroupObjectId "" `
    -groupmemberType "User" `
    -GroupMemberObjectId $user.ObjectID
}


Remove-MsolGroup -ObjectId ""


# Opprett gruppe for testing med selv-service reset passord med AzureAD-modulen
Get-Help New-AzureADGroup -Examples
New-AzureADGroup -DisplayName "gruppenavn" -MailEnabled $false -SecurityEnabled $true -MailNickName "NotSet"
# Liste ut de gruppene som er tilgjengelige med Azure-ad:
Get-AzureAdGroup

# hente ut bruker: 
Get-AzureADUser -SearchString "navn å søke etter"
# Legge til disse brukerene i en gruppe: 
Get-Help Add-AzureADGroupMember -Examples
Add-AzureADGroupMember -ObjectID "" -RefObjectId ""
Get-AzureADGroupMember -ObjectID ""
# Med løkke: 
$users = Get-AzureADUser | Select-Object ObjectID, UserPrincipalName
# write-host $users (sjekke at alle brukere ligger i users-variabelen)
foreach ($user in $users) {
Add-AzureADGroupMember -ObjectID "" -RefObjectId $user.ObjectID
}

Get-AzureADGroupMember -ObjectID ""


# Opprette ny bruker
Get-Help New-AzureADUser -Examples


Get-AzureADUser -SearchString ""


# Legg til flere brukere via .csv fil
$myusers=Import-Csv ./M365-script/my-users.csv -Delimiter ";"
write-host $myusers

foreach ($user in $myusers) {
    $PasswordProfile=New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
    $PasswordProfile.Password=$user.Password
    New-AzureADUser `
        -GivenName $user.GivenName `
        -SurName $user.SurName `
        -DisplayName $user.DisplayName `
        -UserPrincipalName $user.UserPrincipalName `
        -MailNickName $user.MailNickName `
        -OtherMails $user.Altmailaddr `
        -PasswordProfile $PasswordProfile `
        -AccountEnabled $true
}

# Rydde opp etter testing
Get-AzureADUser -SearchString ""
Remove-AzureADUser -ObjectId ""
Get-AzureAdGroup
Remove-AzureADGroup -ObjectID ""

#__________________________________Video 5_____________________________________#

<#
MSGraph PowerShell v1.0
#>

<# kodesnutter brukt i videoen for Get-MgUser #>
Get-MgUser

Install-Module Microsoft.Graph
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Directory.ReadWrite.All"
Get-MgUser  | Format-List  ID, DisplayName, Mail, UserPrincipalName
Get-MgUser  | Select-Object  ID, DisplayName, Mail, UserPrincipalName | ft
Get-MgUser -UserID fec9ff51-f8f0-43ab-9493-5f52dbbe484f
Get-MgUser -UserID fec9ff51-f8f0-43ab-9493-5f52dbbe484f | Format-List 
Get-MgUser -UserID fec9ff51-f8f0-43ab-9493-5f52dbbe484f | format-list givenname, surname, UserPrincipalName
$testvariable = Get-MgUser -UserID fec9ff51-f8f0-43ab-9493-5f52dbbe484f | format-list givenname, surname, UserPrincipalName


<# kodesnutter brukt i videoen for New-MgUser #>

$PasswordProfile = @{
    Password = 'xWwvJ]6NMw+bWH-d'
    }  

New-MgUser -DisplayName "Mons Monsen" `
    -UserPrincipalName "Mons.Monsen@demoundervisning.onmicrosoft.com" `
    -PasswordProfile $PasswordProfile `
    -AccountEnabled `
    -MailNickname "Mons.Monsen"


<# kodesnutter brukt i videoen for Update-MgUser #>

Update-MgUser -UserID b5c6e6db-2c3d-4ffc-bc33-8a845dda8ec3 `
    -Department "IT" `
    -Company "Learn IT"
