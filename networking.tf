data "aws_availability_zones" "prod_vpc_azs"{}


resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags       =  {
    name     = "prod_vpc"
  }       
}

resource "aws_subnet" "prod_publicsubnet_1" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = "aws_vpc.prod_vpc.id"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.prod_vpc_azs.names[1]
  tags                    = {
    name                  = "prod_publicSubnet_1"
  } 
}

resource "aws_subnet" "prod_privatesubnet_1" {
  cidr_block              = "10.0.2.0/24"
  vpc_id                  = "aws_vpc.prod_vpc.id"
  map_public_ip_on_launch  = false
  availability_zone       = data.aws_availability_zones.prod_vpc_azs.names[1]
  tags                    = {
    name                  = "prod_privateSubnet_1"
  } 
}

resource "aws_subnet" "prod_publicsubnet_2" {
  cidr_block              = "10.0.3.0/24"
  vpc_id                  = "aws_vpc.prod_vpc.id"
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.prod_vpc_azs.names[2]
  tags                    = {
    name                  = "prod_publicSubnet_2"
  } 
}

resource "aws_subnet" "prod_privatesubnet_2" {  
  cidr_block              = "10.0.4.0/24"
  vpc_id                  = "aws_vpc.prod_vpc.id"
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.prod_vpc_azs.names[2]
  tags       = {
    name     = "prod_privateSubnet_2"
  } 
}

# resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#   vpc_id     = data.aws_vpc.default_vpc.id
#   cidr_block = "172.32.0.0/16"
# }

resource "aws_internet_gateway" "prod_IGW"{
    vpc_id                 = aws_vpc.prod_vpc.id
    tags                   = {
        Name               = "prod_vpc_igw"
    }
  #   provisioner "local-exec"{
  #   command                = "echo Internet Gateway = ${self.id} >> metadata"
  # }
}

resource "aws_route_table" "prod_publicRouteTable1"{
    vpc_id                 = aws_vpc.prod_vpc.id
    route{
        cidr_block         = var.cidr_blocks
        gateway_id         = aws_internet_gateway.prod_IGW.id
    }
    tags                   = {
        Name               = "prod_publicRoute"
    }
}

resource "aws_route_table_association" "prod_publicSubnetAssociation1" {
    route_table_id         = aws_route_table.prod_publicRouteTable1.id
    subnet_id              = aws_subnet.prod_publicsubnet_1.id
    depends_on             = [aws_route_table.prod_publicRouteTable1, aws_subnet.prod_publicsubnet_1]
}

resource "aws_route_table_association" "prod_publicSubnetAssociation2" {
    route_table_id         = aws_route_table.prod_publicRouteTable1.id
    subnet_id              = aws_subnet.prod_publicsubnet_2.id
    depends_on             = [aws_route_table.prod_publicRouteTable1, aws_subnet.prod_publicsubnet_2]
}

resource "aws_route_table" "prod_privateRouteTable1"{
    vpc_id                 = aws_vpc.prod_vpc.id
#   route{
#   cidr_block             = "0.0.0.0/0"
#   gateway_id             = "${aws_nat_gateway.cpstn_natgateway.id}"
#}
    tags                   = {
        Name               = "cap_privateRoute"
    }
}
# Associate this route table to private subnet
resource "aws_route_table_association" "prod_privateSubnetAssociation1" {
    route_table_id         = aws_route_table.prod_privateRouteTable1.id
    subnet_id              = aws_subnet.prod_privatesubnet_1.id
    depends_on             = [aws_route_table.prod_privateRouteTable1, aws_subnet.prod_privatesubnet_1]
}
resource "aws_route_table_association" "prod_privateSubnetAssociation2" {
    route_table_id         = aws_route_table.prod_privateRouteTable1.id
    subnet_id              = aws_subnet.prod_privatesubnet_2.id
    depends_on             = [aws_route_table.prod_privateRouteTable1, aws_subnet.prod_privatesubnet_2]
}