# Define the registry path
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint"

# Check if the registry path exists, if not, create it
if (-Not (Test-Path $registryPath)) {
    Write-Host "Registry path does not exist. Creating the path..."
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers" -Name "PointAndPrint" -Force
}

# Set the RestrictDriverInstallationToAdministrators to 0 (Allow non-admins to install printer drivers)
Set-ItemProperty -Path $registryPath -Name "RestrictDriverInstallationToAdministrators" -Value 0 -Type DWord

# Set the NoWarningNoElevationOnInstall to 1 (Do not show warning or elevation prompt)
Set-ItemProperty -Path $registryPath -Name "NoWarningNoElevationOnInstall" -Value 1 -Type DWord

Write-Host "Registry settings have been applied successfully."


#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" -Name "RestrictDriverInstallationToAdministrators" -Value 0 -Type DWord
#Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" -Name "NoWarningNoElevationOnInstall" -Value 1 -Type DWord
