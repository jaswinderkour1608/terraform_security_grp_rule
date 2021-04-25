# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}

# Security group rule variables
variable "sg_ingress_rules" {
  type = list(tuple([number, number, string, string, string, string]))
  #default = [
  #  [22, 22, "tcp", "0.0.0.0/0", "ssh_ingress", "ingress"],
  #  [80, 80, "tcp", "0.0.0.0/0", "http_ingress", "ingress"],
  #]
}

# Tags variables
variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}