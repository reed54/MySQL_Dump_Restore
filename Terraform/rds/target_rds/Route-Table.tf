resource "aws_route_table" "Matrix-public-rtb" {
  vpc_id = aws_vpc.Matrix-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Matrix-IG.id
  }

  tags = {
    Name = "Matrix Public RTB"
  }
}

resource "aws_route_table_association" "Matrix-public-2a" {
  subnet_id      = aws_subnet.subnet-Matrix--Public-A.id
  route_table_id = aws_route_table.Matrix-public-rtb.id
}
resource "aws_route_table_association" "Matrix-public-2b" {
  subnet_id      = aws_subnet.subnet-Matrix--Public-B.id
  route_table_id = aws_route_table.Matrix-public-rtb.id
}
resource "aws_route_table_association" "Matrix-public-2c" {
  subnet_id      = aws_subnet.subnet-Matrix--Public-C.id
  route_table_id = aws_route_table.Matrix-public-rtb.id
}
resource "aws_route_table_association" "Matrix-private-2a" {
  subnet_id      = aws_subnet.subnet-Matrix--Private-A.id
  route_table_id = aws_route_table.Matrix-private-rtb.id
}
resource "aws_route_table_association" "Matrix-private-2b" {
  subnet_id      = aws_subnet.subnet-Matrix--Private-B.id
  route_table_id = aws_route_table.Matrix-private-rtb.id
}
resource "aws_route_table_association" "Matrix-private-2c" {
  subnet_id      = aws_subnet.subnet-Matrix--Private-C.id
  route_table_id = aws_route_table.Matrix-private-rtb.id
}

resource "aws_route_table" "Matrix-private-rtb" {
  vpc_id = aws_vpc.Matrix-VPC.id

  tags = {
    Name = "Matrix Private RTB"
  }
}
