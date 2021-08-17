resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
      Name = "public-subnet-${data.aws_availability_zones.available.names[0]}",
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
      Name = "public-subnet-${data.aws_availability_zones.available.names[1]}",
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "public_3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
      Name = "public-subnet-${data.aws_availability_zones.available.names[2]}",
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/elb" = 1
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gateway.id
    }
}

resource "aws_route_table_association" "public_1" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
    subnet_id = aws_subnet.public_3.id
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 3)
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
      Name = "private-subnet-${data.aws_availability_zones.available.names[0]}"
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_subnet" "private_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 4)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
      Name = "private-subnet-${data.aws_availability_zones.available.names[1]}"
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_subnet" "private_3" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 5)
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
      Name = "private-subnet-${data.aws_availability_zones.available.names[2]}"
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = 1
    }
}

resource "aws_eip" "nat_gateway_eip_1" {
  vpc = true
}

resource "aws_eip" "nat_gateway_eip_2" {
  vpc = true
}

resource "aws_eip" "nat_gateway_eip_3" {
  vpc = true
}

resource "aws_nat_gateway" "gateway_1" {
  allocation_id = aws_eip.nat_gateway_eip_1.id
  subnet_id     = aws_subnet.public_1.id
}

resource "aws_nat_gateway" "gateway_2" {
  allocation_id = aws_eip.nat_gateway_eip_2.id
  subnet_id     = aws_subnet.public_2.id
}

resource "aws_nat_gateway" "gateway_3" {
  allocation_id = aws_eip.nat_gateway_eip_3.id
  subnet_id     = aws_subnet.public_3.id
}

resource "aws_route_table" "private_1" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gateway_1.id
    }
}

resource "aws_route_table" "private_2" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gateway_2.id
    }
}

resource "aws_route_table" "private_3" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.gateway_3.id
    }
}

resource "aws_route_table_association" "private_1" {
    subnet_id = aws_subnet.private_1.id
    route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
    subnet_id = aws_subnet.private_2.id
    route_table_id = aws_route_table.private_2.id
}

resource "aws_route_table_association" "private_3" {
    subnet_id = aws_subnet.private_3.id
    route_table_id = aws_route_table.private_3.id
}
