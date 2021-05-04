# Providers variables
aws_region = "us-east-1"

# Security group variables
sg_ingress_rules = {
  1 = {
    type        = "ingress"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_block  = "0.0.0.0/0"
    description = "test"
  },
  2 = {
    type        = "ingress"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_block  = "0.0.0.0/0"
    description = "test"
  }
}

# Tags variables
env          = "dev"
project_name = "application"