#$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
#$DefaultUsername = "admin"
#$DefaultPassword = "passwd12345+"
#Set-ItemProperty $RegPath "AutoAdminLogon" -Value "1" -type String 
#Set-ItemProperty $RegPath "DefaultUsername" -Value "$DefaultUsername" -type String
#Set-ItemProperty $RegPath "DefaultPassword" -Value "$DefaultPassword" -type String

##  Create ADDS-ADFS_Install Task Scheduled

$taskName = "ADDS-ADFS_Install"
$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\script_installadds.ps1"'
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8
$principal = New-ScheduledTaskPrincipal -GroupId BUILTIN\Administrators -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description "Run $taskName Now"
Register-ScheduledTask -TaskName $taskName -InputObject $definition