# data "aws_ami" "amzLinux" {
#         most_recent                 = true
#         owners                      = ["amazon"]
    
#     filter {
#         name                        = "name"
#         values                      = ["al2023-ami-2023*x86_64"]
#         }
# }
#  locals {
#         DB                          = "mydb"
#         User                        = "Admin"
#         PW                          = "password123"
#         host                        = aws_db_instance.cpstn-sql-db.address
# }

# #Launch Template

resource "aws_launch_template" "prod_launch_template" {
  name                              = "WebserverLaunchTemplate"
  image_id                          = "ami-0a485299eeb98b979"
  instance_type                     = "t2.micro"
  vpc_security_group_ids            = [aws_security_group.prod_autoscaling_sg.id]
#   user_data                         = base64encode(templatefile("newuserdata.sh",{
#         DB   = local.DB
#         User = local.User
#         PW   = local.PW
#         host = local.host
    }

#   #IAM profile

#   iam_instance_profile {
#         name                        = "instance_role_cpstn"
#    }     
#   tag_specifications {
#         resource_type               = "instance"
#         tags                        = {
#             Name                    = "mysqlserver"
#    }
#   }
# }

#Autoscaling Group

resource "aws_autoscaling_group" "prod_AutoScalingGroup" {
  name                              = "prod-autoscaling-group"
  max_size                          = 4
  min_size                          = 2
  desired_capacity                  = 2
  #changed to public subnets while NATGateway is turned off 
  vpc_zone_identifier               = [aws_subnet.prod_publicsubnet_1.id, aws_subnet.prod_publicsubnet_2.id]
  target_group_arns                 = [aws_lb_target_group.prod_target_group.arn]
  health_check_type                 = "ELB"
  health_check_grace_period         = 300
  launch_template {
    id                              = aws_launch_template.prod_launch_template.id
    version                         = "$Latest"
  }
}

#Autoscaling policy

resource "aws_autoscaling_policy" "policy" {
  name                              = "CPUpolicy"
  policy_type                       = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type        = "ASGAverageCPUUtilization"
    }
      target_value                  = 75.0
  }
  autoscaling_group_name            = aws_autoscaling_group.prod_AutoScalingGroup.name
}