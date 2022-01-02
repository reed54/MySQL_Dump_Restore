variable "region" {
  description = "AWS region designation.  e.g., us-east-2"
  type        = string
  default     = "us-west-2"
}

variable "profile" {
  description = "Profile within local ~/.aws/credentials file."
  type        = string
  default     = "TARGET"
}

variable "target_vpc" {
  description = "VPC for EC2 - must be the same as that of the RDS"
  type        = string
  default     = "Matrix-VPC"
}

variable "target_security_group" {
  description = "Name of the Security Group for the TARGET EC2."
  type        = string
  default     = "TARGET-SG"
}

variable "amz-linux2-ami" {
  description = "AMI for both SOURCE and TARGET EC2s"
  type        = string
  default     = "ami-00f7e5c52c0f43726"
}

variable "target_key_name" {
  description = "Name of key pair."
  type        = string
  default     = "mysql-src-kp"
}


variable "source_account" {
  description = "Account number for SOURCE Account."
  type        = string
  default     = "840978765443"
}

variable "target_account" {
  description = "Account number for TARGET Account."
  type        = string
  default     = "272672327679"
}

variable "companyName" {
  description = "Company Name."
  type        = string
  default     = "Centennial Data Science"
}

variable "accountName" {
  description = "Account Name."
  type        = string
  default     = "CDS"
}

variable "MatrixHubVPCCidrPrefix" {
  type    = string
  default = "172.26"
}

variable "master_password" {
  description = "DB password for4 user root."
  type        = string
  default     = "Letmein2015"
}

variable "owner" {
  description = "Owner department."
  type        = string
  default     = "Centennial Data Science"
}

variable "account" {
  type    = string
  default = "395983881734"
}

variable "environment_name" {
  type    = string
  default = "dev"
}