resource "aws_cloudwatch_metric_alarm" "database_storage_alert" {
  alarm_name          = "${var.env}-database-storage-alert"
  evaluation_periods  = "1"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Minimum"
  threshold           = "1073741824"
  evaluation_periods  = "1"
  alarm_description   = "Alert generated if the DB has less than a 1gb of spage left"
  alarm_actions       = ["${var.cloudwatch_alarm_arn}"]

  dimensions {
    "DBInstanceIdentifier" = "${aws_db_instance.survey_runner_database.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "database_cpu_alert" {
  alarm_name          = "${var.env}-database-cpu-alert"
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  evaluation_periods  = "1"
  alarm_description   = "Alert generated if the DB is using more than 80% CPU"
  alarm_actions       = ["${var.cloudwatch_alarm_arn}"]

  dimensions {
    "DBInstanceIdentifier" = "${aws_db_instance.survey_runner_database.identifier}"
  }
}

resource "aws_cloudwatch_metric_alarm" "database_free_memory_alert" {
  alarm_name          = "${var.env}-database-free-memory-alert"
  evaluation_periods  = "1"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = "524288000"
  evaluation_periods  = "1"
  alarm_description   = "Alert generated if the DB has less than a 512MB of memory left"
  alarm_actions       = ["${var.cloudwatch_alarm_arn}"]

  dimensions {
    "DBInstanceIdentifier" = "${aws_db_instance.survey_runner_database.identifier}"
  }
}