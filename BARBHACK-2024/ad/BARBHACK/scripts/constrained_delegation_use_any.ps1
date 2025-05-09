Set-ADUser -Identity "alambix" -ServicePrincipalNames @{Add='CIFS/aleem.armorique.local'}
Get-ADUser -Identity "alambix" | Set-ADAccountControl -TrustedToAuthForDelegation $true
Set-ADUser -Identity "alambix" -Add @{'msDS-AllowedToDelegateTo'=@('CIFS/armorique.armorique.local','CIFS/armorique')}
Add-ADGroupMember -Identity 'Protected Users' -Members alambix