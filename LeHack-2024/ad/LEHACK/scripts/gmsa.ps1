Import-Module ActiveDirectory

Set-ADServiceAccount -Identity gMSA-obelix -PrincipalsAllowedToRetrieveManagedPassword alambix
