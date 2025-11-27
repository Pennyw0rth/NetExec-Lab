# https://learn.microsoft.com/fr-fr/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon
if(-not(query session grievoussssss /server:mustafar)) {
  #kill process if exist
  Get-Process mstsc -IncludeUserName | Where {$_.UserName -eq "EMPIRE\grievoussssss"}|Stop-Process
  #run the command
  mstsc /v:mustafar
}
