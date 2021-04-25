locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
  }
}
locals {
  ingress_rules = {
    1 = { from_port = 22, to_port = 22, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "ssh_ingress", type = "ingress" },
    2 = { from_port = 80, to_port = 80, protocol = "tcp", cidr_block = "0.0.0.0/0", description = "http_ingress", type = "ingress" },
  }
}