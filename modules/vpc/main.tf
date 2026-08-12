resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  for_each = {
    for index, cidr in var.public_subnet_cidrs :
    index => cidr
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-${each.key + 1}"
      Tier = "public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_app" {
  for_each = {
    for index, cidr in var.private_app_subnet_cidrs :
    index => cidr
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-app-${each.key + 1}"
      Tier = "private-app"
    }
  )
}

resource "aws_subnet" "private_db" {
  for_each = {
    for index, cidr in var.private_db_subnet_cidrs :
    index => cidr
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-db-${each.key + 1}"
      Tier = "private-db"
    }
  )
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0

  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
    }
  )
}

resource "aws_nat_gateway" "main" {
  count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : length(var.availability_zones)) : 0

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public[
    var.single_nat_gateway ? 0 : count.index
  ].id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-nat-${count.index + 1}"
    }
  )

  depends_on = [
    aws_internet_gateway.main
  ]
}

resource "aws_route_table" "private_app" {
  for_each = {
    for index, az in var.availability_zones :
    index => az
  }

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-app-rt-${each.key + 1}"
      Tier = "private-app"
    }
  )
}

resource "aws_route" "private_app_nat" {
  for_each = var.enable_nat_gateway ? aws_route_table.private_app : {}

  route_table_id = each.value.id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.main[
    var.single_nat_gateway ? 0 : tonumber(each.key)
  ].id
}

resource "aws_route_table_association" "private_app" {
  for_each = aws_subnet.private_app

  subnet_id = each.value.id

  route_table_id = aws_route_table.private_app[
    each.key
  ].id
}

resource "aws_route_table" "private_db" {
  for_each = {
    for index, az in var.availability_zones :
    index => az
  }

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-db-rt-${each.key + 1}"
      Tier = "private-db"
    }
  )
}

resource "aws_route_table_association" "private_db" {
  for_each = aws_subnet.private_db

  subnet_id = each.value.id

  route_table_id = aws_route_table.private_db[
    each.key
  ].id
}