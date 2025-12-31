# gmsa.ps1 - Create gMSA account for shipping service
# Run this on the Domain Controller (BLACKPEARL)

Import-Module ActiveDirectory

# Create the KDS Root Key (required for gMSA)
# In production, use: Add-KdsRootKey -EffectiveTime ((Get-Date).AddHours(-10))
Add-KdsRootKey -EffectiveImmediately

Start-Sleep -Seconds 10

# Create the gMSA account
New-ADServiceAccount -Name "gMSA-shipping" `
    -Description "gMSA for shipping service" `
    -DNSHostName "gmsa-shipping.pirates.brb" `
    -ManagedPasswordIntervalInDays 30 `
    -Enabled $True

# Allow Administrator to retrieve the managed password
Set-ADServiceAccount `
    -Identity "gMSA-shipping" `
    -PrincipalsAllowedToRetrieveManagedPassword "Administrator"

# Get and display the gMSA properties (including the managed password blob)
$gmsa = Get-ADServiceAccount -Identity "gMSA-shipping" -Properties *,msDS-ManagedPassword
$gmsa

Write-Host "gMSA-shipping created successfully"
Write-Host "Run the following to get the managed password blob:"
Write-Host 'Get-ADServiceAccount -Identity "gMSA-shipping" -Properties "msDS-ManagedPassword"'
