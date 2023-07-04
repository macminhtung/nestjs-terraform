# # DATABASE PARAMETER GROUP [flaia-parameter-group]: Initialize database parameter group
# resource "aws_db_parameter_group" "flaia-parameter-group" {
#   name   = "flaia-${var.stage}-pg"
#   family = "postgres14"
# }

# # DATABASE SUBNET GROUP [flaia-subnet-group]: Initialize database subnet group
# resource "aws_db_subnet_group" "flaia-subnet-group" {
#   name       = "flaia-private-${var.stage}"
#   subnet_ids = [aws_subnet.public-subnet-3.id, aws_subnet.public-subnet-4.id]

#   tags = {
#     Name = "flaia-${var.stage}"
#   }
# }

# # DATABASE INSTANCE [flaia-subnet-group]: Initialize database subnet group
# resource "aws_db_instance" "flaia-app" {
#   identifier_prefix     = "flaia-${var.stage}"
#   skip_final_snapshot   = true
#   allocated_storage     = 20
#   max_allocated_storage = 200
#   engine                = "postgres"
#   instance_class        = "db.t2.micro"
#   db_subnet_group_name  = aws_db_subnet_group.flaia-subnet-group.name
#   multi_az              = true
#   publicly_accessible   = true
#   db_name               = var.rds_db_name
#   username              = var.rds_username
#   password              = var.rds_password
#   parameter_group_name  = aws_db_parameter_group.flaia-parameter-group.name
#   vpc_security_group_ids = [aws_security_group.rds_security_group.id]

#   deletion_protection = false
#   backup_retention_period = 5
#   backup_window = "15:00-15:40"
# }
