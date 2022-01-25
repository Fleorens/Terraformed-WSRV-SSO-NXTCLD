resource "aws_instance" "app_server" {
  ami           = "ami-0e472ba40eb589f49"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  key_name=aws_key_pair.mykey.key_name
  vpc_security_group_ids = ["${aws_security_group.allow-all.id}"]
  provisioner "file" {
    source      = "docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yml"
    connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("mykey.pem")
  }
  }
 
  provisioner "remote-exec" {
    inline = [
      "sudo snap install docker",
      "cd /home/ubuntu",
      "sudo docker-compose up -d"
    ]
    connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = file("mykey.pem")
  }
  }
  tags = {
    Name = "Nextcloud-Server"
  }
  
}