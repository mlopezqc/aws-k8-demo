variable "region" {
   default =  "us-east-1"
}

data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = aws_vpc.vpc.id
}

variable "az-count" {
   default = "3"
}

variable "aws-azs" {
   default = "us-east-1a, us-east-1b, us-east-1c"
}

variable "worker-instance-type" {
   default = "t3.medium"
}
