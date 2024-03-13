
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = var.availability_zone
  
  tags = {
    Name = var.private_subnet_name
  }
}

resource "aws_internet_gateway" "main" {
  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public-route-table-association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route-table.id
}


resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public_subnet.id
  tags = {
    Name = var.nat_gateway_name
  }
}

resource "aws-route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private-route-table-association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_security_group" "public-security-group" {
  name        = var.public_security_group_name
  description = "Allow ssh, http and https inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh inbound traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = "41.58.240.33/32"
  }

  ingress {
    description      = "Allow http inbound traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"
  }

  ingress {
    description      = "Allow https inbound traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = "0.0.0.0/0"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.public_security_group_name
  }
}

resource "aws_security_group" "private-security-group" {
  name        = var.private_security_group_name
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh inbound traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = aws_subnet.public_subnet.cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = "0.0.0.0/0"
  }
}
