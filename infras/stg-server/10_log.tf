# LOG GROUP [flaia-app-log-group]: Initialize log group
resource "aws_cloudwatch_log_group" "flaia-app-log-group" {
  name = "flaia-app-log-group"
}

# LOG STREAM [flaia-app-log-stream]: Initialize log stream
resource "aws_cloudwatch_log_stream" "flaia-app-log-stream" {
  name           = "flaia-log-stream"
  log_group_name = aws_cloudwatch_log_group.flaia-app-log-group.name
}


