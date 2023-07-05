# Configure the `AWS` provider
```
provider "aws" {
  region     = "ap-south-1"
  access_key = "Your_AWS_access_key"
  secret_key = "Your_AWS_secret_key"
}
```

## Create security group allowing `SSH` and `HTTP` traffic
```
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Security group for instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Create an EC2 instance for `Jenkins`
```
resource "aws_instance" "jenkins_instance" {
  ami           = "ami-0123456789"  # Replace with the desired Jenkins AMI ID
  instance_type = "t2.micro"        # Replace with the desired instance type
  key_name      = "your_key_pair"   # Replace with your key pair name
  security_group_names = [aws_security_group.instance_sg.name]

  tags = {
    Name = "Jenkins Instance"
  }

provisioner "remote-exec" {
    inline = [
      "curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \ /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \ https://pkg.jenkins.io/debian-stable binary/ | sudo tee \ /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install fontconfig openjdk-11-jre",
      "sudo apt-get install jenkins"
    ]
  }
}
```

## Create an EC2 instance for `Docker`
```
resource "aws_instance" "docker_instance" {
  ami           = "ami-0123456789"  # Replace with the desired Docker AMI ID
  instance_type = "t2.micro"        # Replace with the desired instance type
  key_name      = "your_key_pair"   # Replace with your key pair name
  security_group_names = [aws_security_group.instance_sg.name]

  tags = {
    Name = "Docker Instance"
  }

 provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo 'deb [signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      "sudo usermod -aG docker $USER"  
    ]
  }
}
```

## Create an EC2 instance for `Ansible`
```
resource "aws_instance" "ansible_instance" {
  ami           = "ami-0123456789"  # Replace with the desired Ansible AMI ID
  instance_type = "t2.micro"        # Replace with the desired instance type
  key_name      = "your_key_pair"   # Replace with your key pair name
  security_group_names = [aws_security_group.instance_sg.name]

 tags = {
    Name = "Ansible Instance"
  }


provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo apt-add-repository -y --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible"
      ]
  }
}
```
