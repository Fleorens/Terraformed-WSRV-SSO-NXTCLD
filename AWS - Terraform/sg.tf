resource "aws_security_group" "allow-all" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

name="allow-ssh-http-https-rdp-ldap-icmp-winrm"
egress {
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 443
to_port = 443
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 8080
to_port = 8080
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 8081
to_port = 8081
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 8082
to_port = 8082
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 3389
to_port = 3389
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 389
to_port = 389
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 636
to_port = 636
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = 5985
to_port = 5986
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}

egress {
from_port = -1
to_port = -1
protocol = "icmp"
cidr_blocks = ["0.0.0.0/0"]
}

ingress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
    Name = "allow-ssh-http-https-rdp-ldap-icmp"
  }
 
}
