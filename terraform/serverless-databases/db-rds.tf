# RDS PostgreSQL Instance
resource "aws_db_instance" "postgres_rds" {
  allocated_storage   = var.db_storage_gb
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "15.8"
  instance_class      = "db.t3.micro"
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
  publicly_accessible = true
}
