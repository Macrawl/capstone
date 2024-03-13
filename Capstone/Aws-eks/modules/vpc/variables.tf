variable "vpc_name" {
  type = string
  description = " name of the vpc"
}

variable "cidr_block" {
  type = string
  description = " cidr block for the vpc"
}

variable "public_subnet_cidr_block" {
  type = string
  description = " cidr block for the public subnet"
}

variable "public_subnet_name" {
  type = string
  description = "the public subnet"
}

variable "private_subnet_cidr_block" {
  type = string
  description = "the cidr block for the private subnet"
}

variable "private_subnet_name" {
  type = string
  description = " the name of the private subnet"
}

variable "availability_zone" {
  type = string
  description = "the availability zone for the subnet"
}

variable "nat_gateway_name" {
  type = string
  description = "the nat gateway name"
}
variable "igw_name" {
  type = string
  description = "the name of the internet gateway"
}

variable "public_route_table_name" {
  type = string
  description = "the name of the public route table"
}

variable "private_route_table_name" {
  type = string
  description = "the name of the private route table"
}

variable "public_security_group_name" {
  type = string
  description = "the name of the public security group"
}

variable "private_security_group_name" {
  type = string
  description = "the name of the private security group"
}