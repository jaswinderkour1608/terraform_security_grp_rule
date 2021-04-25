# Version 1.5 of security group rule template is build with "for_each" meta-argument
# and locals.tf is where we described the items for our rules. Using "for_each" will
# loops and grabs the item values from a given list and terraform creates the two 
# rules ssh and http ingress web_sg. Here we don't use variables.tf as well as dev.tf
# all needed item descriptions are in locals.tf

resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow inbound traffic"
  #vpc_id      = aws_vpc.my_vpc.id
  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_web_sg"
    }
  )
}

resource "aws_security_group_rule" "web_ingress" {
  for_each          = local.ingress_rules
  type              = each.value.type
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  cidr_blocks       = [each.value.cidr_block]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web_sg.id
}