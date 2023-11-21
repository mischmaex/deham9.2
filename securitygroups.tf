# Security Group for Instance
resource "aws_security_group" "prod_sg_instance"{
        vpc_id                      = aws_vpc.prod_vpc.id
        name                        = "prod_securityGrouplatest"
        tags                        = {
        Name                        = "prod-sg-instance"
    }
    # provisioner "local-exec"{
    #     command                     = "echo Security Group Bastion = ${self.id} >> metadata"
    # }          
}

# Rules bastion - Ingress Security Port 22 (Inbound)
        resource "aws_security_group_rule" "prod_ingress_ssh"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_sg_instance.id
        to_port                     = 22
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks] # <Specify the CIDR> instead of allowing it to public
}

# Rules bastion - Allow Access All (Outbound)
        resource "aws_security_group_rule" "prod_outbound_all"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_sg_instance.id
        to_port                     = 22
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}
# Security Group for Application Load balancer and rules
resource "aws_security_group" "prod_alb_sg"{
        vpc_id                      = aws_vpc.prod_vpc.id
        name                        = "alb-sg"
        tags                        = {
        Name                        = "prod-alb-sg"
        }
        # provisioner "local-exec"{
        # command                     = "echo Security Group ALB = ${self.id} >> metadata"
        # } 
}
        resource "aws_security_group_rule" "alb_sg_http_in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_alb_sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "alb_sg_https_in"{
        from_port                   = 443
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_alb_sg.id
        to_port                     = 443
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "alb_sg_all_out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.prod_alb_sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}
#Security Group for Autoscaling and rules
resource "aws_security_group" "prod_autoscaling_sg"{
        vpc_id                      = aws_vpc.prod_vpc.id
        name                        = "autoscaling-sg"
        tags                        = {
        Name                        = "prod-autoscaling-sg"
        }
        # provisioner "local-exec"{
        # command                     = "echo Security Group Autoscaling = ${self.id} >> metadata"
        # } 
}
        resource "aws_security_group_rule" "autoscaling-sg-ssh-in"{
        from_port                   = 22
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_autoscaling_sg.id
        to_port                     = 22
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "autoscaling-sg-http-in"{
        from_port                   = 80
        protocol                    = "tcp"
        security_group_id           = aws_security_group.prod_autoscaling_sg.id
        to_port                     = 80
        type                        = "ingress"
        cidr_blocks                 = [var.cidr_blocks]
}
        resource "aws_security_group_rule" "autoscaling-sg-all-out"{
        from_port                   = 0
        protocol                    = "all"
        security_group_id           = aws_security_group.prod_autoscaling_sg.id
        to_port                     = 65535
        type                        = "egress"
        cidr_blocks                 = [var.cidr_blocks]
}

# resource "aws_network_acl" "prod_nacl" {
#   vpc_id = aws_vpc.prod_vpc.id
  

#   egress {
#     protocol   = "tcp"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "10.3.0.0/18"
#     from_port  = 443
#     to_port    = 443
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 100
#     action     = "allow"
#     cidr_block = "10.3.0.0/18"
#     from_port  = 80
#     to_port    = 80
#   }

#   tags = {
#     Name = "prod_nacl"
#   }
# }

# resource "aws_network_acl_association" "prod_nacl" {
#   network_acl_id = aws_network_acl.prod_nacl.id
#   subnet_id      = aws_subnet.prod_publicsubnet_1.id
# }
# resource "aws_network_acl_association" "prod_nacl" {
#   network_acl_id = aws_network_acl.prod_nacl.id
#   subnet_id      = aws_subnet.prod_publicsubnet_2.id

#    provisioner "local-exec"{


# alter code:
# resource "aws_security_group" "instances" {
#     vpc_id  = "aws_vpc.prod_vpc.id" 
#     name    = "instance_securitygroup"
#     tags    = {
#             = "prod-instance-sg"
#     }
# }

# resource "aws_security_group_rule" "allow_http_inbound" {
#   type              = "ingress"
#   security_group_id = aws_security_group.instances.id

#   from_port   = 8080
#   to_port     = 8080
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }   

# resource "aws_security_group_rule" "allow_ssh_inbound" {
#   type              = "ingress"
#   security_group_id = aws_security_group.instances.id

#   from_port   = 22
#   to_port     = 22
#   protocol    = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
# }