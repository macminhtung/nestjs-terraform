# LOAD BALANCER [datalake_lb]: Initialize loadbalancer
resource "aws_lb" "datalake_lb" {
  name               = "${var.project_name}-${var.stage}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load-balancer.id]
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id]
}

# ALB TARGET GROUP [datalake-app]: Initialize target group use for loadbalancer
resource "aws_alb_target_group" "datalake-app" {
  name       = "${var.project_name}-${var.stage}"
  port       = 3001
  protocol   = "HTTP"
  vpc_id     = aws_vpc.datalake-vpc.id
  depends_on = [aws_lb.datalake_lb]

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
  load_balancer_arn = aws_lb.datalake_lb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on = [
    aws_alb_target_group.datalake-app,
  ]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.datalake-app.arn
  }
}

