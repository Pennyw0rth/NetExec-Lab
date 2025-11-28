# Create a script that will be executed at logon to store credentials and launch RDP
$rdpScriptPath = "C:\Windows\Tasks\rdp_connect_krennic.ps1"
$rdpScriptContent = @'
# Store krennic credentials for RDP connection to Mustafar (must run in interactive session)
cmdkey /generic:TERMSRV/mustafar.empire.local /user:empire.local\krennic /pass:liu8Sith
# Small delay to ensure credentials are stored
Start-Sleep -Seconds 2
# Launch RDP connection to Mustafar
Start-Process "C:\Windows\System32\mstsc.exe" -ArgumentList "/v:mustafar.empire.local"
'@

# Write the script to disk
Set-Content -Path $rdpScriptPath -Value $rdpScriptContent -Force

# Create scheduled task that runs the script when Administrator logs on interactively
$taskName = "RDP_Krennic_Mustafar"
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"$rdpScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "EMPIRE\Administrator"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName }
if($taskExists) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -User "EMPIRE\Administrator" -RunLevel Highest
