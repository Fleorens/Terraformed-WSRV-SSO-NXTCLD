resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
 
 
data "template_file" "userdata_win" {
  template = <<EOF
<script>
echo "" > _INIT_STARTED_
net user ${var.INSTANCE_USERNAME} /add /y
net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD}
net localgroup administrators ${var.INSTANCE_USERNAME} /add
echo ${base64encode(file("./test.txt"))} > tmp2.b64 && certutil -decode tmp2.b64 C:/test.txt
echo "" > _INIT_COMPLETE_
</script>
<persist>false</persist>
EOF
}
 
 
resource "aws_instance" "win-example" {
  ami           = var.WIN_AMIS[var.AWS_REGION]
  instance_type = "t2.micro"
  key_name      = aws_key_pair.mykey.key_name
  user_data = data.template_file.userdata_win.rendered
  vpc_security_group_ids=["${aws_security_group.allow-all.id}"]
 
  tags = {
    Name = "Windows_Server"
  }
 
}
 
output "ip" {
 
value="${aws_instance.win-example.public_ip}"
 
}