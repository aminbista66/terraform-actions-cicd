# vpc
resource "aws_vpc" "demo_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "demo-vpc"
  }
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "demo-internet-gateway"
  }
}

# subnet (one public and one private)
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = var.private_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "demo-private-subnet"
  }
}

# route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-subnet-rt"
  }
}

# route table association 
resource "aws_route_table_association" "rta" {
 subnet_id      = aws_subnet.public_subnet.id
 route_table_id = aws_route_table.rt.id
}