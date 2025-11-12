Import-Module ActiveDirectory

$domain = "empire.local"
$ou = "CN=Users,DC=empire,DC=local"  # Default container

function New-RandomPassword {
    Add-Type -AssemblyName System.Web
    return [System.Web.Security.Membership]::GeneratePassword(12, 2)
}

$empireUsers = @(
    "tarkin", "vader", "palpatine", "krennic", "thrawn", "piett", "kaiser",
    "veers", "snow", "jerjerrod", "snoke", "grievoussssss", "windu", "maul",
    "dooku", "rex", "fett", "sidious", "hux", "phasma"
)

foreach ($name in $empireUsers) {
    $samAccountName = $name.ToLower()
    $displayName = $name.Substring(0,1).ToUpper() + $name.Substring(1)
    $password = ConvertTo-SecureString (New-RandomPassword) -AsPlainText -Force

    if (-not (Get-ADUser -Filter { SamAccountName -eq $samAccountName } -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $displayName `
                   -GivenName $displayName `
                   -SamAccountName $samAccountName `
                   -UserPrincipalName "$samAccountName@$domain" `
                   -AccountPassword $password `
                   -Enabled $true `
                   -Path $ou `
                   -ChangePasswordAtLogon $false
        Write-Host "Created user $displayName with random password"
    }
    else {
        Write-Host "User $samAccountName already exists"
    }
}

# Create stormtrooper users with IDs
$ids = @(2100..2149 + 2187..2236)

foreach ($id in $ids) {
    $name = "FN-$id"
    $samAccountName = "fn$id"
    $displayName = "Stormtrooper $name"
    $userPrincipalName = "$samAccountName@$domain"

    $plainPassword = [System.Web.Security.Membership]::GeneratePassword(12, 2)
    $securePassword = ConvertTo-SecureString $plainPassword -AsPlainText -Force

    if (-not (Get-ADUser -Filter { SamAccountName -eq $samAccountName } -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $displayName `
                   -GivenName "Stormtrooper" `
                   -Surname $name `
                   -SamAccountName $samAccountName `
                   -UserPrincipalName $userPrincipalName `
                   -AccountPassword $securePassword `
                   -Enabled $true `
                   -Path $ou `
                   -ChangePasswordAtLogon $false

        Write-Host "Created $name with password: $plainPassword"
    }
    else {
        Write-Host "$name already exists"
    }
}

# Set user 'krennic' as Kerberoastable (remove sensitive flags)
Set-ADUser -Identity "krennic" -ServicePrincipalNames @{Add='HTTP/empire'}
# Set user 'grievoussssss' as AS-REP Roasting 
Get-ADUser -Identity "grievoussssss" | Set-ADAccountControl -DoesNotRequirePreAuth:$true

# Set password for 'krennic'
Set-ADAccountPassword -Identity krennic -Reset -NewPassword (ConvertTo-SecureString "liu8Sith" -AsPlainText -Force)

# Set password for 'fn2187'
Set-ADAccountPassword -Identity fn2187 -Reset -NewPassword (ConvertTo-SecureString "zHBsKN?^8KsJ" -AsPlainText -Force)
Set-ADAccountPassword -Identity fn2100 -Reset -NewPassword (ConvertTo-SecureString "YourStrongPasswordHere!" -AsPlainText -Force)
Set-ADAccountPassword -Identity grievoussssss -Reset -NewPassword (ConvertTo-SecureString "BNyuiuu456gfd" -AsPlainText -Force)
# Grant 'fn2187' permission to reset and change password on AdminSDHolder ACL
Import-Module ActiveDirectory

# Define users
$targetUser = Get-ADUser vader
$grantee = Get-ADUser fn2187

# Get the target's distinguished name
$targetDN = $targetUser.DistinguishedName

# Build identity reference and GUIDs
$identity = New-Object System.Security.Principal.NTAccount($grantee.SamAccountName)

# Permissions we want to grant
$rights = [System.DirectoryServices.ActiveDirectoryRights]::ExtendedRight
$type = [System.Security.AccessControl.AccessControlType]::Allow

# Get the GUIDs for reset/change password
$changePwdGUID = [GUID]'00299570-246d-11d0-a768-00aa006e0529'   # Change password
$resetPwdGUID  = [GUID]'00299570-246d-11d0-a768-00aa006e0529'   # Same GUID used for reset
$extendedRightsGUID = [GUID]'00299570-246d-11d0-a768-00aa006e0529'

# Load DirectoryEntry for the target user
$targetEntry = [ADSI]"LDAP://$targetDN"
$acl = $targetEntry.ObjectSecurity

# Create ACEs for both reset and change password
$ace1 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $identity, $rights, $type, $changePwdGUID
)
$ace2 = New-Object System.DirectoryServices.ActiveDirectoryAccessRule(
    $identity, $rights, $type, $resetPwdGUID
)

# Apply the new ACEs
$acl.AddAccessRule($ace1)
$acl.AddAccessRule($ace2)
$targetEntry.ObjectSecurity = $acl
$targetEntry.CommitChanges()

Write-Host "Granted 'fn2187' permissions to reset and change password on 'vader'"


# Add 'vader' permission to dcsync
$domainDN = (Get-ADDomain).DistinguishedName
dsacls "$domainDN" /G "vader:CA;Replicate Directory Changes" /G "vader:CA;Replicate Directory Changes All"
