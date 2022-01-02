resource "aws_db_subnet_group" "Matrix-VPC" {
  name        = "matrix-vpc-db-subnet-group"
  description = "Subnet group for the MySQL instances in Matrix-VPC"
  subnet_ids  = [aws_subnet.subnet-Matrix--Private-C.id, aws_subnet.subnet-Matrix--Private-B.id, aws_subnet.subnet-Matrix--Private-A.id]
}
