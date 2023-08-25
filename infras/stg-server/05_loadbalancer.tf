# LOAD BALANCER [hrforte_lb]: Initialize loadbalancer
resource "aws_lb" "hrforte_lb" {
  name               = "${var.project_name}-${var.stage}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

# ALB TARGET GROUP [hrforte-app]: Initialize target group use for loadbalancer
resource "aws_alb_target_group" "hrforte-app" {
  name       = "${var.project_name}-${var.stage}"
  port       = var.port
  protocol   = "HTTP"
  vpc_id     = aws_vpc.hrforte-vpc.id
  depends_on = [aws_lb.hrforte_lb]

  health_check {
    path                = "${var.health_check_path}"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 60
    matcher             = "200"
  }
}

# ALB LISTENER [HTTP]
resource "aws_alb_listener" "ecs-alb-http-listener" {
  load_balancer_arn = aws_lb.hrforte_lb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on = [
    aws_alb_target_group.hrforte-app,
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.hrforte-app.arn
  }
}

# # ACM CERTIFICATE
# resource "aws_acm_certificate" "hrforte-acm" {
#   domain_name = var.domain_name
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # ALB LISTENER [HTTPS]
# resource "aws_alb_listener" "ecs-alb-https-listener" {
#   load_balancer_arn = aws_lb.hrforte_lb.id
#   port              = "443"
#   protocol          = "HTTPS"
#   certificate_arn   = aws_acm_certificate.hrforte-acm.arn
#   depends_on = [
#     aws_alb_target_group.hrforte-app,
#   ]

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_alb_target_group.hrforte-app.arn
#   }
# }

# # ALB LISTENER [HTTP]
# resource "aws_alb_listener" "ecs-alb-http-redirect" {
#   load_balancer_arn = aws_lb.hrforte_lb.id
#   port              = "80"
#   protocol          = "HTTP"
#   depends_on        = [aws_alb_listener.ecs-alb-https-listener]

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

