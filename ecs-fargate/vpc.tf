#1. VPC with subnet

resource "aws_vpc" "main" {
  cidr_block = "11.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "pub_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 1)
  
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "pub_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 2)
  
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "pub_subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 3)
  
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = "true"
}

resource "aws_subnet" "priv_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 4)
  
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "priv_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 5)
  
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = "false"
}

resource "aws_subnet" "priv_subnet_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 4, 6)
  
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = "false"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo_igw"
  }
}

resource "aws_route" "internetgatewayroute" {
  depends_on                = [aws_internet_gateway.igw]

  route_table_id            = aws_route_table.pub_route_table.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.igw.id
}

resource "aws_route_table" "pub_route_table" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "pubsubnetroutetableassociation1" {
  subnet_id      = aws_subnet.pub_subnet_1.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pubsubnetroutetableassociation2" {
  subnet_id      = aws_subnet.pub_subnet_2.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "pubsubnetroutetableassociation3" {
  subnet_id      = aws_subnet.pub_subnet_3.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "privsubnetroutetableassociation1" {
  subnet_id      = aws_subnet.priv_subnet_1.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "privsubnetroutetableassociation2" {
  subnet_id      = aws_subnet.priv_subnet_2.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_route_table_association" "privsubnetroutetableassociation3" {
  subnet_id      = aws_subnet.priv_subnet_3.id
  route_table_id = aws_route_table.pub_route_table.id
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
#    cidr_blocks      = [aws_vpc.main.cidr_block]
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    description      = "Outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

