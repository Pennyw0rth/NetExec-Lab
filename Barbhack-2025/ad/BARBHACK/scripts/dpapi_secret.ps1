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

Write-Host "Creating DPAPI credential for pirate1 using scheduled task..."

$TaskName = "CreateDPAPICredential"

# Delete existing task if present
schtasks /delete /tn $TaskName /f 2>$null

# Create scheduled task that runs INTERACTIVELY when pirate1 logs on
# /RL HIGHEST = Run with highest privileges
# /IT = Interactive only (but we'll also trigger it)
schtasks /create /tn $TaskName `
    /tr "cmdkey /generic:$TargetName /user:$Username /pass:$Password" `
    /sc ONLOGON `
    /ru $Pirate1User `
    /rp $Pirate1Pass `
    /rl HIGHEST `
    /f

if ($LASTEXITCODE -eq 0) {
    Write-Host "Task created, now simulating logon to trigger it..."
    
    # Simulate a logon session for pirate1 to trigger the task
    # This uses LogonUser API to create a proper interactive session
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Security.Principal;

public class LogonHelper {
    [DllImport("advapi32.dll", SetLastError = true)]
    public static extern bool LogonUser(
        string lpszUsername, string lpszDomain, string lpszPassword,
        int dwLogonType, int dwLogonProvider, out IntPtr phToken);
    
    [DllImport("kernel32.dll", SetLastError = true)]
    public static extern bool CloseHandle(IntPtr hObject);
    
    [DllImport("userenv.dll", SetLastError = true)]
    public static extern bool LoadUserProfile(IntPtr hToken, ref PROFILEINFO lpProfileInfo);
    
    [DllImport("userenv.dll", SetLastError = true)]
    public static extern bool UnloadUserProfile(IntPtr hToken, IntPtr hProfile);
    
    [StructLayout(LayoutKind.Sequential)]
    public struct PROFILEINFO {
        public int dwSize;
        public int dwFlags;
        [MarshalAs(UnmanagedType.LPTStr)] public string lpUserName;
        [MarshalAs(UnmanagedType.LPTStr)] public string lpProfilePath;
        [MarshalAs(UnmanagedType.LPTStr)] public string lpDefaultPath;
        [MarshalAs(UnmanagedType.LPTStr)] public string lpServerName;
        [MarshalAs(UnmanagedType.LPTStr)] public string lpPolicyPath;
        public IntPtr hProfile;
    }
    
    public const int LOGON32_LOGON_INTERACTIVE = 2;
    public const int LOGON32_PROVIDER_DEFAULT = 0;
}
"@

    $token = [IntPtr]::Zero
    $result = [LogonHelper]::LogonUser($Pirate1User, ".", $Pirate1Pass, 
        [LogonHelper]::LOGON32_LOGON_INTERACTIVE, 
        [LogonHelper]::LOGON32_PROVIDER_DEFAULT, 
        [ref]$token)
    
    if ($result -and $token -ne [IntPtr]::Zero) {
        Write-Host "Interactive logon successful, loading profile..."
        
        $profileInfo = New-Object LogonHelper+PROFILEINFO
        $profileInfo.dwSize = [System.Runtime.InteropServices.Marshal]::SizeOf($profileInfo)
        $profileInfo.lpUserName = $Pirate1User
        
        $loaded = [LogonHelper]::LoadUserProfile($token, [ref]$profileInfo)
        
        if ($loaded) {
            Write-Host "Profile loaded, running cmdkey in user context..."
            
            # Now run the scheduled task
            schtasks /run /tn $TaskName
            Start-Sleep -Seconds 3
            
            # Unload profile
            [LogonHelper]::UnloadUserProfile($token, $profileInfo.hProfile) | Out-Null
        }
        
        [LogonHelper]::CloseHandle($token) | Out-Null
    } else {
        Write-Host "LogonUser failed, running task anyway..."
        schtasks /run /tn $TaskName
        Start-Sleep -Seconds 3
    }
    
    # Clean up task
    schtasks /delete /tn $TaskName /f
    
    Write-Host ""
    Write-Host "SUCCESS: DPAPI credential should be created"
    Write-Host "Verify: dir C:\Users\pirate1\AppData\Local\Microsoft\Credentials"
} else {
    Write-Host "ERROR: Failed to create scheduled task"
    exit 1
}
