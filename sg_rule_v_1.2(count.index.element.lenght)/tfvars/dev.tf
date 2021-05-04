# Providers variables
aws_region = "us-east-1"
# Security group variables
web_sg_tcp_ports = ["22", "80"]
ingress_protocol = "tcp"
cidr_block       = "0.0.0.0/0"
in_traffic_type  = "ingress"
# Tags variables
env          = "dev"
project_name = "application"