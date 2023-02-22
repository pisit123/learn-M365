# Find og installere moduler:  #
Find-Module -Name ExchangeOnlineManagement | Install-Module
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline


#_______________________________DISTRIBUTION GROUPS:___________________________________________________________#
# https://docs.microsoft.com/en-us/powershell/module/exchange/new-distributiongroup?view=exchange-ps
# Henter ut et eksempel på hvordan opprete distrubutiongroup:
Get-Help New-DistributionGroup -Example
# Henter ut info om distr-grupper:
Get-DistributionGroup | Select-Object DisplayName,PrimarySmtpAddress

# Opprette ny distr-gruppe, eksempel Alle HR:
New-DistributionGroup -Name "Alle HR" -DisplayName "Alle HR" -PrimarySmtpAddress "alle-hr@domenenavnet.com"
New-DistributionGroup -Name "" -DisplayName "" -PrimarySmtpAddress ""
# Legge til medlemmer i distr-gruppen:
# https://docs.microsoft.com/en-us/powershell/module/exchange/add-distributiongroupmember?view=exchange-ps
Get-help Add-DistributionGroupMember -Examples
Add-DistributionGroupMember -Identity "Alle HR" -Member "emailen til brukeren her"
Add-DistributionGroupMember -Identity "" -Member ""
# Hente ut alle medlemmene etter man har oppretter gruppen og lagt til medlemmer:
Get-DistributionGroupMember -Identity "Alle HR" -Member "Kari Nordmann"

# Opprette ny mailbox -shared oppretter shared-mailboks
New-Mailbox -Shared -Name "It Drift" -DisplayName "IT Drift" -PrimarySmtpAddress "itdrift@domenenavn.com"
New-Mailbox -Shared -Name "" -DisplayName "" -PrimarySmtpAddress ""
#SJekke om en mailboks finnes, 
Get-EXOMailbox "kontakt"
# Hente ut bare shared mailboxer, med bare displayname: 
Get-EXOMailbox | Select-object DisplayName, RecipientTypeDetails | Where-object {$_.RecipientTypeDetails -eq "SharedMailbox"}

# Gi rettigheter til Sharedmailbox:
# https://docs.microsoft.com/en-us/powershell/module/exchange/add-mailboxpermission?view=exchange-ps
Get-Mailbox -Identity "navn på mailbox" | Add-MailboxPermission -User "mailen til brukeren" -AccessRights FullAccess -InheritanceType All
# Se hvem som har rettigheter i mailboxen:
Get-MailboxPermission -Identity "IT Support"
# Legge til rettigheter til å sende som: 
# https://docs.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps
Add-RecipientPermission -Identity "" -AccessRights SendAs -Trustee "" -Confirm:$false



#_____________________OPPRETTE DYNAMIC DISTRIBUTION-GROUP:____________________________________________________#
# https://docs.microsoft.com/en-us/powershell/module/exchange/new-dynamicdistributiongroup?view=exchange-ps
New-DynamicDistributionGroup -Name "" -IncludedRecipients "MailboxUsers" -ConditionalStateOrProvince "Trondheim"
# Nå er gruppa satt til at kun interne kan sende mail til den, 
# vil man at eksterne skal kunne det også må man hekte på : -RequireSenderAuthenticationEnabled:$false

# Hente ut alle DDistr-groups : 
Get-DynamicDistributionGroup

# Opprette M365-gruppe i din skybaserte organisasjon : 
# https://docs.microsoft.com/en-us/powershell/module/exchange/new-unifiedgroup?view=exchange-ps
New-UnifiedGroup -DisplayName ""

# Sette Parametere :
# https://docs.microsoft.com/en-us/powershell/module/exchange/set-unifiedgroup?view=exchange-ps
Set-UnifiedGroup
Set-UnifiedGroup -Identity "" -PrimarySmtpAddress prosjekty@domenenavn.no -RequireSenderAuthenticationEnabled:$false

# Legge til medlemmer i gruppa : 
# https://docs.microsoft.com/en-us/powershell/module/exchange/add-unifiedgrouplinks?view=exchange-ps
Add-UnifiedGroupLinks -Identity "" -LinkType Members -Links Kari.nordmann@demoundervisning.onmicrosoft.com



#______________________OPPRETTE MAILBOX TIL RESSURS_____________________________________________________________#
# https://docs.microsoft.com/en-us/powershell/module/exchange/new-mailbox?view=exchange-ps
New-Mailbox -Name moterom2@demoundervisning.onmicrosoft.com `
    -DisplayName "" `
    -Alias "" `
    -Room -EnableRoomMailboxAccount $true `
    -RoomMailboxPassword (ConvertTo-SecureString -String FfdE123e!wes_ -AsPlainText -Force)
# Sette kapasitet : 
Get-Mailbox -Identity moterom2 | Set-Mailbox -ResourceCapacity 12


# Sjekke hvilke ressurser (rom i dette tilfelle) som finnes: 
Get-EXOMailbox | Select-object DisplayName, RecipientTypeDetails | Where-object {$_.RecipientTypeDetails -eq "RoomMailbox"}
