
provider "aws" {
    region = "ap-south-1"
    #access_key = "YOUR_ACCESS_KEY"
    #secret_key = "YOUR_SECRET_KEY"   i already did aws configure and configure it on linux shell screen
}

##variables Declarations ##

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}
variable "region" {}
variable "avail_zone" {}
variable "my_ip" {}
variable "instance_type" {}


#####################

resource "aws_vpc" "Vickie-VPC" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env_prefix}-VPC"
  }
}

resource "aws_subnet" "Vickie_Subnet" {
  vpc_id            = aws_vpc.Vickie-VPC.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone

  tags = {
    Name = "${var.env_prefix}-Subnet"
  }
}

  output "aws_vpc" {                                                     ## Shows the VPC ID in the output after terraform apply
    value = aws_vpc.Vickie-VPC.id                           
      }

  output "aws_subnet" {                                                  ## Shows the VPC ID in the output after terraform apply
    value = aws_subnet.Vickie_Subnet.id
      }



resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.Vickie-VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }

  tags = {
    Name = "${var.env_prefix}-Route-Table"
  }
}

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.Vickie-VPC.id

  tags = {
    Name = "${var.env_prefix}-Internet-Gateway"
  }
  
}


output "aws_route_table" {                                                  ## Shows the VPC ID in the output after terraform apply
    value = aws_route_table.myapp-route-table.id
      }

output "aws_internet_gateway" {                                                  ## Shows the VPC ID in the output after terraform apply
    value = aws_internet_gateway.myapp-igw.id
      }

resource "aws_route_table_association" "myapp-route-table-association" {
  subnet_id      = aws_subnet.Vickie_Subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}

output "aws_route_table_association" {                                                  ## Shows the VPC ID in the output after terraform apply
    value = aws_route_table_association.myapp-route-table-association.id
      }


resource "aws_security_group" "myapp-sg" {
    name = "mysg"
    vpc_id = aws_vpc.Vickie-VPC.id
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
   }

   ingress {
    
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
   }

   tags = {
        Name = "${var.env_prefix}-Security-Group"
   }
}

output "aws_security_group" {                                                  ## Shows the VPC ID in the output after terraform apply
    value = aws_security_group.myapp-sg.id
      }


data "aws_ami" "myapp-ami" {                     # data we use since it is already available in AWS and we don't need to create it. We can use this data source to get the latest AMI ID for Amazon Linux 2.
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



data "aws_ami" "latest-rhel8-sql" {
  most_recent = true
  #owners      = ["435044164105"]

  filter {
    name   = "image-id"
    values = ["ami-0011550b539717e2a"]
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

resource "aws_instance" "my_server" {
  ami                         = data.aws_ami.latest-rhel8-sql.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Vickie_Subnet.id
  vpc_security_group_ids      = [aws_security_group.myapp-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name = "server-build"

  tags = {
    Name = "${var.env_prefix}-server"
  }
}