# dpapi_secret.ps1 - Create DPAPI credential for pirate1 user
# Run as Administrator on JOLLYROGER (srv01)
# This creates a credential stored via Windows Credential Manager

# The secret to store (this is Flag 5)
$TargetName = "smb.queenrev"
$Username = "ironhook"
$Password = "brb{5d26ec0024167fdf8a45a70eff4ade36}"

# Create a scheduled task that runs as pirate1 to create the credential
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument @"
-NoProfile -ExecutionPolicy Bypass -Command "& {
    Add-Type -AssemblyName System.Runtime.InteropServices
    
    # P/Invoke for CredWrite
    `$sig = @'
    [DllImport("advapi32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool CredWrite(ref CREDENTIAL credential, uint flags);
    
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct CREDENTIAL {
        public uint Flags;
        public uint Type;
        public string TargetName;
        public string Comment;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
        public uint CredentialBlobSize;
        public IntPtr CredentialBlob;
        public uint Persist;
        public uint AttributeCount;
        public IntPtr Attributes;
        public string TargetAlias;
        public string UserName;
    }
'@
    
    # Use cmdkey to store the credential (simpler approach)
    cmdkey /generic:$TargetName /user:$Username /pass:$Password
}"
"@

# For simplicity, we'll use a batch script approach
$BatchContent = @"
@echo off
cmdkey /generic:smb.queenrev /user:ironhook /pass:brb{5d26ec0024167fdf8a45a70eff4ade36}
"@

$BatchPath = "C:\Windows\Temp\create_cred.bat"
Set-Content -Path $BatchPath -Value $BatchContent -Force

# Create a runas command to run as pirate1
Write-Host "To create the DPAPI credential, run the following as pirate1:"
Write-Host "  cmdkey /generic:smb.queenrev /user:ironhook /pass:brb{5d26ec0024167fdf8a45a70eff4ade36}"
Write-Host ""
Write-Host "Or run: runas /user:pirate1 `"$BatchPath`""
Write-Host ""
Write-Host "The credential will be stored in pirate1's DPAPI vault and can be"
Write-Host "recovered using dploot if you have pirate1's cleartext password."
