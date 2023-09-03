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



#security group
resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"

  # description = "Allow TLS inbound traffic"
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description = "Allow Port 22"
    from_port   = 8080
    to_port     = 8080
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
