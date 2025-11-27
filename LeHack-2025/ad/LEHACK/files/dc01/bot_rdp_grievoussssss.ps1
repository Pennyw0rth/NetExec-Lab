# https://learn.microsoft.com/fr-fr/troubleshoot/windows-server/user-profiles-and-logon/turn-on-automatic-logon
if(-not(query session grievoussssss /server:mustafar)) {
  #kill process if exist
  Get-Process mstsc -IncludeUserName -ErrorAction SilentlyContinue | Where {$_.UserName -eq "EMPIRE\grievoussssss"} | Stop-Process -ErrorAction SilentlyContinue
  #run the command
  mstsc /v:mustafar
}
