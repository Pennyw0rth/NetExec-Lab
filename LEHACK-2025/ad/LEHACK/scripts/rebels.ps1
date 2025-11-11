Import-Module ActiveDirectory

$domain = "rebels.local"
$ou = "CN=Users,DC=rebels,DC=local"

function New-RandomPassword {
    Add-Type -AssemblyName System.Web
    return [System.Web.Security.Membership]::GeneratePassword(12, 2)
}

$rebelUsers = @(
    "luke", "leia", "han", "obiwan", "lando",
    "jyn", "cassian", "finn", "rey", "maz",
    "poe", "wedge", "biggs", "mon", "bodhi",
    "chirrut", "baze", "hera", "ezra", "sabine"
)

foreach ($name in $rebelUsers) {
    $samAccountName = $name.ToLower()
    $displayName = $name.Substring(0,1).ToUpper() + $name.Substring(1)
    $plainPassword = New-RandomPassword
    $securePassword = ConvertTo-SecureString $plainPassword -AsPlainText -Force

    if (-not (Get-ADUser -Filter { SamAccountName -eq $samAccountName } -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $displayName `
                   -GivenName $displayName `
                   -SamAccountName $samAccountName `
                   -UserPrincipalName "$samAccountName@$domain" `
                   -AccountPassword $securePassword `
                   -Enabled $true `
                   -Path $ou `
                   -ChangePasswordAtLogon $false

        Write-Host "Created user $displayName with password: $plainPassword"
    }
    else {
        Write-Host "User $samAccountName already exists"
    }
}

