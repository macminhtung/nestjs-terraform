# ECS [CLUSTER]: Initialize ecs cluster
resource "aws_ecs_cluster" "datalake-app" {
  name = "${var.project_name}-${var.stage}-cluster"
}

# ECS [SERVICE]: Initialize ecs service
resource "aws_ecs_service" "datalake-app" {
  name            = "${var.project_name}-${var.stage}-service"
  cluster         = aws_ecs_cluster.datalake-app.id
  task_definition = aws_ecs_task_definition.datalake-ecs-task.arn
  desired_count   = 2
  depends_on      = [aws_iam_role_policy.ecs-instance-role-policy]

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.datalake-app.arn
    container_name   = "${var.project_name}-${var.stage}-container"
    container_port   = 3001
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.availability_zones[0]}, ${var.availability_zones[1]}]"
  }
}

# ECS [IAM INSTANCE PROFILE]
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name_prefix = "ecs-instance-profile_"
  path        = "/"
  role        = aws_iam_role.ecs-role.name
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

# ECS [AMI]
data "aws_ami" "ecs_optimized" {
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.20220304-x86_64-ebs"]
  }
}

# ECS [LAUCH CONFIGURATION]
resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = data.aws_ami.ecs_optimized.id
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name
  security_groups      = [aws_security_group.ecs.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.datalake-app.name} > /etc/ecs/ecs.config\nunset AWS_ACCESS_KEY_ID\nunset AWS_SECRET_ACCESS_KEY\nunset AWS_SESSION_TOKEN\n#set AWS_SDK_LOAD_CONFIG=0\ncd ~/.aws/config\ncd ~/.aws/\nrm config -f\nrm credentials -f"
  instance_type        = "t2.micro"

  metadata_options {
    http_tokens  = "required"
    http_endpoint = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ECS [AUTOSCALING GROUP]
resource "aws_autoscaling_group" "datalake_platform" {
  name                 = "datalake-platform"
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  desired_capacity = 2
  min_size         = 2
  max_size         = 3
}

# ECS [AUTOSCALING POLICY]
resource "aws_autoscaling_policy" "datalake_datalake_platform" {
  name                   = "datalake-platform-policy"
  autoscaling_group_name = aws_autoscaling_group.datalake_platform.name
  policy_type            = "TargetTrackingScaling"

  // For customized metrics
  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = "datalake"
      }
      metric_name = "MemoryUtilization"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }
    target_value = 80.0
  }
}
