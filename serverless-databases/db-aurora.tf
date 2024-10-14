# Aurora Serverless v2 PostgreSQL Cluster
resource "aws_rds_cluster" "aurora_postgres" {
  cluster_identifier  = "aurora-postgres-cluster"
  engine              = "aurora-postgresql"
  engine_mode         = "provisioned"
  engine_version      = "15.8"
  master_username     = var.db_username
  master_password     = var.db_password
  storage_encrypted   = true
  skip_final_snapshot = true

  serverlessv2_scaling_configuration {
    max_capacity = 1.0
    min_capacity = 0.5
  }
}

resource "aws_rds_cluster_instance" "aurora_postgres_instance" {
  cluster_identifier = aws_rds_cluster.aurora_postgres.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.aurora_postgres.engine
  engine_version     = aws_rds_cluster.aurora_postgres.engine_version
}
