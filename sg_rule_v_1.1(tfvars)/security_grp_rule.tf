# This security group rule is the simple version of configuring your security group
# rule using variables.tf and tfvars/dev.tf file. Variables makes this template
# reusable, where all the given variable values can be changed in tfvars/dev.tf file.

resource "aws_security_group" "web_sg" {
  name        = "${var.env}_web_sg"
  description = "Allow inbound traffic"
  #vpc_id      = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.env}_vpc"
    }
  )
}
resource "aws_security_group_rule" "http_ingress" {
  type              = var.in_traffic_type
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = var.ingress_protocol
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.web_sg.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = var.in_traffic_type
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = var.ingress_protocol
  cidr_blocks       = [var.cidr_block]
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