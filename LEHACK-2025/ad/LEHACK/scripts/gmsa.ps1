Import-Module ActiveDirectory
Enable-ADAccount -Identity "Guest"
Get-ADUser -Identity "lucius.fox1337" | Set-ADAccountControl -DoesNotRequirePreAuth:$true
Set-ADUser -Identity "joker" -ServicePrincipalNames @{Add='HTTP/batman'}
Set-ADServiceAccount gmsa-robin -PrincipalsAllowedToRetrieveManagedPassword SRV01$
Set-ADUser -Identity harvey.dent -Description "brb{96df3a6e62f6deff7a49d4faf7407050}"
dsacls "CN=AdminSDHolder,CN=System,DC=gotham,DC=city" /G gotham\harvey.dent:GA
dsacls "CN=Backup Operators,CN=Builtin,DC=gotham,DC=city" /G gotham\harvey.dent:GA


