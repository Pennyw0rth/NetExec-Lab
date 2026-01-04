# delegation.ps1 - Configure Kerberos Constrained Delegation without Protocol Transition
# Run this on the Domain Controller (BLACKPEARL)
# QUEENREV$ -> FLYINGDUTCHMAN$

Import-Module ActiveDirectory

# Variables
$Domain = "pirates.brb"
$SourceSPN = "QUEENREV"       # The account that will perform delegation
$TargetSPN = "FLYINGDUTCHMAN" # The service account to delegate to

# Get the computer accounts
$SourceAccount = Get-ADComputer -Identity $SourceSPN -Server $Domain
$TargetAccount = Get-ADComputer -Identity $TargetSPN -Server $Domain

# Build the SPN for delegation (host/flyingdutchman.pirates.brb)
$TargetServiceSPN = "host/$($TargetAccount.DNSHostName)"

# Enable constrained delegation (without protocol transition)
# This sets msDS-AllowedToDelegateTo attribute
Set-ADComputer -Identity $SourceAccount.DistinguishedName `
    -Add @{'msDS-AllowedToDelegateTo'=$TargetServiceSPN}

# Ensure the account is trusted for delegation (but NOT for any service - no protocol transition)
# TrustedForDelegation = Unconstrained delegation (NOT what we want)
# We want Constrained Delegation without Protocol Transition
Set-ADComputer -Identity $SourceAccount.DistinguishedName `
    -TrustedForDelegation $false

Write-Host "KCD without protocol transition configured for $SourceSPN to $TargetSPN"
Write-Host "Target SPN: $TargetServiceSPN"
