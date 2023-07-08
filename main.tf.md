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
connection {
      type        = "ssh"
      user        = "ubuntu"                                   # Replace with the appropriate username for your AMI
      private_key = file("path to your private key file")            # Replace with the path to your private key file
      host        = aws_instance.jenkins_instance.public_ip    # Connect using the public IP of the instance
    }
    inline = [
      "sudo apt-get update",
      "sudo apt install openjdk-11-jdk",
      "sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "sudo echo deb https://pkg.jenkins.io/debian-stable binary/ >> /etc/apt/sources.list.d/jenkins.list echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update",
      "sudo apt-get install -y jenkins",
      "sudo systemctl start Jenkins"
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
connection {
      type        = "ssh"
      user        = "ubuntu"                                   # Replace with the appropriate username for your AMI
      private_key = file("path to your private key file")            # Replace with the path to your private key file
      host        = aws_instance.docker_instance.public_ip    # Connect using the public IP of the instance
    }
    inline = [
      "sudo apt update",
      "sudo apt install docker.io -y"  
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
    connection {
      type        = "ssh"
      user        = "ubuntu"                                   # Replace with the appropriate username for your AMI
      private_key = file("path to your private key file")            # Replace with the path to your private key file
      host        = aws_instance.ansible_instance.public_ip    # Connect using the public IP of the instance
    }

    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y ansible"
    ]
  }
}
```
