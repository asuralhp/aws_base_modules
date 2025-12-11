resource "aws_network_acl" "this" {
  region = var.region
  vpc_id = var.vpc_id

  tags = var.tags

  dynamic "ingress" {
    for_each = var.ingress
    content {
      rule_no    = ingress.value.rule_no
      protocol   = ingress.value.protocol
      action     = ingress.value.action
      cidr_block = try(ingress.value.cidr_block, null)

      from_port = ingress.value.from_port
      to_port   = ingress.value.to_port
      icmp_type = try(ingress.value.icmp_type, null)
      icmp_code = try(ingress.value.icmp_code, null)
    }
  }

  dynamic "egress" {
    for_each = var.egress
    content {
      rule_no    = egress.value.rule_no
      protocol   = egress.value.protocol
      action     = egress.value.action
      cidr_block = try(egress.value.cidr_block, null)

      from_port = egress.value.from_port
      to_port   = egress.value.to_port
      icmp_type = try(egress.value.icmp_type, null)
      icmp_code = try(egress.value.icmp_code, null)
    }
  }
}

resource "aws_network_acl_association" "this" {
  for_each       = toset(var.subnet_ids)
  subnet_id      = each.value
  network_acl_id = aws_network_acl.this.id
}
