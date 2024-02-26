#Define the VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags={
        Name = "my_vpc"
    }
  
}

#define two subnets in different availability zones
resource "aws_subnet" "subnet_a" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  
}
resource "aws_subnet" "subnet_b" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
}
# Create a security group for RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.my_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // Define ingress rules as needed
  ingress {
from_port = 3306
to_port = 3306
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"] # Restrict this for production environments
}
}
# Create an internet gateway and add appropriate tags

resource "aws_internet_gateway" "my_gateway" {
vpc_id = aws_vpc.my_vpc.id

tags = {
Name = "Internet Gateway"
}
}

resource "aws_route_table" "web_rt" {
  vpc_id = aws_vpc.my_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gateway.id
  }

  tags = {
    Name = "RT for Subnet"
  }
}

resource "aws_route_table_association" "first" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.web_rt.id
}

resource "aws_route_table_association" "second" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.web_rt.id
}
#RDS instance
resource "aws_db_instance" "mydb" {

    engine = "Mysql"
    engine_version = "8.0.35"
    instance_class = "db.t3.micro"
    identifier = "mydb"
    username = "admin"
    password = "admin1234"
    port = 3306
    db_subnet_group_name = aws_db_subnet_group.my_subnet_group1.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    publicly_accessible = true
    allocated_storage = 20
    
    
 
    tags = {
    Name = "database-1"
    Env="dev/test"
    }
 }

 #create RDS subnet group
 resource "aws_db_subnet_group" "my_subnet_group1"{
    name = "my_subnet_group1"
    subnet_ids = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
 }
