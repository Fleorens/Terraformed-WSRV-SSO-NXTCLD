Install-WindowsFeature RSAT-AD-Tools -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools -IncludeAllSubFeature
Install-WindowsFeature DNS -IncludeManagementTools -IncludeAllSubFeature

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
'-NoRebootOnCompletion' = $false;
'-SysvolPath' = 'C:\Windows\SYSVOL';
'-Force' = $true;
'-CreateDnsDelegation' = $false }

Import-Module ADDSDeployment
Install-ADDSForest @ForestConfiguration

New-ADUser `
          -SamAccountName "cesimsi" `
          -UserPrincipalName "cesimsi@groupefyb.fr" `
          -Name "CESI MSI" `
          -GivenName "CESI" `
          -Surname "MSI" `
          -Enabled $True `
          -Department "IT" `
          -AccountPassword (convertto-securestring "passwd12345+" -AsPlainText -Force)
Add-AdGroupMember -Identity "Domain Admins" -Members "cesimsi"
Rename-Computer -NewName WSRV-AD -Force
