resource "aws_instance" "example" {
    ami =  "ami-0a485299eeb98b979" #amazon linux 2023 in eu-central-1
    instance_type = "t2.micro"
    #security_groups = "aws_security_group.instances.id"
    user_data     =  "${file("userdata.sh")}"
}

   # provisioner "local-exec"{
