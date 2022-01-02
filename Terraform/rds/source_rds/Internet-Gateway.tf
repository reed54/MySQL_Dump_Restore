resource "aws_internet_gateway" "Matrix-IG" {
  vpc_id = aws_vpc.Matrix-VPC.id

  tags = {
    "VPC Index"   = "0"
    "Company"     = var.companyName
    "AccountName" = var.accountName
    "Owner"       = "Engineering"
    "Name"        = "Matrix VPC"
    "VPC"         = "Matrix"
  }
}


