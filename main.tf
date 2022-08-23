provider "aws"{
    region     = "us-west-1"
}

resource "aws_vpc" "primary_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Primary-VPC-1"
  }
}

resource "aws_internet_gateway" "IG-1" {
 vpc_id = aws_vpc.primary_vpc.id
 tags = {
    Name = "Internet Gateway-1"
  }
}

resource "aws_subnet" "public-subnet-1" {
 vpc_id = aws_vpc.primary_vpc.id
 cidr_block = "10.0.0.0/24"
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_route_table" "primary-vpc-rt" {
 vpc_id = aws_vpc.primary_vpc.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG-1.id
 } 
}

resource "aws_route_table_association" "public-subnet1--routetable" {
  subnet_id = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.primary-vpc-rt.id
}

resource "aws_instance" "serv1" {
  ami           = "ami-0e4d9ed95865f3b40"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1.id
  tags = {
    Name = "Server1"
  }
}

resource "aws_instance" "serv2" {
  ami           = "ami-0e4d9ed95865f3b40"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet-1.id
  tags = {
    Name = "Server2"
  }
}