# maq.ps1 - Set Machine Account Quota to 0 (disable adding computers)
# Run this on the Domain Controller (BLACKPEARL)

Import-Module ActiveDirectory
Set-ADDomain -Identity pirates.brb -Replace @{"ms-DS-MachineAccountQuota"="0"}

Write-Host "Machine Account Quota set to 0 - users cannot add computers to domain"
