# users.ps1 - Create AD users for Barbhack 2025 Pirates Lab
# Run this on the Domain Controller (BLACKPEARL)

Import-Module ActiveDirectory
Add-Type -AssemblyName System.Web

# === Config ===
$OU = "OU=PirateCrew,DC=PIRATES,DC=BRB"
$ExportPath = "C:\AD_Pirates_Users.csv"

# Ensure OU exists
if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OU'" -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "PirateCrew" -Path "DC=PIRATES,DC=BRB"
}

# Special users: hardcoded passwords
$SpecialUsers = @{
    "plankwalker" = "Entry284*@&"
    "barnacle" = "First927&^!"
    "morgan" = "Entry369@!*"
    "ironhook" = "brb{5d26ec0024167fdf8a45a70eff4ade36}"
}

# Other users: random passwords
$OtherUsers = @(
    "blackbeard","jack","anne","calico","charles","mary",
    "sam","william","edward","stede","henry","bartholomew",
    "thomas","roberts","francis","jean","olivier","charlotte",
    "richard","isabella","lucas","amelia","elizabeth","george",
    "seafox","corsair","madeye","sharktooth","sable","stormy",
    "ghost","reef","brine","blacktail","redbeard",
    "saltydog","pegasus","rumcutter","stormbreaker","seadog",
    "reefwalker","crowsnest","stormcloud","harpoon","cutthroat",
    "lagooner", "flint"
)

# Helper: random password
function New-RandomPassword { [System.Web.Security.Membership]::GeneratePassword(12,2) }

# Collect for CSV
$UserExport = @()

# --- Create/Update special users ---
foreach ($kv in $SpecialUsers.GetEnumerator()) {
    $name = $kv.Key
    $pwdPlain = $kv.Value
    $pwd = ConvertTo-SecureString $pwdPlain -AsPlainText -Force
    
    $existing = Get-ADUser -Filter "SamAccountName -eq '$name'" -ErrorAction SilentlyContinue
    $shouldDisable = ($name -eq "lagooner")
    
    if (-not $existing) {
        New-ADUser -Name $name `
            -SamAccountName $name `
            -UserPrincipalName "$name@pirates.brb" `
            -Path $OU `
            -AccountPassword $pwd `
            -Enabled $true `
            -PasswordNeverExpires $true
    }
    
    $UserExport += [PSCustomObject]@{
        Username = $name
        Password = $pwdPlain
        Type = "Hardcoded"
        Disabled = $shouldDisable
    }
}

# --- Create other users (skip if exists) ---
foreach ($u in $OtherUsers) {
    $pwdPlain = New-RandomPassword
    $pwd = ConvertTo-SecureString $pwdPlain -AsPlainText -Force
    
    $existing = Get-ADUser -Filter "SamAccountName -eq '$u'" -ErrorAction SilentlyContinue
    $shouldDisable = ($u -eq "lagooner")
    
    if (-not $existing) {
        New-ADUser -Name $u `
            -SamAccountName $u `
            -UserPrincipalName "$u@pirates.brb" `
            -Path $OU `
            -AccountPassword $pwd `
            -Enabled (-not $shouldDisable) `
            -PasswordNeverExpires $true
    }
    
    $UserExport += [PSCustomObject]@{
        Username = $u
        Password = $pwdPlain
        Type = "Random"
        Disabled = $shouldDisable
    }
}

# Export credentials
$UserExport | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $ExportPath
Write-Host "Completed. Credentials exported to $ExportPath"
