# VPC [flaia-vpc]: Initialize VPC
resource "aws_vpc" "flaia-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# SUBNET [public-subnet-(1 -> 4)]: Initialize public subnets
resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[1]
}

resource "aws_subnet" "public-subnet-3" {
  cidr_block        = var.public_subnet_3_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-subnet-4" {
  cidr_block        = var.public_subnet_4_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[1]
}


# SUBNET [private-subnet-1 --> 2]: Initialize private subnets
resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.flaia-vpc.id
  availability_zone = var.availability_zones[1]
}

# ROUTE TABLE [public & private]: Initialize route-table for public & private subnets
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.flaia-vpc.id
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.flaia-vpc.id
}

# ROUTE TABLE ASSOCIATION: Initialize route-table-associate for public & private subnets
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}
resource "aws_route_table_association" "public-route-3-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-3.id
}
resource "aws_route_table_association" "public-route-4-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-4.id
}
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

# ELASTIC IP [elastic-ip-for-nat-gw]: Initialize elastic IP
resource "aws_eip" "elastic-ip-for-nat-gw" {
  vpc                       = true
  associate_with_private_ip = "172.16.0.1"
  depends_on                = [aws_internet_gateway.internet-gw]
}

# NAT GATEWAY [nat-gw]: Allows public-subnet-1 to communicate with the internet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_eip.elastic-ip-for-nat-gw]
}

# INTERNET GATEWAY [internet-gw]: Allows VPC to communicate with the internet
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.flaia-vpc.id
}

# ROUTE [nat-gw-route]: Route the private subnet traffic through the NAT Gateway
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# ROUTE [internet-gw-route]: Route the public subnet traffic through the Internet Gateway
resource "aws_route" "internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id
  gateway_id             = aws_internet_gateway.internet-gw.id
  destination_cidr_block = "0.0.0.0/0"
}