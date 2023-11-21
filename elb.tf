# #Load Balancer

resource "aws_lb" "prod_loadBalancer" {
  name                              = "myWebserver-alb"
  internal                          = false
  load_balancer_type                = "application"
  security_groups                   = [aws_security_group.prod_alb_sg.id]
  subnets                           = [aws_subnet.prod_publicsubnet_1.id, aws_subnet.prod_publicsubnet_2.id]
  enable_deletion_protection        = false
    tags = {
        Environment                 = "production"
  }
}

#Target Group

resource "aws_lb_target_group" "prod_target_group" {
  name                              = "CPUtest-tg"
  port                              = 80
  protocol                          = "HTTP"
  vpc_id                            = aws_vpc.prod_vpc.id
}

#Listener

resource "aws_lb_listener" "prod_listener" {
  load_balancer_arn                 = aws_lb.prod_loadBalancer.arn
  port                              = 80
  protocol                          = "HTTP"
  default_action {
    type                            = "forward"
    target_group_arn                = aws_lb_target_group.prod_target_group.arn
  }
}
