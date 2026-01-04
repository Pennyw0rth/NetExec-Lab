# ntds_backup.ps1 - Create NTDS backup on FLYINGDUTCHMAN
# Run as Administrator on FLYINGDUTCHMAN (srv03)
# Note: This needs to be run from the DC or copy the backup folder manually

# This script creates a backup that would typically be created with:
# ntdsutil "activate instance ntds" "ifm" "create full C:\BACKUP\NTDS" quit quit

# For this lab, you need to manually create the backup folder structure
# and place the ntds.dit file there

$BackupPath = "C:\BACKUP\NTDS"

# Create the directory structure
New-Item -ItemType Directory -Path "$BackupPath\Active Directory" -Force | Out-Null
New-Item -ItemType Directory -Path "$BackupPath\Registry" -Force | Out-Null

Write-Host "NTDS backup directory structure created at $BackupPath"
Write-Host ""
Write-Host "To complete the lab setup, you need to:"
Write-Host "1. Create an NTDS backup on the DC using:"
Write-Host '   ntdsutil "activate instance ntds" "ifm" "create full C:\BACKUP\NTDS" quit quit'
Write-Host ""
Write-Host "2. Modify the ntds.dit to include a password in blackbeard's description"
Write-Host "   (This represents an old backup with sensitive data)"
Write-Host ""
Write-Host "3. Copy the backup to FLYINGDUTCHMAN C:\BACKUP\NTDS\"
