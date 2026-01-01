# disable_ntlm.ps1 - Disable outgoing NTLM on QUEENREV, FLYINGDUTCHMAN, BLACKPEARL
# Run as Administrator on each server (or remotely from DC)

# This prevents these servers from sending NTLMv1 responses when coerced
# Only JOLLYROGER should respond with NTLMv1

$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"

# Ensure the registry path exists
if (-not (Test-Path $RegPath)) { 
    New-Item -Path $RegPath -Force | Out-Null 
}

# RestrictSendingNTLMTraffic = 2 (Deny all outgoing NTLM traffic)
New-ItemProperty -Path $RegPath -Name "RestrictSendingNTLMTraffic" -PropertyType DWord -Value 2 -Force

# Also set the Network Security policy via LSA
$LsaPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
# LmCompatibilityLevel = 5 (Send NTLMv2 response only. Refuse LM & NTLM)
New-ItemProperty -Path $LsaPath -Name "LmCompatibilityLevel" -PropertyType DWord -Value 5 -Force

Write-Host "Outgoing NTLM disabled on $env:COMPUTERNAME"
Write-Host "This server will not send NTLM responses when coerced"
