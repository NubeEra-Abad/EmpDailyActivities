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

#creation of VPC
resource "aws_vpc" "myvpc2" {
  cidr_block = "10.0.0.0/16"
  tags ={
    Name = "myvpc121"
  }
}
#creation of public subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.myvpc2.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public_subnet1"
  }
}
#creation of private subnet1
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.myvpc2.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet1"
  }
}
#create internet gateway
resource "aws_internet_gateway" "IG1"{
  vpc_id = aws_vpc.myvpc2.id
  tags={
    Name= "IG1"
  }
  }
resource "aws_route_table" "My_Route1" {
  vpc_id = aws_vpc.myvpc2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG1.id
  }
  tags={
    Name= "My_Route1"
  }
}
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.My_Route1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IG1.id
}
# Associate the public subnet with the public route table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.My_Route1.id
}

#create nat gateway
resource "aws_nat_gateway" "NG1" {
  #allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags={
    Name="NG1"
  }
}
resource "aws_security_group" "public-securitygp" {
  name_prefix = "example"
  description = "for port 80 and port 22"
  vpc_id      = "aws_vpc.myvpc2.id"
  # for inbound rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
# for outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = {
    "name" = "public-securitygp"
  }
}
#rds security group
resource "aws_security_group" "private-securitygp" {
  name_prefix = "private"
  vpc_id      = aws_vpc.myvpc2.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    cidr_blocks = [aws_subnet.private_subnet1.cidr_block]
    #security_groups = [aws_security_group.public-securitygp.id]
  }
}
# database subnet
resource "aws_db_subnet_group" "rds-subnet" {
  name       = "database-subnet-group"
  subnet_ids = [aws_subnet.private_subnet1.id]
}

#create ec2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0aa2b7722dc1b5612"
  instance_type = "t2.micro"
  key_name      = "deshmukh11"
  vpc_security_group_ids = ["aws_security_group.public-securitygp.id"]
  tags = {
    Name = "instance-1"
  }
}
# create Database instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage = 20
  identifier = "chetan-1"
  storage_type ="gp2"
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.name
  vpc_security_group_ids = ["aws_security_group.private-securitygp.id"]
  engine ="mysql"
  #automatic_backups ="disabled"
  engine_version = "8.0.32"
  instance_class = "db.t3.micro"                                                    
  name ="chetandatabase"
  username ="chetanuser"
  password ="Deshmukh-11"
  #publicly_accessible ="true"
  skip_final_snapshot ="true"
  tags={
    Name= "mydatabase"
  }  
}
#ec2 ip
output "web_domain" {
  value = aws_instance.my_instance.public_dns
}
#rds database port
output "database-port" {
  value = aws_db_instance.rds_instance.port
}
#endpoint od rds
output "database-endpoint" {
  value = aws_db_instance.rds_instance.address
}
