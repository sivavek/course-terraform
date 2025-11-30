data "aws_ami" "ubuntu-ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu-ami.id
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public-http-ingress.id]
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }
  tags = merge(local.common_tags, {
    Name = "06-resources-ec2"
  })
}

resource "aws_security_group" "public-http-ingress" {
  description = "Allow HTTP inbound traffic"
  name        = "public-http-ingress"
  vpc_id      = aws_vpc.main.id
  tags = merge(local.common_tags, {
    Name = "06-resources-public-http-ingress"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.public-http-ingress.id
}
resource "aws_vpc_security_group_ingress_rule" "https" {
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  security_group_id = aws_security_group.public-http-ingress
}
