###########################################################
# VPC
###########################################################
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    { Name = "${var.name}-vpc" },
    var.common_tags
  )
}

###########################################################
# Internet Gateway
###########################################################
resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = merge(
    { Name = "${var.name}-igw" },
    var.common_tags
  )
}

###########################################################
# Public Subnets
###########################################################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    { Name = "${var.name}-public-subnet-${count.index}" },
    var.common_tags
  )
}

###########################################################
# Public routes
###########################################################
resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.name}-public-route-table" },
    var.common_tags
  )
}

resource "aws_route" "public" {
  count                  = length(var.public_subnets) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

###########################################################
# NAT Gateway
###########################################################
locals {
  nat_gateway_count = var.single_nat_gateway ? 1 : length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? local.nat_gateway_count : 0
  domain = "vpc"
  tags = merge(
    { Name = "${var.name}-eip-${count.index}" },
    var.common_tags
  )
}

resource "aws_nat_gateway" "this" {
  count         = var.enable_nat_gateway ? local.nat_gateway_count : 0
  allocation_id = element(aws_eip.nat[*].id, var.single_nat_gateway ? 0 : count.index)
  subnet_id     = element(aws_subnet.public[*].id, var.single_nat_gateway ? 0 : count.index)
  tags = merge(
    { Name = "${var.name}-nat-gateway-${count.index}" },
    var.common_tags
  )
  depends_on = [aws_internet_gateway.this]
}

###########################################################
# Private Subnets
###########################################################
resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.private_subnets, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(
    { Name = "${var.name}-private-subnet-${count.index}" },
    var.common_tags
  )
}

###########################################################
# Private routes
###########################################################
resource "aws_route_table" "private" {
  count  = length(var.private_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = merge(
    { Name = "${var.name}-private-route-table" },
    var.common_tags
  )
}

resource "aws_route" "private" {
  count                  = var.enable_nat_gateway && length(var.private_subnets) > 0 ? local.nat_gateway_count : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}
