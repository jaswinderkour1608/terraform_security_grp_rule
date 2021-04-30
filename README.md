## Terraform with Security group rule

This repository contains versions of security group rules, multiple options of how you can write your configuration files.

1. Version 1.0 Security Group Rule (hard coded) 

The first security group rule version is hard coded, which is not recommended by Terraform, it makes our code not reusable. But it is good to have for it for comparing with other versions. It is always good pracitice to start with hard coding, because this way you will understand the basics of automation and IaaC. Security group rule has two ports ingress open 22 and 80 and in Terraform you have to specify egress rule, which is open to 0.0.0.0/0.

2. Version 1.1 Security Group Rule (with variables)

This security group rule is the simple version of configuring your security group
rule using variables.tf and tfvars/dev.tf file. Variables makes this template
reusable, where all the given variable values can be changed in tfvars/dev.tf file.

3. Version security group rule 1.2

In this version of 1.2 security group rule template, "element" and "length" functions were used with "count" meta-argument "count.index" expression. Here we created with one security group rule resource block 2 rules (22, 80) and for tags, we used locals in order to avoid repeating the same tags.

4. Version security group rule 1.3

In this example of sg_rule we used "count" meta-argument with "count.index" expression with "length" function, where we were able to provision 2 ingress rules (ssh and http). The reason for putting an extra [] signs for cidr blocks, is because it's a list of cidr blocks, which requires to be inside of the []. Another thing to mention you can either keep the list inside of the variables.tf or dev.tf, either way it will work. In variables.tf we used "tuple" wrapped in "list" and desciription of the types of the items.

5. Version security group rule 1.4

This example of security group rule is very similar to previous v_1.3, the only
difference is we used list(objects) instead of list(tuple). We build the variable file little different as well, but the same function "length" and "count" meta-argument with "count.index" expression were used. Ant we can provision 2 ingress (ssh and http) rules.

6. Version security group rule 1.6

Version 1.5 of security group rule template is build with "for_each" meta-argument and locals.tf is where we described the items for our rules. Using "for_each" will loops and grabs the item values from a given list and terraform creates the two rules ssh and http ingress web_sg. Here we don't use variables.tf as well as dev.tf all needed item descriptions are in locals.tf