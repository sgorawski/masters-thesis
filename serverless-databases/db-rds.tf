# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres_rds" {
  allocated_storage    = var.db_storage_gb
  storage_type         = "gp2"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.postgres13"
  skip_final_snapshot  = true
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet.name
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "rds_subnet" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
}
