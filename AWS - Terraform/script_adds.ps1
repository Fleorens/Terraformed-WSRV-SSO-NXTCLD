  $SafeModeClearPassword = "passwd12345+"
  $SafeModeAdministratorPassword = ConvertTo-SecureString $SafeModeClearPassword -AsPlaintext -Force
  $DomainNameDNS = "groupefyb.fr"
  $DomainNameNetbios = "GROUPEFYB"
  
  $ForestConfiguration = @{
  '-DatabasePath'= 'C:\Windows\NTDS';
  '-DomainMode' = 'Default';
  '-DomainName' = $DomainNameDNS;
  '-DomainNetbiosName' = $DomainNameNetbios;
  '-SafeModeAdministratorPassword' = $SafeModeAdministratorPassword;
  '-ForestMode' = 'Default';
  '-InstallDns' = $true;
  '-LogPath' = 'C:\Windows\NTDS';
  '-NoRebootOnCompletion' = $true;
  '-SysvolPath' = 'C:\Windows\SYSVOL';
  '-Force' = $true;
  '-CreateDnsDelegation' = $false }
  
  Import-Module ADDSDeployment
  Install-ADDSForest @ForestConfiguration
  
  Unregister-ScheduledTask -TaskName "ADDS_Configure" -Confirm:$false

  $taskName = "ADFS_Configure"
  $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
  $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-File "C:\script_adfs.ps1"'
  $trigger = New-ScheduledTaskTrigger -AtLogon
  $settings = New-ScheduledTaskSettingsSet -Compatibility Win8
  $principal = New-ScheduledTaskPrincipal -GroupId BUILTIN\Administrators -RunLevel Highest
  $definition = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings -Description "Run $($taskName) at startup"
  Register-ScheduledTask -TaskName $taskName -InputObject $definition
  
  Start-Sleep -Seconds 20

  Restart-Computer
