provider "aws" {
  region = var.region
}

# Get latest AMI ID for Amazon Linux2 OS
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
} 

#To generate the pem file
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


#Create the public key that will be used to access AWS
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

#private key that will be saved in the local machine in order to authenticate the public key before ssh into aws

resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096.private_key_pem
    filename = var.key_name           
}

resource "aws_instance" "instance" {
  ami = data.aws_ami.ubuntu.id
  key_name = aws_key_pair.my_key_pair.key_name
}
