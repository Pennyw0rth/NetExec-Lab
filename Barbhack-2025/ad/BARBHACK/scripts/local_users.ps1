# local_users.ps1 - Create local users on JOLLYROGER for DPAPI attack
# Run as Administrator on JOLLYROGER (srv01)

# --- Account 1: Weak password (rockyou wordlist example) ---
$User1 = "pirate1"
$Pass1 = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
New-LocalUser -Name $User1 -Password $Pass1 -FullName "Weak Pirate" -Description "Test account with weak password" -ErrorAction SilentlyContinue

# --- Account 2: Strong password ---
$User2 = "pirate2"
$Pass2 = ConvertTo-SecureString "Str0ng!Passw0rd#2025" -AsPlainText -Force
New-LocalUser -Name $User2 -Password $Pass2 -FullName "Strong Pirate" -Description "Test account with strong password" -ErrorAction SilentlyContinue

# --- Account 3: Random password generator ---
function New-RandomPassword($length=14) {
    $chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_-+='
    -join ((1..$length) | ForEach-Object { $chars[(Get-Random -Maximum $chars.Length)] })
}
$User3 = "pirate3"
$RandPass = New-RandomPassword
$Pass3 = ConvertTo-SecureString $RandPass -AsPlainText -Force
New-LocalUser -Name $User3 -Password $Pass3 -FullName "Random Pirate" -Description "Test account with random password" -ErrorAction SilentlyContinue

# --- Add them all to Users group ---
Add-LocalGroupMember -Group "Users" -Member $User1,$User2,$User3 -ErrorAction SilentlyContinue

# Note: These users are NOT admins - they're regular users who store credentials
# The attack path is: dump SAM -> crack password -> decrypt DPAPI vault

# --- Display results ---
Write-Host "`nAccounts created:"
Write-Host "  $User1 / P@ssw0rd (weak, rockyou)"
Write-Host "  $User2 / Str0ng!Passw0rd#2025"
Write-Host "  $User3 / $RandPass (random)"
