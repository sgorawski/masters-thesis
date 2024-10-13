output "rds_instance_endpoint" {
  value = aws_db_instance.postgres_rds.endpoint
}

output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_postgres.endpoint
}

