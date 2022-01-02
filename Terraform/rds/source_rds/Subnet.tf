// Public Subnets
resource "aws_subnet" "subnet-Matrix--Public-A" {
  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    "Name"             = "Matrix Public A"
    "Owner"            = "Engineering"
    "AccountName"      = var.accountName
    "Company"          = var.companyName
    "Visibility"       = "Public"
    "AvailabilityZone" = "us-west-2a"
    "VPC"              = "Matrix"

  }
}

resource "aws_subnet" "subnet-Matrix--Public-B" {
  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.1.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    "Name"             = "Matrix Public B"
    "VPC"              = "Matrix"
    "AvailabilityZone" = "us-west-2b"
    "AccountName"      = var.accountName
    "Company"          = var.companyName
    "Visibility"       = "Public"
    "Owner"            = "Engineering"
  }
}

resource "aws_subnet" "subnet-Matrix--Public-C" {
  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.2.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    "Name"             = "Matrix Public C"
    "Visibility"       = "Public"
    "Company"          = var.companyName
    "AvailabilityZone" = "us-west-2c"
    "AccountName"      = var.accountName
    "Owner"            = "Engineering"
    "VPC"              = "Matrix"
  }
}


// Private Subnets
resource "aws_subnet" "subnet-Matrix--Private-A" {
  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.4.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = false

  tags = {
    "Name"             = "Matrix Private A"
    "VPC"              = "Matrix"
    "Owner"            = "Engineering"
    "AccountName"      = var.accountName
    "AvailabilityZone" = "us-west-2a"
    "Company"          = var.companyName
  }
}

resource "aws_subnet" "subnet-Matrix--Private-B" {

  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.5.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = false

  tags = {
    "Name"             = "Matrix Private B"
    "AccountName"      = var.accountName
    "AvailabilityZone" = "us-west-2b"
    "Company"          = var.companyName
    "Visibility"       = "Private"
    "VPC"              = "Matrix"
  }
}

resource "aws_subnet" "subnet-Matrix--Private-C" {
  vpc_id                  = aws_vpc.Matrix-VPC.id
  cidr_block              = "${var.MatrixHubVPCCidrPrefix}.6.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = false

  tags = {
    "Name"             = "Matrix Private C"
    "VPC"              = "Matrix"
    "AccountName"      = var.accountName
    "AvailabilityZone" = "us-west-2c"
    "Visibility"       = "Private"
    "Company"          = var.companyName
  }
}


