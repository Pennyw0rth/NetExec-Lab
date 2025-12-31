# disable_ntlm.ps1 - Disable outgoing NTLM on QUEENREV, FLYINGDUTCHMAN, BLACKPEARL
# Run as Administrator on each server (or remotely from DC)

# This prevents these servers from sending NTLMv1 responses when coerced
# Only JOLLYROGER should respond with NTLMv1

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$ValueName = "RestrictSendingNTLM"
$ValueData = 1  # Deny outgoing NTLM

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) { 
    New-Item -Path $RegPath -Force | Out-Null 
}

# Set the registry value
New-ItemProperty -Path $RegPath -Name $ValueName -PropertyType DWord -Value $ValueData -Force

Write-Host "Outgoing NTLM disabled on $env:COMPUTERNAME"
Write-Host "This server will not send NTLM responses when coerced"
