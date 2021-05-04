# Providers variables
variable "aws_region" {
  type        = string
  description = "The region Terraform deploys your infra"
}
# Security group rule variables
variable "sg_ingress_rules" {
  type = map(object({
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  #default = {  # this part can be either here or in tfvars
  #  1 = {
  #    type        = "ingress"
  #    protocol    = "tcp"
  #    from_port   = 22
  #    to_port     = 22
  #    cidr_block  = "0.0.0.0/0"
  #    description = "test"
  #  },
  #  2 = {
  #    type        = "ingress"
  #    protocol    = "tcp"
  #    from_port   = 80
  #    to_port     = 80
  #    cidr_block  = "0.0.0.0/0"
  #    description = "test"
  #  }
  #}
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