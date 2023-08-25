# ECS [CLUSTER]: Initialize ecs cluster
resource "aws_ecs_cluster" "hrforte-app" {
  name = "${var.project_name}-${var.stage}-cluster"
}

# ECS [SERVICE]: Initialize ecs service
resource "aws_ecs_service" "hrforte-app" {
  name            = "${var.project_name}-${var.stage}-service"
  cluster         = aws_ecs_cluster.hrforte-app.id
  task_definition = aws_ecs_task_definition.hrforte-ecs-task.arn
  depends_on      = [aws_iam_role_policy.ecs-instance-role-policy]
  desired_count   = 2 // <== Number of task definition to keep running on ecs service

  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.hrforte-app.arn
    container_name   = "${var.project_name}-${var.stage}-container"
    container_port   = var.port
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
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=${aws_ecs_cluster.hrforte-app.name} > /etc/ecs/ecs.config\nunset AWS_ACCESS_KEY_ID\nunset AWS_SECRET_ACCESS_KEY\nunset AWS_SESSION_TOKEN\n#set AWS_SDK_LOAD_CONFIG=0\ncd ~/.aws/config\ncd ~/.aws/\nrm config -f\nrm credentials -f"
  instance_type        = "t2.micro"

  metadata_options {
    http_tokens  = "required"
    http_endpoint = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}
