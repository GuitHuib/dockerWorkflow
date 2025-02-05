terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}

# resource "aws_key_pair" "ssh_key" {
#   key_name = "DemoKeyPair"
#   public_key = var.EC2_PUBLIC_KEY
# }

resource "aws_security_group" "allow_ssh_http" {
  name = "allow_ssh_http"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_server" {
  ami = "ami-0c614dee691cbbf37"
  instance_type = "t2.micro"
  # key_name = aws_key_pair.ssh_key.key_name
  key_name = "DemoKeyPair"
  security_groups = [aws_security_group.allow_ssh_http.name]

  tags = {
    name = "Demo-EC2"
  }

  provisioner "remote-exec" {
    inline = ["echo 'EC2 instance created'"]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("/mnt/c/Users/rwall/Downloads/DemoKeyPair.pem")
      host = self.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key /mnt/c/Users/rwall/Downloads/DemoKeyPair.pem playbook.yml"
  }
}

output "ec2_public_ip" {
  value = aws_instance.terraform_server.public_ip
}