provider "aws" {
    region = "us-east-1"
    access_key = "**********"
    secret_key = "j************"
}
#creation of VPC
resource "aws_vpc" "myvpc2" {
  cidr_block = "10.0.0.0/16"
  tags ={
    Name = "myvpc11"
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
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private_subnet1"
  }
}
#creation of private subnet2
resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.myvpc2.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "private_subnet2"
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
  tags={
    Name= "My_Route1"
  }
}
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.My_Route1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IG1.id
}
#create nat gateway
resource "aws_nat_gateway" "NG1" {
  #allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags={
    Name="NG1"
  }
}
resource "aws_eip" "eip1" {
  vpc = true
}
# resource "aws_security_group_rule" "Vpc_ingress_rule" {
#   security_group_id = aws_security_group.My_security_group.id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "Vpc_egress_rule" {
#   security_group_id = aws_security_group.My_security_group.id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }
resource "aws_security_group" "sg-1" {
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
    "name" = "ec2 security rules"
  }
}
#security gp for RDS
resource "aws_security_group" "rds-sg" {
  #security_group_id = aws_db_instance.ubuntu-instance21.vpc_security_group_ids[0]
  name = "rds-sg"
  description ="security for rds"
  vpc_id      = "aws_vpc.myvpc2.id"
  ingress {
    from_port   = 3306 
    to_port     = 3306 
    protocol    = "tcp"
    security_groups = ["aws_instance.sg-1.private_ip"]
  }
  # tags={
  #   name="rds-sg"
  # } 
}
# database subnet group in private subnet
resource "aws_db_subnet_group" "subnet_12" {
  name = "example-db-subnet-group"
  subnet_ids = ["aws_subnet.private_subnet1.id","aws_subnet.private_subnet2.id"]
}
data "aws_ami" "ubuntu" {
  most_recent = true 
}
# create ec2 instance    
resource "aws_instance" "ubuntu-instance291" {
  ami           = "ami-0aa2b7722dc1b5612"
  instance_type = "t2.micro"
  key_name      = "deshmukh11"
  vpc_security_group_ids = ["aws_security_group.sg-1.id"]
  tags = {
    "Name" = "chetan11"
  }
}
# create RDS instance
resource "aws_db_instance" "chetan11" {
  name     = "new-rds"
  engine   = "mysql" 
  username = "chetan"
  password = "Deshmukh@11" 
  allocated_storage = 20 
  instance_class = "db.t3.micro" 
  db_subnet_group_name  = aws_db_subnet_group.subnet_12.name
  vpc_security_group_ids = ["aws_security_group.rds-sg.id"]
}
  # tags = {
  #   Name = "example-db-instance"
  # }
#ec2 instance ip
output "web_domain" {
  value = aws_instance.ubuntu-instance291.public_dns
}
# resource "aws_eip_association" "my-eip-association"{
# #eip = aws_eip.eip1.id
# instance_id = "aws_instance.ubuntu-instance21.id"
# }

#rds database port
output "database-port" {
  value = aws_db_instance.chetan11.port
}
#elastic ip
# output "elastic-ip" {
#   value = aws_eip.eip1.public_ip
# }
#rds database port
output "database-endpoint" {
  value = aws_db_instance.chetan11.address
}

