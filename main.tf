provider "aws" {
    region = "eu-north-1"
}

resource "aws_key_pair" "default" {
    key_name = "my-key"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_security_group" "resume-server" {
  name        = "web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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
}

resource "aws_instance" "resume-server" {
    ami = "ami-075449515af5df0d1"
    instance_type = "t3.micro"
    key_name = aws_key_pair.default.key_name
    security_groups = [aws_security_group.resume-server.name]

    tags = {
        Name = "ResumeServer"
    }
}

output "vps_ip" {
    value = aws_instance.resume-server.public_ip
}

resource "aws_route53_zone" "dns-records" {
    name = "herkuskrisciunas.me"
}

resource "aws_route53_record" "herkuskrisciunas" {
    zone_id = aws_route53_zone.dns-records.zone_id
    name = "herkuskrisciunas.me"
    type = "A"
    ttl = 300
    records = [aws_instance.resume-server.public_ip]
}

resource "aws_route53_record" "www" {
    zone_id = aws_route53_zone.dns-records.zone_id
    name = "www.herkuskrisciunas.me"
    type = "CNAME"
    ttl = 300
    records = ["herkuskrisciunas.me"]
}