provider "aws" {
  region = "us-west-1"
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami             = "ami-04fdea8e25817cd69"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name = "Test Ec2"
  }
}

# elastice IP
resource "aws_eip" "my_eip" {
  instance = aws_instance.my_ec2.id
}

# SGroupe
resource "aws_security_group" "my_sg" {
  name        = "allow HTTPS"
  description = "Allow HTTPS traffic"

  ingress {
    description = "allow Inbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_https"
  }
}

output "EIP" {
  value = aws_eip.my_eip.public_ip
}
