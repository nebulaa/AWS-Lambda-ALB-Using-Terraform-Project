data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_vpc" "test_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "test_vpc"
  }
}

resource "aws_default_route_table" "r" {
  default_route_table_id = aws_vpc.test_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "test_api"
  }
}

resource "aws_route_table_association" "subnetfirstassoc" {
  subnet_id      = aws_subnet.subnetfirst.id
  route_table_id = aws_default_route_table.r.id
}

resource "aws_route_table_association" "subnetsecondassoc" {
  subnet_id      = aws_subnet.subnetsecond.id
  route_table_id = aws_default_route_table.r.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "test_api"
  }
}


resource "aws_subnet" "subnetfirst" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.azs.names[0]

    tags = {
        Name = "test_api"
    }
}

resource "aws_subnet" "subnetsecond" {
  vpc_id     = aws_vpc.test_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "test_api"
  }
}