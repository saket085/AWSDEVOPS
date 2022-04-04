A typical 3 tier architecture using Terraform. The file graph.png shows the visual diagram of the terraform resources to be created.
It creates ideal components of a VPC, i.e. Public and Private subnets with dedicated CIDRs, Route Tables and its Associations. NACL with an elastic IP.
It creates web tier EC2 instances attached to a public facing ELB. It creates the RDS instance as well.
