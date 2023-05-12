provider "aws" {
    region = "us-east-1"
    access_key = "AKIA************"
    secret_key = "j5t6*****************"
}
############### variables #########################

variable "private_subnet_cidr_blocks" {
  description = "available subnets"
  type = list(string)
  default= ["10.0.1.0/24","10.0.2.0/24"]
}
variable "subnet_count"{
  description = "number of subnets"
  type = map(number)
  default = {
    private = 2 }
}
data "aws_availability_zones" "available" {
  state ="available"
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
  # availability_zone = "data.aws_availability_zones.available.names[count.index]"                 
  tags = {
    Name = "public_subnet1"
  }
}
#creation of private subnet1
resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.myvpc2.id
  count = var.subnet_count.private
  cidr_block = var.private_subnet_cidr_blocks[count.index]
  # availability_zone = "data.aws_availability_zones.available.names[count.index]"
  tags = {
    Name = "private_subnet1"
  }
}
#create internet gateway
resource "aws_internet_gateway" "Internet1"{
  vpc_id = aws_vpc.myvpc2.id
  tags={
    Name= "Internet1"
  }
  }
########################## public route #############################
resource "aws_route_table" "My_Route1" {
  vpc_id = aws_vpc.myvpc2.id
  route {
    cidr_block ="0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet1.id
  }
  tags={
    Name= "My_Route1"
  }
}
resource "aws_route_table_association" "public_association" {
  route_table_id         = aws_route_table.My_Route1.id
  #destination_cidr_block = "0.0.0.0/0"
  subnet_id             = aws_subnet.public_subnet1.id
}

################### private route ##########################
resource "aws_route_table" "My_Route2" {
  vpc_id = aws_vpc.myvpc2.id
  
  tags={
    Name= "My_Route2"
  }
}
resource "aws_route_table_association" "private_association" {
  route_table_id         = aws_route_table.My_Route2.id
  #destination_cidr_block = "0.0.0.0/0"
  count = var.subnet_count.private
  subnet_id             = aws_subnet.private_subnet1[count.index].id 
}

#create nat gateway
# resource "aws_nat_gateway" "Nat1" {
#   allocation_id = aws_eip.nat_gateway_eip.id
#   count = var.subnet_count.private
#   subnet_id     = aws_subnet.private_subnet1[count.index]
#   tags={
#     Name="NG1"
#   }
# }

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
resource "aws_security_group" "publicsecuritygroupalltraffic" {
  name_prefix = "publicsecuritygroupalltraffic"
  description = "for port 80 and port 22"
  vpc_id      =  aws_vpc.myvpc2.id
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
  # ingress {
  #   from_port   = 3306
  #   to_port     = 3306
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"] 
  # }
  
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
resource "aws_security_group" "privatesecuritygroupalltraffic" {
  # security_group_id = aws_db_instance.ubuntu-instance2911.vpc_security_group_ids[0]
  name = "privatesecuritygroupalltraffic"
  description ="security for rds"
  vpc_id      = aws_vpc.myvpc2.id
  ingress {
    from_port   = 3306 
    to_port     = 3306 
    protocol    = "tcp"
    # cidr_blocks =["${aws_instance.ubuntu-instance2911.private_ip}"/32]                                                                
    security_groups = ["aws_security_group.publicsecuritygroupalltraffic.id"]
    # cidr_blocks = [aws_subnet.private_subnet1.cidr_block]
  }
   tags={
    name="privatesecuritygroupalltraffic"
  } 
}
################# database-subnet-group #####################
resource "aws_db_subnet_group" "database" {
  name        = "db-subnet-group"
  description = "DB subnet group"
  # subnet_ids = ["aws_subnet.private_subnet1.id"]
  subnet_ids = [for subnet in aws_subnet.private_subnet1:subnet.id] 
}

# database subnet group in private subnet
# resource "aws_db_subnet_group" "subnet_12" {
#   name = "example-db-subnet-group"
#   subnet_ids = ["aws_subnet.private_subnet2.id"]
# }AKIAVYS3SHK4MHY6DKFT
data "aws_ami" "ubuntu" {
  most_recent = true 
}

# create RDS instance
resource "aws_db_instance" "chetan" {
  name     = "newdatabase"
  engine   = "mysql" 
  username = "chetan"
  password = "Deshmukh-11" 
  allocated_storage = 20 
  instance_class = "db.t3.micro" 
  #db_subnet_group_name  = aws_db_subnet_group.subnet_12.name
  # vpc_security_group_ids = [aws_security_group.privatesecuritygroupalltraffic.id]
  # subnet_id= "aws_subnet.private_subnet1.id"
  vpc_security_group_ids =[aws_security_group.privatesecuritygroupalltraffic.id]
  db_subnet_group_name = aws_db_subnet_group.database.id
 
  tags = {
    Name = "db-instance"
  }
}  
# create ec2 instance    
resource "aws_instance" "ubuntu-instance2911" {
  ami           = "ami-0aa2b7722dc1b5612"
  instance_type = "t2.micro"
  key_name      = "deshmukh11"
  #subnet_id = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.publicsecuritygroupalltraffic.id]
  tags = {
    "Name" = "chetan11"
  }
}
resource "aws_eip" "nat_gateway_eip" {
  vpc      = true
  instance = aws_instance.ubuntu-instance2911.id
  tags = {
    Name="new_eip"
  }
}

#ec2 instance ip
output "web_domain" {
  value = aws_eip.nat_gateway_eip.public_ip
  depends_on =[aws_eip.nat_gateway_eip]
}

output "web_domain1" {
  value = aws_eip.nat_gateway_eip.public_dns
  depends_on =[aws_eip.nat_gateway_eip]
}
# resource "aws_eip_association" "my-eip-association"{
# #eip = aws_eip.eip1.id
# instance_id = "aws_instance.ubuntu-instance21.id"
# }

#rds database port
output "database-port" {
  value = aws_db_instance.chetan.port
}
#rds database port
output "database-endpoint" {
  value = aws_db_instance.chetan.address
}
#glpat--xZxxszyQY_k_JG_F-8n
