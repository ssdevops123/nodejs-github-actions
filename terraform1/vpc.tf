# Use data sources to verify that the provided VPC and subnets exist
data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)
  id       = each.key
}

data "aws_subnet" "private" {
  for_each = toset(var.private_subnet_ids)
  id       = each.key
}

# Local variables for reusability
locals {
  vpc_id             = data.aws_vpc.main.id
  public_subnet_ids  = [for s in data.aws_subnet.public : s.id]
  private_subnet_ids = [for s in data.aws_subnet.private : s.id]
}

output "verified_vpc_id" {
  value = local.vpc_id
}

output "verified_public_subnets" {
  value = local.public_subnet_ids
}

output "verified_private_subnets" {
  value = local.private_subnet_ids
}
