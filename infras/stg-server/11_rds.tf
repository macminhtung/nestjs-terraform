# # DATABASE PARAMETER GROUP [hrforte-parameter-group]: Initialize database parameter group
# resource "aws_db_parameter_group" "hrforte-parameter-group" {
#   name   = "hrforte-${var.stage}-pg"
#   family = "postgres14"
# }

# # DATABASE SUBNET GROUP [hrforte-subnet-group]: Initialize database subnet group
# resource "aws_db_subnet_group" "hrforte-subnet-group" {
#   name       = "hrforte-private-${var.stage}"
#   subnet_ids = [aws_subnet.public-subnet-3.id, aws_subnet.public-subnet-4.id]

#   tags = {
#     Name = "hrforte-${var.stage}"
#   }
# }

# # DATABASE INSTANCE [hrforte-subnet-group]: Initialize database subnet group
# resource "aws_db_instance" "hrforte-app" {
#   identifier_prefix     = "hrforte-${var.stage}"
#   skip_final_snapshot   = true
#   allocated_storage     = 20
#   max_allocated_storage = 200
#   engine                = "postgres"
#   instance_class        = "db.t2.micro"
#   db_subnet_group_name  = aws_db_subnet_group.hrforte-subnet-group.name
#   multi_az              = true
#   publicly_accessible   = true
#   db_name               = var.rds_db_name
#   username              = var.rds_username
#   password              = var.rds_password
#   parameter_group_name  = aws_db_parameter_group.hrforte-parameter-group.name
#   vpc_security_group_ids = [aws_security_group.rds_security_group.id]

#   deletion_protection = false
#   backup_retention_period = 5
#   backup_window = "15:00-15:40"
# }
