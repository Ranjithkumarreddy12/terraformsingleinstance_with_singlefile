#AWS credentials
provider "aws" {
    region = "ap-south-1"
}

#VCP resource section. resource name is "VPC"
resource "aws_vpc" "VPC" {
    cidr_block = "10.2.0.0/16"
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
    cidr_block = "10.2.1.0/24"
    tags = {
        Name = "Public_Subnet-1a"
    }
}

#Private Subnet resource section. resource name is "private_subnet"
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.VPC.id}"
    availability_zone = "ap-south-1a"
    cidr_block = "10.2.10.0/24"
    tags = {
        Name = "Private_Subnet_1a"
    }
}

#Routing Table resource section. resource name "public_routing_table"
resource "aws_route_table" "public_routing_table" {
    vpc_id = "${aws_vpc.VPC.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
    }
    tags = {
        Name = "public_routing_table"
    }
}

resource "aws_route_table" "private_routing_table" {
    vpc_id = "${aws_vpc.VPC.id}"
    tags = {
        Name = "private_routing_table"
    }
}


resource "aws_route_table_association" "terraform-public" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public_routing_table.id}"
}

resource "aws_route_table_association" "terraform-private" {
    subnet_id = "${aws_subnet.private_subnet.id}"
    route_table_id = "${aws_route_table.private_routing_table.id}"
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
resource "aws_instance" "ubuntu_Server" {
    ami = "ami-0f918f7e67a3323f0"
    instance_type = "t2.micro"
    key_name = "manuja"
    subnet_id = "${aws_subnet.public_subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.sg.id}"]
    associate_public_ip_address = true	
    tags = {
        Name = "UbuntuServer"
    }
}
