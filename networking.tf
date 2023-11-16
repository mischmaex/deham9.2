data "aws_vpc" "default_vpc" {
    default = true
  
}

data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = "172.32.0.0/16"
}

resource "aws_subnet" "default4" {
  vpc_id     = data.aws_vpc.default_vpc.id
  cidr_block = "172.32.0.0/22"

  tags = {
    Name = "default4"
  }
}  

resource "aws_security_group" "instances" {
  name = "instance-security-group"
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instances.id

  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}   

# resource"aws_security_group_rule" "allow_ssh_inbound" {
#    type = "ingress"
#    security_group_id = aws_security_group.instances.id

#    from_port = 22
#    to_port = 22
#    protocol = "ssh"
#    cidr_blocks = ["0.0.0.0/0"]
resource "aws_network_acl" "main" {
  vpc_id = data.aws_vpc.default_vpc.id
  #subnet_ids = aws_subnet.default4.id
  

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 80
    to_port    = 80
  }

  tags = {
    Name = "main"
  }
}


#    provisioner "local-exec"{
