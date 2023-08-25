# SECURITY GROUP [load-balancer]: Use for Load-balancer
resource "aws_security_group" "load-balancer" {
  name        = "load_balancer_security_group"
  description = "Controls access to the ALB"
  vpc_id      = aws_vpc.hrforte-vpc.id

  # INBOUND RULES
  ingress {
    from_port   = 80
    to_port     = 80 // Use for HTTP request
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Specifies the range of CIDR IP addresses to which incoming connections are allowed to access the security group
  }

  ingress {
    from_port   = 443
    to_port     = 443 // Use for HTTPS request
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Specifies the range of CIDR IP addresses to which incoming connections are allowed to access the security group
  }

  # OUTBOUND RULES
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // Response data to any IPs
  }
}

# SECURITY GROUP [ecs]: Use for ECS
resource "aws_security_group" "ecs" {
  name        = "ecs_security_group"
  description = "Allows inbound access from the ALB only"
  vpc_id      = aws_vpc.hrforte-vpc.id

  # INBOUND RULES
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.load-balancer.id] // <== Allows inbound access from the ALB only
  }

  # OUTBOUND RULES
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // <== Support pull image from ECR and response data for any IPs
  }
}

# # SECURITY GROUP [rds]: Use for RDS
# resource "aws_security_group" "rds_security_group" {
#   name   = "rds_security_group_${var.stage}"
#   vpc_id = aws_vpc.hrforte-vpc.id

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = [var.vpc_cidr]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
