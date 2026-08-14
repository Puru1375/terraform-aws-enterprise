resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-public-nacl"
      Tier = "public"
    }
  )
}

resource "aws_network_acl_rule" "public_ingress" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 100
  egress      = false
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_egress" {
  network_acl_id = aws_network_acl.public.id

  rule_number = 100
  egress      = true
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_association" "public" {
  count = length(var.public_subnet_ids)

  network_acl_id = aws_network_acl.public.id
  subnet_id      = var.public_subnet_ids[count.index]
}


#
# PRIVATE APPLICATION NACL
#

resource "aws_network_acl" "private_app" {
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-app-nacl"
      Tier = "private-app"
    }
  )
}

resource "aws_network_acl_rule" "private_app_ingress" {
  network_acl_id = aws_network_acl.private_app.id

  rule_number = 100
  egress      = false
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = var.vpc_cidr
}

resource "aws_network_acl_rule" "private_app_ingress_ephemeral" {
  network_acl_id = aws_network_acl.private_app.id

  rule_number = 110
  egress      = false
  protocol    = "tcp"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"

  from_port = 1024
  to_port   = 65535
}

resource "aws_network_acl_rule" "private_app_egress" {
  network_acl_id = aws_network_acl.private_app.id

  rule_number = 100
  egress      = true
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_association" "private_app" {
  count = length(var.private_app_subnet_ids)

  network_acl_id = aws_network_acl.private_app.id
  subnet_id      = var.private_app_subnet_ids[count.index]
}


#
# PRIVATE DATABASE NACL
#

resource "aws_network_acl" "private_db" {
  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-private-db-nacl"
      Tier = "private-db"
    }
  )
}

resource "aws_network_acl_rule" "private_db_ingress" {
  network_acl_id = aws_network_acl.private_db.id

  rule_number = 100
  egress      = false
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = var.vpc_cidr
}

resource "aws_network_acl_rule" "private_db_egress" {
  network_acl_id = aws_network_acl.private_db.id

  rule_number = 100
  egress      = true
  protocol    = "-1"
  rule_action = "allow"

  cidr_block = var.vpc_cidr
}

resource "aws_network_acl_association" "private_db" {
  count = length(var.private_db_subnet_ids)

  network_acl_id = aws_network_acl.private_db.id
  subnet_id      = var.private_db_subnet_ids[count.index]
}
