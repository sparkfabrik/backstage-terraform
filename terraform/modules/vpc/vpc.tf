resource "aws_vpc" "backstage_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_classiclink = false
  instance_tenancy = "default"
  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets
  vpc_id = aws_vpc.backstage_vpc.id
  cidr_block = each.value
  map_public_ip_on_launch = true
  availability_zone = each.key
  tags = {
    Name = "${var.project}-public-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "backstage_igw" {
  vpc_id = aws_vpc.backstage_vpc.id
  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_route_table" "backstage_public_crt" {
  vpc_id = aws_vpc.backstage_vpc.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.backstage_igw.id
  }
  tags = {
    Name = "${var.project}-public-crt"
  }
}

resource "aws_route_table_association" "public_route"{
  for_each = aws_subnet.public_subnets
  subnet_id = each.value.id
  route_table_id = aws_route_table.backstage_public_crt.id
}
