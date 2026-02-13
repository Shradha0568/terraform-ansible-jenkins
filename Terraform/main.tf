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


resource "aws_instance" "dev_machine" {
  ami = data.aws_ami.amazon-linux.id
  instance_type = "t3.micro"
  key_name = "euran-jenkins"

  tags = {
    Environment = "dev"
    Name = "${var.name}-server"
  }
}
