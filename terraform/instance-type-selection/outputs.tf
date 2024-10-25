output "g3_instance_id" {
  value = aws_instance.g3_instance.id
}

output "p3_instance_id" {
  value = aws_instance.p3_instance.id
}

output "p3_spot_instance_id" {
  value = aws_instance.p3_spot_instance.id
}
