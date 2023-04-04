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


resource "aws_security_group" "Webserversecgrp" {
    name = "Webserversecgrp"
    description = "Enable HTTP for Flask Web Server and SSH port to secure reach to my EC2"
    ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    protocol = "tcp"
    to_port = 80
    }
    ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    protocol = "tcp"
    to_port = 22
    }

    egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
    }
  
}

resource "aws_instance" "webserverhost" {
    tags = {
      "Name" = var.instance_name
    }
    instance_type = var.instance_type
    ami = var.instance_ami
    key_name = var.key_name
    vpc_security_group_ids = [aws_security_group.Webserversecgrp.id]
    user_data = "${file("userdata.sh")}"
    # user_data = <<EOF
    #     #!/bin/bash 
    #     yum update -y
    #     yum install python3 -y
    #     pip3 install flask
    #     cd /home/ec2-user
    #     wget https://raw.githubusercontent.com/okermen/my-projects/main/aws/projects/Project-001-Roman-Numerals-Converter/app.py
    #     mkdir templates
    #     cd templates
    #     wget https://raw.githubusercontent.com/okermen/my-projects/main/aws/projects/Project-001-Roman-Numerals-Converter/templates/index.html
    #     wget https://raw.githubusercontent.com/okermen/my-projects/main/aws/projects/Project-001-Roman-Numerals-Converter/templates/result.html
    #     cd ..
    #     python3 app.py
    #     EOF

  
}

