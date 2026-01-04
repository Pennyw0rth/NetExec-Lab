# description.ps1 - Set flag in user description
# Run this on the Domain Controller (BLACKPEARL)

Import-Module ActiveDirectory
Set-ADUser -Identity "flint" -Description "brb{88e7af3d7bf9ab21f9d6faa5cf644b76}"
Write-Host "Flag set in flint's description"
