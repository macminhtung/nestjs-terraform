# # DATABASE PARAMETER GROUP [datalake-parameter-group]: Initialize database parameter group
# resource "aws_db_parameter_group" "datalake-parameter-group" {
#   name   = "datalake-${var.stage}-pg"
#   family = "postgres14"
# }

# # DATABASE SUBNET GROUP [datalake-subnet-group]: Initialize database subnet group
# resource "aws_db_subnet_group" "datalake-subnet-group" {
#   name       = "datalake-private-${var.stage}"
#   subnet_ids = [aws_subnet.public-subnet-3.id, aws_subnet.public-subnet-4.id]

#   tags = {
#     Name = "datalake-${var.stage}"
#   }
# }

# # DATABASE INSTANCE [datalake-subnet-group]: Initialize database subnet group
# resource "aws_db_instance" "datalake-app" {
#   identifier_prefix     = "datalake-${var.stage}"
#   skip_final_snapshot   = true
#   allocated_storage     = 20
#   max_allocated_storage = 200
#   engine                = "postgres"
#   instance_class        = "db.t2.micro"
#   db_subnet_group_name  = aws_db_subnet_group.datalake-subnet-group.name
#   multi_az              = true
#   publicly_accessible   = true
#   db_name               = var.rds_db_name
#   username              = var.rds_username
#   password              = var.rds_password
#   parameter_group_name  = aws_db_parameter_group.datalake-parameter-group.name
#   vpc_security_group_ids = [aws_security_group.rds_security_group.id]

#   deletion_protection = false
#   backup_retention_period = 5
#   backup_window = "15:00-15:40"
# }
