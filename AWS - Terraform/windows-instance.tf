resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "win-example" {
  ami           = var.WIN_AMIS[var.AWS_REGION]
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  key_name      = aws_key_pair.mykey.key_name
  user_data = data.template_file.userdata_win.rendered
  vpc_security_group_ids=["${aws_security_group.allow-all.id}"]

  tags = {
    Name = "Windows_Server"
  }
 
}

data "template_file" "userdata_win" {
  template = <<EOF
<script>
echo "" > _INIT_STARTED_
net user ${var.INSTANCE_USERNAME} /add /y
net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD}
net localgroup administrators ${var.INSTANCE_USERNAME} /add
Enable-PSRemoting -Force
winrm quickconfig -q & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
echo "" > _INIT_COMPLETE_
</script>
<powershell>
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
</powershell>
<persist>false</persist>
EOF
}

output "ip" {
 
value="${aws_instance.win-example.public_ip}"
 
}