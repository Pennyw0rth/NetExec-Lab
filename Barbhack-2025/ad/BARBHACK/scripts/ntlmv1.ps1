# ntlmv1.ps1 - Enable NTLMv1 on JOLLYROGER only
# Run as Administrator on JOLLYROGER (srv01)

# Enable NTLMv1 locally (lab/testing only)
# LmCompatibilityLevel values:
# 0 = Send LM & NTLM responses
# 1 = Send LM & NTLM - use NTLMv2 session security if negotiated
# 2 = Send NTLM response only
# 3 = Send NTLMv2 response only
# 4 = Send NTLMv2 response only, refuse LM
# 5 = Send NTLMv2 response only, refuse LM & NTLM

New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" `
    -Name "LmCompatibilityLevel" -PropertyType DWord -Value 1 -Force

Write-Host "NTLMv1 enabled on this server (LmCompatibilityLevel = 1)"
Write-Host "This server will now accept NTLMv1 authentication and can be relayed to LDAP"
