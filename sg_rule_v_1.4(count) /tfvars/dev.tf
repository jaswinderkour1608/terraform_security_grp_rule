# Providers variables
aws_region = "us-east-1"
# Security group variables
sg_ingress_rules = [
        {
          type = "ingress"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks  = "0.0.0.0/0"
          description = "ssh_ingress"
        },
        {
          type = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks  = "0.0.0.0/0"
          description = "http_ingress"
        },
    ]   

# Tags variables
env          = "dev"
project_name = "application"