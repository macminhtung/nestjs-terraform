# =========== #
# ==> VPC <== #
# =========== #
resource "aws_vpc" "hrforte-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# ====================== #
# ==> PUBLIC NETWORK <== #
# ====================== #

# ==> INTERNET GATEWAY
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.hrforte-vpc.id
}

# SUBNET [public-subnet-(1 -> 2)]
resource "aws_subnet" "public-subnet-1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.hrforte-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "public-subnet-2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.hrforte-vpc.id
  availability_zone = var.availability_zones[1]
}

# ROUTE TABLE: Allow Public subnets (1) traffic through the Internet Gateway(2)
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.hrforte-vpc.id
}
resource "aws_route" "internet-gw-route" {
  route_table_id         = aws_route_table.public-route-table.id // <== (1)
  gateway_id             = aws_internet_gateway.internet-gw.id // <== (2)
  destination_cidr_block = "0.0.0.0/0"
}

# ROUTE TABLE ASSOCIATION: Associate [public-subnet-(1 -> 2)] with a [public-route-table]
resource "aws_route_table_association" "public-route-1-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-1.id
}
resource "aws_route_table_association" "public-route-2-association" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public-subnet-2.id
}

# NAT GATEWAY: Use the NAT Gateway to forward Internet access requests over the Public subnet.
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic-ip-for-nat-gw.id
  subnet_id     = aws_subnet.public-subnet-1.id
  depends_on    = [aws_internet_gateway.internet-gw]
  tags = {
    Name = "${var.project_name} NAT gateway"
  }
}

# ELASTIC IP: Elastic IP is PublicIB was attached to NAT gateway, help NAT gateway communicate with the Internet
resource "aws_eip" "elastic-ip-for-nat-gw" {
  depends_on                = [aws_internet_gateway.internet-gw]
}

# ======================= #
# ==> PRIVATE NETWORK <== #
# ======================= #

# SUBNET [private-subnet-(1 -> 2)]
resource "aws_subnet" "private-subnet-1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.hrforte-vpc.id
  availability_zone = var.availability_zones[0]
}
resource "aws_subnet" "private-subnet-2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.hrforte-vpc.id
  availability_zone = var.availability_zones[1]
}

# ROUTE TABLE: Route the Private subnet(1) traffic through the NAT Gateway (2)
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.hrforte-vpc.id
}
resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private-route-table.id // <== (1)
  nat_gateway_id         = aws_nat_gateway.nat-gw.id // <== (2)
  destination_cidr_block = "0.0.0.0/0"
}

# ROUTE TABLE ASSOCIATION: Associate [private-subnet-(1 -> 2)] with a [private-route-table]
resource "aws_route_table_association" "private-route-1-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-1.id
}
resource "aws_route_table_association" "private-route-2-association" {
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = aws_subnet.private-subnet-2.id
}

