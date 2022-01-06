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

variable "amz-ubuntu-ami" {
  description = "AMI for both SOURCE and TARGET EC2s"
  type        = string
  default     = "ami-0892d3c7ee96c0bf7" # Changed to Ubuntu 20.04 LTS
}


variable "target_key_name" {
  description = "Name of key pair."
  type        = string
  default     = "ReedCDS2020"
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


variable "owner" {
  description = "Owner department."
  type        = string
  default     = "Centennial Data Science"
}

variable "environment_name" {
  type    = string
  default = "dev"
}

variable "db_subnet_group" {
  type        = list(string)
  description = "List of subnets where RDS service exists."
  default     = ["subnet-080551b144e46280e", "subnet-0e50f7bc5e85ada07", "subnet-089139a0ef43ff7f1"]
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where RDS is situated."
  default     = "vpc-08fea005441201d41"
}

variable "ec2_subnet_id" {
  type        = string
  description = "Public Subnet within the VPC for the RDS."
  default     = "subnet-06dde741be3f98267"
}
