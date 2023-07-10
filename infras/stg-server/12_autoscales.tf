# AUTO SCALING TARGET [CLUSTER]: Initialize autoscaling target
resource "aws_appautoscaling_target" "datalake_autoscaling_target" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.datalake-app.name}/${aws_ecs_service.datalake-app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# AUTO SCALING POLICY [CLUSTER]: Initialize autoscaling policy
resource "aws_appautoscaling_policy" "datalake_autoscaling_policy" {
  name               = "MemoryUtilization"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.datalake_autoscaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.datalake_autoscaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.datalake_autoscaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
    target_value       = 85
  }
}

