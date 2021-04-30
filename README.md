## Terraform with Security group rule

This repository contains versions of security group rules, multiple options of how you can write your configuration files.

1. Version 1.0 Security Group Rule (hard coded) 

The first security group rule version is hard coded, which is not recommended by Terraform, it makes our code not reusable. But it is good to have for it for comparing with other versions. It is always good pracitice to start with hard coding, because this way you will understand the basics of automation and IaaC. Security group rule has two ports ingress open 22 and 80 and in Terraform you have to specify egress rule, which is open to 0.0.0.0/0.

2. Version 1.1 Security Group Rule (variables/tfvars/local.tags)

This Security group rule version is the simplest one, using ```variables.tf``` for difining variables and passing values for thos variables in ```tfvars/dev.tf.``` Variables makes this template reusable, where all the given variable values can be changed in variables.tf and tfvars/dev.tf file. Same as the previous version this security group rule opens 22 and 80 ingress and 0.0.0.0/0 egress rules. In this template we used locals for tagging and the explanation is done below.

#### Tags with locals.tf

Tags comparison with/without locals.tf file. When you use the same environment and project name , instead of repeating it over and over again, you can use locals.tf where you describe all the common tags, and merge it to another tags in the resource block.

Content of variables.tf ```tags part```.
```
# Tags variables

variable "env" {
  type        = string
  description = "name of the environment"
}

variable "project_name" {
  type        = string
  description = "name of the project"
}
```

tfvars/dev.tf tags
```

# Tags variables

env          = "dev"
project_name = "application"
```

How tags looked with variables, before we added locals.tf
```
tags = {
  Name        = "${var.env}_sg"
  Environment = var.env
  Project     = var.project_name
}
```

Defining the ```common_tags``` in ```locals.tf``` that we are passing in our resource blocks.
```
locals {
  common_tags = {
    Environment = var.env
    Project     = var.project_name
  }
}
```
After that we merge ```common_tags``` with the name tags by using ```merge``` function, it will look like this. In the naming we used ```interpolation``` which changes depending on the environment (dev, qa or prod)
```
tags = merge(
  local.common_tags,
  {
    Name = "${var.env}_sg"
  }
)
```

3. Version 1.2 of Security Group Rule (count/element/index/lenght/variables)

In this version of 1.2 Security Group rule, we used ```count``` meta-argument with ```element```, ```index``` and ```length``` functions. Our code does the same as before creates security group rules ingress ssh and http, and egress open to the world. But the trick here is that with one security group rule resource block we are able to provision 2 rules (22, 80) and egress (usually we leave egress rule hard coded). We used ```count``` to avoid repeating resource blocks and functions above helped us with that job. For tags we used locals, it helped us not to repeate the same tags over and over again. Now lets go over the code, first we defined the ports in ```variables.tf```, and we used ```list of strings``` for passing the values.
```
...
# Security group rule variables

variable "web_sg_tcp_ports" {
  type = list(string) 
}
...
```
Values for the given variables are passed in ```tfvars/dev.tf```
```
...
# Security group variables

web_sg_tcp_ports = ["22", "80"]
...
```
And ```security_group_rule.tf``` resource block ingress part looks like this,
```
resource "aws_security_group_rule" "web_ingress" {
  count             = length(var.web_sg_tcp_ports)
  type              = var.in_traffic_type
  protocol          = var.ingress_protocol
  from_port         = element(var.web_sg_tcp_ports, count.index)
  to_port           = element(var.web_sg_tcp_ports, count.index)
  cidr_blocks       = [var.cidr_block]
  security_group_id = aws_security_group.web_sg.id
}
```
First we have to give where the needed values for the attributes are given and what meta-argument will help us to itirate and get those values. In this case values are defined inside of lenght ```var.web_sg_tcp_ports``` variable, and the values for are given in tfvars/dev.tf (in this case it is ports). Meta-argument ```count``` goes and checks the list of string and element function helps ```count.index``` to retrive the ports and terraform uses those values to provision two rules. You may notice that the other attributes such as ```type```, ```protocol``` are getting their values form tfvars/dev.tf file, same way as we would use variables in a simple manner.

4. Version 1.3 of Security Group Rule (list(tuple)/count/length/index)

In this example of security group rule  we used ```count``` meta-argument with ```index``` and ```length``` functions, we are provisioning two ingress rules (ssh and http) and egress rule (hard coded). 
```variables.tf```, we commented out default values, because we passed the values it ```dev.tf```. 
```
...
# Security group rule variables

variable "sg_ingress_rules" {
  type = list(tuple([number, number, string, string, string, string]))
  #default = [
  #  [22, 22, "tcp", "0.0.0.0/0", "ssh_ingress", "ingress"],
  #  [80, 80, "tcp", "0.0.0.0/0", "http_ingress", "ingress"],
  #] 
}
...
```

tfvars/dev.tf, why here two [] brackets? well it's tuple wrapped inside of the list, both have their values inside of the [] brackets. I wanted to mention that you can either keep the list(tuple) inside of the ```variables.tf``` as a ```default``` value or pass it in ```tfvars/dev.tf``` with ```sg_ingress_rules```, either way it will work.
```
...
sg_ingress_rules = [
        [22, 22, "tcp", "0.0.0.0/0", "ssh_ingress", "ingress"],
        [80, 80, "tcp", "0.0.0.0/0", "http_ingress", "ingress"],
    ]
...    
```

Now lets see sg_rule.tf ingress rule part
```
...
resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.sg_ingress_rules)
  from_port         = var.sg_ingress_rules[count.index][0]
  to_port           = var.sg_ingress_rules[count.index][1]
  protocol          = var.sg_ingress_rules[count.index][2]
  cidr_blocks       = [var.sg_ingress_rules[count.index][3]]
  description       = var.sg_ingress_rules[count.index][4]
  type              = var.sg_ingress_rules[count.index][5]
  security_group_id = aws_security_group.web_sg.id
}
...
```
The reason for putting an extra [] brackets for cidr blocks is because it's a list of multiple cidr blocks. As it shown above ```count.index``` will get the values for every attribute  from the  ```sg_ingress_rules``` variable. And given list is in tuple of values, make sure to put in order the values, as count is grabbing those values by index numbers starting from zero.

5. Version 1.4 Security Group Rule (count/lenght/index/list(object))

This example of security group rule is very similar to previous version 1.3, the only
difference is we used list(objects) instead of list(tuple) where we defined our resources vertically for clarity. We build the variable file little different as well, but the same functions ```length``` and ```index``` with  ```count``` meta-argument were used. One resource block creates two ingress (ssh and http) rules. We can check it out visually ```variables.tf``` file,
```
...
# Security group rule variables

variable "sg_ingress_rules" {
  type = list(object({ 
    type        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = string
  }))
}
...
```

```tfvars/dev.tf``` values,
```
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
```
```security_grp_rule.tf``` ingress rules part,
```
...
resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.sg_ingress_rules)
  type              = var.sg_ingress_rules[count.index].type
  from_port         = var.sg_ingress_rules[count.index].from_port
  to_port           = var.sg_ingress_rules[count.index].to_port
  protocol          = var.sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.sg_ingress_rules[count.index].cidr_blocks]
  description       = var.sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.web_sg.id
}
...
```

Another difference from the version 1.3 is that instead of passing numeric index, we passed attribute names. 

6. Version security group rule 1.6

Version 1.5 of security group rule template is build with "for_each" meta-argument and locals.tf is where we described the items for our rules. Using "for_each" will loops and grabs the item values from a given list and terraform creates the two rules ssh and http ingress web_sg. Here we don't use variables.tf as well as dev.tf all needed item descriptions are in locals.tf
