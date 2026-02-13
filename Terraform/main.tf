data "aws_ami" "amazon-linux" {
  most_recent = true

  owners = ["137112412989"] # Amazon official account

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group" "web_sg" {
  name = "${var.name}-sg"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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

resource "aws_instance" "dev_machine" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = "t3.micro"
  key_name      = "euran-jenkins"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Environment = "dev"
    Name        = "${var.name}-server"
  }
}

output "instance_ip" {
  value = aws_instance.dev_machine.public_ip
}

