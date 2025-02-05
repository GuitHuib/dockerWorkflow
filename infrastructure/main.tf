terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

#define aws as provider and region to use
provider "aws" {
  region = "us-east-1"
}

#set security rules for instance
resource "aws_security_group" "allow_ssh_http" {
  name = "allow_ssh_http"
  description = "Allow SSH and HTTP access"

  ingress {
    #allow ssh
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    #allow http
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    #allow responses
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#define ec2 instance
resource "aws_instance" "terraform_server" {
  ami = "ami-0c614dee691cbbf37" #default amazon linux AMI
  instance_type = "t2.micro" #instance size
  key_name = "DemoKeyPair" # previously existing key pair
  security_groups = [aws_security_group.allow_ssh_http.name] #references earlier defined security rules

  tags = {
    name = "Demo-EC2"
  }

  #verifies ssh into new ec2 instance
  provisioner "remote-exec" {
    inline = ["echo 'EC2 instance created'"]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = file("/mnt/c/Users/rwall/Downloads/DemoKeyPair.pem")
      host = self.public_ip
    }
  }

  #after verifying ssh, runs ansible playbook to set up docker image
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${self.public_ip},' --private-key /mnt/c/Users/rwall/Downloads/DemoKeyPair.pem playbook.yml"
  }
}

#output ip address for us to reference as needed
output "ec2_public_ip" {
  value = aws_instance.terraform_server.public_ip
}