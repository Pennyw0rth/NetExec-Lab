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

Write-Host "Creating DPAPI credential for pirate1..."

# Task name
$TaskName = "CreateDPAPICredential"

# Delete existing task if present
schtasks /delete /tn $TaskName /f 2>$null

# Create scheduled task to run cmdkey as pirate1
schtasks /create /tn $TaskName /tr "cmdkey /generic:$TargetName /user:$Username /pass:$Password" /sc once /st 00:00 /ru $Pirate1User /rp $Pirate1Pass /f

if ($LASTEXITCODE -eq 0) {
    # Run the task immediately
    schtasks /run /tn $TaskName
    
    # Wait for task to complete
    Start-Sleep -Seconds 5
    
    # Clean up - remove the task
    schtasks /delete /tn $TaskName /f
    
    Write-Host "DPAPI credential created for pirate1 user"
    Write-Host "Target: $TargetName"
    Write-Host "Username: $Username"
    Write-Host "This can be recovered using dploot with pirate1's password (P@ssw0rd)"
    
    # Remove pirate1 from Administrators group (no longer needed)
    Remove-LocalGroupMember -Group "Administrators" -Member $Pirate1User -ErrorAction SilentlyContinue
    Write-Host "Removed pirate1 from Administrators group"
} else {
    Write-Host "ERROR: Failed to create scheduled task"
    exit 1
}
