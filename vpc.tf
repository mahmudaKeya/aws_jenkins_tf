resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/26"

  tags = {
    Name = "Mahmuda-vpc"
  }
}

#Creating subnet
resource "aws_subnet" "pubsub_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "192.168.0.0/27" #first public subnet
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true #ensures the public ip of an instance

  tags = {
    Name = "Public Subnet 1"
  }
}
