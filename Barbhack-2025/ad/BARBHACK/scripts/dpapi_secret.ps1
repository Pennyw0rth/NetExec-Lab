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

# Create a scheduled task that runs as pirate1 to create the credential
$TaskName = "CreateDPAPICredential"

# Remove existing task if present
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

# Create the action - run cmdkey to store credential
$Action = New-ScheduledTaskAction -Execute "cmdkey.exe" -Argument "/generic:$TargetName /user:$Username /pass:$Password"

# Create the task to run as pirate1
$Task = New-ScheduledTask -Action $Action -Description "Create DPAPI credential for pirate1"

# Register and run the task as pirate1
Register-ScheduledTask -TaskName $TaskName -InputObject $Task -User $Pirate1User -Password $Pirate1Pass -RunLevel Highest

# Run the task immediately
Start-ScheduledTask -TaskName $TaskName

# Wait for task to complete
Start-Sleep -Seconds 5

# Clean up - remove the task
Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue

Write-Host "DPAPI credential created for pirate1 user"
Write-Host "Target: $TargetName"
Write-Host "Username: $Username"
Write-Host "This can be recovered using dploot with pirate1's password (P@ssw0rd)"
