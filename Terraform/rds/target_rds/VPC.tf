resource "aws_vpc" "Matrix-VPC" {
  cidr_block           = "${var.MatrixHubVPCCidrPrefix}.0.0/19"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    "Name"        = "Matrix VPC"
    "AccountName" = var.accountName
    "Owner"       = "CDS"
    "Company"     = var.companyName
    "flowlog"     = "reject"
  }
}


