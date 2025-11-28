# Store krennic credentials for RDP connection to Mustafar
cmdkey /generic:TERMSRV/mustafar.empire.local /user:empire.local\krennic /pass:liu8Sith

# Create scheduled task that runs mstsc when Administrator logs on
$taskName = "RDP_Krennic_Mustafar"
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\mstsc.exe" -Argument "/v:mustafar.empire.local"
$trigger = New-ScheduledTaskTrigger -AtLogOn -User "EMPIRE\Administrator"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName }
if($taskExists) {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -User "EMPIRE\Administrator" -RunLevel Highest
