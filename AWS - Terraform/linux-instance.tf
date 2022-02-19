resource "aws_instance" "cloud_srv" {
  ami           = "ami-033b95fb8079dc481"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  key_name=aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.allow-all.id}"]

  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ec2-user/docker-compose.yml"
    connection {
    host = self.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("mykey.pem")
  }
  }

    provisioner "file" {
    source      = ".env"
    destination = "/home/ec2-user/.env"
    connection {
    host = self.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("mykey.pem")
  }
  }
 
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo systemctl enable docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",
      "sudo chmod +x /usr/local/bin/docker-compose",
      "sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose",
      "cd /home/ec2-user/",
      "sudo docker-compose up -d"
    ]
    connection {
    host = self.public_ip
    type = "ssh"
    user = "ec2-user"
    private_key = file("mykey.pem")
  }
  }
  tags = {
    Name = "Nextcloud-Server"
  }
  
}