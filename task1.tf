provider "aws" {
	region = "ap-south-1"
}


resource "aws_key_pair" "key" {
  key_name   = "ritikkey2"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwLCDQyRQWe7iERqY8UAMxZ9yem68BRfn3PiN+bxRMN+tyB82mtpXsgmF4d02zW6sjgoAYoPPd/I3oTEFeDqksUnF5NGzZDzCZZCfFeubwhV4b5udssYfl3Mjm/qcZqjBVzmNOwbXRb/Yyt0ikYataMwsVCNn2DzFUVe4ZTgo7cd5eEAGMkKNKFs/Ip3uaufYioMEEsYCKSZt6XR6wEGOC6xaECcsKuIxIcqn9ExwvMcE9WKpZSE1yHgh2V6kYuoE89C98NLGJAB1y+ITWO57xVRD7aVtUNXGrZ3VT9D7hXuzdhrU0IWY2srp7DRe6ltmaAj1rGL7ZAtn2dsOV7lE1Q== rsa-key-20200615"
}

resource "aws_vpc" "main"{
	cidr_block = "10.0.0.0/16"
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  
  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    
  }

  tags = {
    Name = "allow_tls"
  }
}


resource "aws_instance" "task1" {
  ami           = "ami-052c08d70def0ac62"
  
  instance_type = "t2.micro"
  key_name = "ritikkey2"
  
  tags = {
    Name = "taskec2"
  }
}


resource "aws_ebs_volume" "ebs1" {
  availability_zone = aws_instance.task1.availability_zone
  size              = 1

  tags = {
    Name = "taskebs"
  }

}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.ebs1.id}"
  instance_id = "${aws_instance.task1.id}"
  force_detach = true
}
