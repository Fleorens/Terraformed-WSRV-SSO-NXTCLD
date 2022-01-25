resource "aws_security_group" "allow-all" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

name="allow-all"
egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
ingress {
from_port = 0
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}
 
tags = {
    Name = "allow_RDP"
  }
 
}
