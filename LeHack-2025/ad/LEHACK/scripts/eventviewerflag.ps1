# Create a fake but legitimate-looking event source
$source = "SystemCheck"
$logName = "System"

# Register event source if it doesn't exist
if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    New-EventLog -LogName $logName -Source $source
}

# Create a realistic-looking but custom system message with the hidden flag
$fakeMessage = @"
The Service Control Manager has successfully sent a start control to the following service: WinEventMon.
Service name: WinEventMon
Service type: User-mode service
Service start type: Auto start
Service account: LocalSystem

Additional Information:
Diagnostic Code: 0x0000C000 (Informational)

[Note 0x13]: Event processed normally.
Refer to internal report ID #brb{e2553688e2db0e8ea7dcfae683d28a84} for audit trail.
"@

# Write the event
Write-EventLog -LogName $logName `
    -Source $source `
    -EntryType Information `
    -EventId 7036 `
    -Message $fakeMessage `
    -Category 0
