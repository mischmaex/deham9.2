resource "aws_instance" "prod_ec2" {
    ami                     =  "ami-0a485299eeb98b979" #amazon linux 2023 in eu-central-1
    instance_type           = "t2.micro"
    vpc_security_group_ids  = [aws_security_group.prod_sg_instance.id]
    subnet_id               = aws_subnet.prod_publicsubnet_1.id
    user_data               =  "${file("userdata.sh")}"
    tags                    = {
        name                = "prod_instance"
    }
}

   # provisioner "local-exec"{
