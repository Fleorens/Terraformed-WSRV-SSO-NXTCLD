Install-WindowsFeature RSAT-AD-Tools -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature DNS -IncludeManagementTools -IncludeAllSubFeature

Install-WindowsFeature ADFS-Federation -IncludeManagementTools

$taskName2 = "ADDS_Configure"
$task = Get-ScheduledTask -TaskName $taskName2 -ErrorAction SilentlyContinue
$action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\script_adds.ps1"'
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -Compatibility Win8
$principal = New-ScheduledTaskPrincipal -GroupId BUILTIN\Administrators -RunLevel Highest
$definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description "Run $taskName2 Now"
Register-ScheduledTask -TaskName $taskName2 -InputObject $definition

Unregister-ScheduledTask -TaskName "ADDS-ADFS_Install" -Confirm:$false

Start-Sleep -Seconds 20

Rename-Computer WSRV

Restart-Computer