resource "aws_sns_topic" "cost_alerts" {
  name = "cost_alerts"
  // SNS topic for cost alerts
} 

resource "aws_sns_topic_subscription" "cost_alerts_email" {
    topic_arn = aws_sns_topic.cost_alerts.arn
    protocol  = "email"
    endpoint  = var.alert_email
    // Subscription to the SNS topic for email alerts
} 

variable "currency" {
  description = "The currency to use for AWS billing alarms (e.g., GBP, USD, EUR)."
  type        = string
  default     = "GBP"
} // Default currency is GBP

resource "aws_cloudwatch_metric_alarm" "monthly_cost" {
  provider = aws.us-east-1
  alarm_name          = "monthly_cost_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600 // in secs, equal to 6 hours
  statistic           = "Maximum"
  threshold           = var.cost_threshold
  alarm_description   = "Alarm when monthly AWS cost exceeds the defined threshold"
  dimensions = {
    Currency = var.currency
  }
  alarm_actions       = [aws_sns_topic.cost_alerts.arn]
  // CloudWatch alarm for monitoring monthly AWS costs
  
}


