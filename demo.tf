provider "aws" {
  region     = "us-east-1"
  access_key = "AKIARKRKKBQYV63ZDAN2"
  secret_key = "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"
}
# 1. Create VPC
resource "aws_vpc" "prod-vpc" {
   cidr_block = "10.0.0.0/16"
   tags = {
     Name = "production"
   }
 }

resource "aws_instance" "my-first-server" {
  ami               = "ami-085925f297f89fce1"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
}


# 2. Create Internet Gateway

 resource "aws_internet_gateway" "gw" {
   vpc_id = aws_vpc.prod-vpc.id
 }
 # 3. Create Custom route Table

 resource "aws_route_table" "prod-route-table" {
   vpc_id = aws_vpc.prod-vpc.id

   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
   }

   route {
     ipv6_cidr_block = "::/0"
     gateway_id      = aws_internet_gateway.gw.id
   }

   tags = {
     Name = "Prod"
   }
 }
 # Create a Subnet 

 resource "aws_subnet" "subnet-1" {
   vpc_id            = aws_vpc.prod-vpc.id
   cidr_block        = "10.0.1.0/24"
   availability_zone = "us-east-1a"

   tags = {
     Name = "prod-subnet"
   }
 }
