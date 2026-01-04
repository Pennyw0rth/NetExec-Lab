# reset-admin-pass.ps1 - Set the Administrator password
# Run this on the Domain Controller (BLACKPEARL)

Import-Module ActiveDirectory

# Set the username (domain admin account) and new password
$Username = "Administrator"
$NewPassword = "REDqC8aQtyhd78A"

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString $NewPassword -AsPlainText -Force

# Change the password in Active Directory
Set-ADAccountPassword -Identity $Username -NewPassword $SecurePassword -Reset

Write-Host "Administrator password has been set"
