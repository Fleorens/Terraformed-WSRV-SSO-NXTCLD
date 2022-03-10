resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "win-example" {
  ami           = var.WIN_AMIS[var.AWS_REGION]
  instance_type = "t3.medium"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  key_name      = aws_key_pair.mykey.key_name
  vpc_security_group_ids=["${aws_security_group.allow-all.id}"]
  get_password_data = "true"
  tags = {
    Name = "Windows_Server"
  }

user_data = <<EOF

<script>
echo "" > _INIT_STARTED_
net user ${var.INSTANCE_USERNAME} /add /y
net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD}
net localgroup administrators ${var.INSTANCE_USERNAME} /add
net user "cesimsi" /add /y
net user "cesimsi" ${var.INSTANCE_PASSWORD}
net localgroup administrators "cesimsi" /add
Enable-PSRemoting -Force
echo "" > _INIT_COMPLETE_
</script>
<powershell>
netsh advfirewall firewall add rule name="SSH 22" protocol=TCP dir=in localport=22 action=allow

Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
</powershell>
<persist>false</persist>
EOF
provisioner "file" {
    source = "script_installadds.ps1"
    destination = "C:/script_installadds.ps1"
connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
provisioner "file" {
    source = "script_adds.ps1"
    destination = "C:/script_adds.ps1"
connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
provisioner "file" {
    source = "script_adfs.ps1"
    destination = "C:/script_adfs.ps1"
connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
provisioner "file" {
    source = "script_runscript.ps1"
    destination = "C:/script_runscript.ps1"
connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
provisioner "file" {
    source = "script_get_x509.ps1"
    destination = "C:/script_get_x509.ps1"
connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
provisioner "remote-exec" {
    inline = [
            "powershell.exe Set-ExecutionPolicy Unrestricted -force",
            "powershell.exe C:/script_runscript.ps1",
            ]
   connection {
    host = self.public_ip
    type = "ssh"
    user = "Administrator"
    timeout = "10m"
    target_platform = "windows"
    password = "${rsadecrypt(aws_instance.win-example.password_data,file("mykey.pem"))}"
  }
}
}