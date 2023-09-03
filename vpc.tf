resource "aws_vpc" "my_vpc" {
  cidr_block = "192.168.0.0/26"

  tags = {
    Name = "main"
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

# Creating internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "pubsub-1-igw"
  }
}

# Creating route table
resource "aws_route_table" "pubsub-1-rt" {
  vpc_id = aws_vpc.my_vpc.id #required

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "pubsub-1-rt"
  }
}

# Subnet association to route table
resource "aws_route_table_association" "pubsub_1_association" {
  subnet_id      = aws_subnet.pubsub_1.id
  route_table_id = aws_route_table.pubsub-1-rt.id
}

#security group
resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"

  # description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 443 for docker image pull from ECR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all IP and Ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Security Group - Web Traffic
# resource "aws_security_group" "vpc-web" {
#   name        = "vpc-web"
#   description = "Dev VPC Web"

#   vpc_id = aws_vpc.my_vpc.id
#   ingress {
#     description = "Allow Port 80"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     description = "Allow all IP and Ports outbound"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }