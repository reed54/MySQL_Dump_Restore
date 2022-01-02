
resource "random_password" "master" {
  length = 11
}


// RDS Definition
module "aurora" {
  source = "./terraform-aws-rds-aurora"

  name                  = "target-db"
  engine                = "aurora-mysql"
  engine_version        = "5.7.mysql_aurora.2.07.2" #"5.7.12"
  instance_type         = "db.t3.medium"
  instance_type_replica = "db.t3.medium"

  vpc_id                = aws_vpc.Matrix-VPC.id
  db_subnet_group_name  = aws_db_subnet_group.Matrix-VPC.name
  create_security_group = false
  #allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks

  replica_count                       = 2
  iam_database_authentication_enabled = true
  password                            = var.master_password
  create_random_password              = false

  # apply_immediately    = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.Matrix-VPC-MySQL-DatabaseSecurityGroup.id]

  # db_parameter_group_name         = aws_db_parameter_group.example.id
  # db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.example.id
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    "AccountName" = var.accountName
    "Company"     = var.companyName
    "VPC"         = "Matrix"
    "Owner"       = "Engineering"
  }
}
