# dpapi_secret.ps1 - Create DPAPI credential for pirate1 user
# Run as Administrator on JOLLYROGER (srv01)
# This creates a credential stored via Windows Credential Manager

# The secret to store (this is Flag 5)
$TargetName = "smb.queenrev"
$Username = "ironhook"
$Password = "brb{5d26ec0024167fdf8a45a70eff4ade36}"

# Pirate1 credentials
$Pirate1User = "pirate1"
$Pirate1Pass = "P@ssw0rd"

# First, create user profile by simulating a login
Write-Host "Creating user profile for pirate1..."

# Use ProfileFunctions to create the user profile
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public class ProfileHelper {
    [DllImport("userenv.dll", SetLastError = true, CharSet = CharSet.Auto)]
    public static extern bool CreateProfile(
        [MarshalAs(UnmanagedType.LPWStr)] String pszUserSid,
        [MarshalAs(UnmanagedType.LPWStr)] String pszUserName,
        [Out, MarshalAs(UnmanagedType.LPWStr)] System.Text.StringBuilder pszProfilePath,
        uint cchProfilePath);
}
"@

# Get pirate1 SID
$user = New-Object System.Security.Principal.NTAccount($Pirate1User)
$sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).Value

# Create profile path buffer
$profilePath = New-Object System.Text.StringBuilder(260)

# Try to create profile (may fail if already exists, that's ok)
[ProfileHelper]::CreateProfile($sid, $Pirate1User, $profilePath, 260) | Out-Null

# Alternative: Use runas to force profile creation via interactive login simulation
# Create a script that will run as pirate1
$tempScript = "C:\Windows\Temp\create_cred_pirate1.ps1"
$scriptContent = @"

`$cred = New-Object System.Management.Automation.PSCredential("$Pirate1User", (ConvertTo-SecureString "$Pirate1Pass" -AsPlainText -Force))
cmdkey /generic:$TargetName /user:$Username /pass:$Password
"@
Set-Content -Path $tempScript -Value $scriptContent

# Use Start-Process with credentials to create profile and run cmdkey
$securePass = ConvertTo-SecureString $Pirate1Pass -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($Pirate1User, $securePass)

try {
    # This forces profile creation (-NoNewWindow not compatible with -Credential)
    Start-Process -FilePath "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -WindowStyle Hidden -Command `"cmdkey /generic:$TargetName /user:$Username /pass:$Password`"" -Credential $cred -LoadUserProfile -Wait
    Write-Host "DPAPI credential created for pirate1 user"
    Write-Host "Target: $TargetName"
    Write-Host "Username: $Username"
    Write-Host "Profile created at: C:\Users\$Pirate1User"
    Write-Host "This can be recovered using dploot with pirate1's password (P@ssw0rd)"
} catch {
    Write-Host "ERROR: $_"
    
    # Fallback: Try scheduled task method
    Write-Host "Trying scheduled task method..."
    $TaskName = "CreateDPAPICredential"
    schtasks /delete /tn $TaskName /f 2>$null
    schtasks /create /tn $TaskName /tr "cmdkey /generic:$TargetName /user:$Username /pass:$Password" /sc once /st 00:00 /ru $Pirate1User /rp $Pirate1Pass /f
    schtasks /run /tn $TaskName
    Start-Sleep -Seconds 5
    schtasks /delete /tn $TaskName /f
}

# Clean up temp script
Remove-Item $tempScript -Force -ErrorAction SilentlyContinue
