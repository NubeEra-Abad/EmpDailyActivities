terraform {
  backend "http" {
  }
}
resource "aws_instance" "web12" {
    ami= "ami-0557a15b87f6559cf"  
    instance_type = "t2.micro"
    key_name = "deshmukh11"    
    vpc_security_group_ids = ["sg-0d956ba29d4591d7a"]

    tags = {
        Name="new_instance"
    }
}
output "public-dns"{
    value = "aws_instance.web12.public_dns"
}
