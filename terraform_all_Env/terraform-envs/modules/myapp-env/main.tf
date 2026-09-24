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

resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.Vickie-VPC.id

  tags = {
    Name = "${var.env_prefix}-Internet-Gateway"
  }
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

resource "aws_route_table_association" "myapp-route-table-association" {
  subnet_id      = aws_subnet.Vickie_Subnet.id
  route_table_id = aws_route_table.myapp-route-table.id
}

resource "aws_security_group" "myapp-sg" {
  name   = "${var.env_prefix}-sg"
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

data "aws_ami" "latest-rhel8-sql" {
  most_recent = true

  filter {
    name   = "image-id"
    values = [var.ami_id]
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
  key_name                    = var.key_name

  tags = {
    Name = "${var.env_prefix}-server"
  }
}
