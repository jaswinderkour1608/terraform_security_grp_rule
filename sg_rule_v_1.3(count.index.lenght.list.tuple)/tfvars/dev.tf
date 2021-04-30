# Providers variables
aws_region = "us-east-1"
# Security group variables
sg_ingress_rules = [
        [22, 22, "tcp", "0.0.0.0/0", "ssh_ingress", "ingress"],
        [80, 80, "tcp", "0.0.0.0/0", "http_ingress", "ingress"],
    ]
    
# Tags variables
env          = "dev"
project_name = "application"