terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "WebServerSecurityGroup" {
    name        = "WebServerSecurityGroup"
    description = "Enable HTTP for Apache Web Server and SSH for secure connection"
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

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "webserverhost" {
    instance_type = "t2.micro"
    ami = "ami-005f9685cb30f234b"
    key_name = "okermenpair"
    vpc_security_group_ids = [aws_security_group.WebServerSecurityGroup.id]
    associate_public_ip_address = true
    # user_data = "${file("userdata.sh")}"
    user_data = <<EOF
            #! /bin/bash
            yum update -y
            yum install httpd -y
            FOLDER="https://raw.githubusercontent.com/okermen/my-projects/main/aws/projects/Project-101-kittens-carousel-static-website-ec2/static-web"
            cd /var/www/html
            wget $FOLDER/index.html
            wget $FOLDER/cat0.jpg
            wget $FOLDER/cat1.jpg
            wget $FOLDER/cat2.jpg
            wget $FOLDER/cat3.png
            systemctl start httpd
            systemctl enable httpd     
            EOF
}

output "WebsiteURL" {
    value = aws_instance.webserverhost.public_ip
  
}