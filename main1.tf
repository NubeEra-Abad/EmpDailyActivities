# terraform {
#   required_providers "aws"{
#     source ="hashicorp/aws"
#     version = "~> 3.27"
#   }
# }
provider "aws" {
    region = "us-east-1"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  identifier = "chetan-1"
  storage_type ="gp2"
  vpc_security_group_ids = ["sg-0d956ba29d4591d7a"]
  engine ="mysql"
  #automatic_backups ="disabled"
  engine_version = "8.0.32"
  instance_class = "db.t3.micro"                                                    
  name ="chetandatabase"
  username ="chetanuser"
  password ="Deshmukh-11"
  publicly_accessible ="true"
  skip_final_snapshot ="true"
  tags={
    Name= "mydatabase"
  }  
}