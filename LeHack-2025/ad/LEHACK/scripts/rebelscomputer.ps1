Import-Module ActiveDirectory

Set-ADAccountPassword -Identity obiwan -Reset -NewPassword (ConvertTo-SecureString "wz(}ab4=/&_f" -AsPlainText -Force)
Set-ADAccountPassword -Identity finn -Reset -NewPassword (ConvertTo-SecureString "zHBsKN?^8KsJ" -AsPlainText -Force)
Set-ADAccountPassword -Identity poe -Reset -NewPassword (ConvertTo-SecureString "4zHB5sK5N?^8KsJ" -AsPlainText -Force)

Add-ADGroupMember -Identity "Backup Operators" -Members obiwan

if (-not (Get-ADComputer -Filter "Name -eq 'endor'" -ErrorAction SilentlyContinue)) { New-ADComputer -Name endor -Path "CN=Computers,DC=rebels,DC=local" -Enabled $true -AccountPassword (ConvertTo-SecureString "endor" -AsPlainText -Force) }
#New-ADComputer -Name endor -Path "CN=Computers,DC=rebels,DC=local" -Enabled $true -AccountPassword (ConvertTo-SecureString "endor" -AsPlainText -Force)


#New-ADServiceAccount -Name "gMSA-scarif" -DNSHostName "rebels.local" -PrincipalsAllowedToRetrieveManagedPassword "endor$"

