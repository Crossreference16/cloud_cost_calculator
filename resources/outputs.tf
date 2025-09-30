output "aws_sns_topic_arn" {
  value = aws_sns_topic.cost_alerts.arn
  
}

output "s3_dashboard_url" {
  # value = aws_s3_bucket.cost-dashboard.website_endpoint // this was the original line before the edit
  value = "http://${aws_s3_bucket_website_configuration.cost-dashboard.website_domain}"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.cost-dashboard.bucket
  key          = "index.html"
  source       = "website/index.html" # path to my local index.html
  content_type = "text/html"
  acl          = "public-read"
}