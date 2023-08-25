# ===================== #
# ==> SCALING TASKS <== #
# ===================== #

# AUTO SCALING TARGET [CLUSTER]: Initialize autoscaling target
resource "aws_appautoscaling_target" "hrforte_autoscaling_target" {
  max_capacity       = 6 # Max capacity of the scalable target (Max number of tasks can run in the service)
  min_capacity       = 2 # Min capacity of the scalable target (Min number of tasks can run in the service)
  resource_id        = "service/${aws_ecs_cluster.hrforte-app.name}/${aws_ecs_service.hrforte-app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# AUTO SCALING POLICY [CLUSTER]: Initialize autoscaling policy
resource "aws_appautoscaling_policy" "hrforte_autoscaling_policy" {
  name               = "MemoryUtilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.hrforte_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.hrforte_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.hrforte_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
    target_value       = 90
  }
}

# =================== #
# ==> SCALING EC2 <== #
# =================== #

# ECS [AUTOSCALING GROUP]
resource "aws_autoscaling_group" "hrforte_platform" {
  name                 = "hrforte-platform"
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  desired_capacity = 2 // ==> Number of EC2 instances that should be running in the group
  min_size         = 2 // ==> Minimum size of the Auto Scaling Group
  max_size         = 6 // ==> Maximum size of the Auto Scaling Group.
}

# ECS [AUTOSCALING POLICY]
resource "aws_autoscaling_policy" "hrforte_hrforte_platform" {
  name                   = "hrforte-platform-policy"
  autoscaling_group_name = aws_autoscaling_group.hrforte_platform.name
  policy_type            = "TargetTrackingScaling"

  // For customized metrics
  target_tracking_configuration {
    customized_metric_specification {
      metric_dimension {
        name  = "ClusterName"
        value = "hrforte"
      }
      metric_name = "MemoryUtilization"
      namespace   = "AWS/ECS"
      statistic   = "Average"
      unit        = "Percent"
    }
    target_value = 80.0
  }
}
