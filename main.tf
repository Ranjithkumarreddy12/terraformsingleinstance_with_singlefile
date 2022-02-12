#AWS credentials
provider "aws" {
    access_key = "AKIAXVOVW3WSEWNPO3VB"
    secret_key = "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"
    region = "ap-south-1"
}

#VCP resource section. resource name is "VPC"
resource "aws_vpc" "VPC" {
    cidr_block = "10.1.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "my_VPC"
    }
}

#Internet Gateway resource section. resource name is "IGW"
resource "aws_internet_gateway" "IGW" {
    vpc_id = "${aws_vpc.VPC.id}"
	tags = {
        Name = "my_IGW"
    }
}

# Public Subnet resourec section. resource name is "public_subnet"
resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.VPC.id}"
    availability_zone = "ap-south-1a"
    cidr_block = "10.1.1.0/24"
    tags = {
        Name = "Public_Subnet-1a"
    }
}

#Private Subnet resource section. resource name is "private_subnet"
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.VPC.id}"
    availability_zone = "ap-south-1a"
    cidr_block = "10.1.10.0/24"
    tags = {
        Name = "Private_Subnet_1a"
    }
}

#Security Group resource section. resource name is "sg"
resource "aws_security_group" "sg" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.VPC.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}

# Ec2 instance resource section. recource name is "Ubuntu_Server" 
resource "aws_instance" "Ubuntu_Server" {
    ami = "ami-08ee6644906ff4d6c"
    instance_type = "t2.micro"
    key_name = "Ranjith"
    subnet_id = "${aws_subnet.public_subnet.id}"
   # vpc_security_group_ids = "${aws_security_group.sg.id}"
    associate_public_ip_address = true	
    tags = {
        Name = "UbuntuServer"
    }
}