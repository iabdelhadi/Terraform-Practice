provider "aws" {
  region  = "us-east-1"
  profile = "abdelhadi"
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name : "my_vpc"
    Environment = "TerraformChamps"
    Owner       = "Ait_Ali"
  }
}
# Create a Public Subnet
resource "aws_subnet" "public_sub_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    name : "pub_sub_1"
    Environment = "TerraformChamps"
    Owner       = "Ait_Ali"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name        = "IGW"
    Environment = "TerraformChamps"
    Owner       = "Ait_Ali"
  }
}

# Create a Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "PublicRouteTable"
    Environment = "TerraformChamps"
    Owner       = "Ait_Ali"
  }
}

# Associate the Subnet with the Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_route_table.public_route_table.id
}

## OutPuts
output "test_vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "test_subnet_id" {
  value = aws_subnet.public_sub_1.id
}
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_id" {
  value = aws_route_table.public_route_table.id
}