resource "aws_s3_bucket" "cost-dashboard" {  
  bucket = "dashboard-bucket-khalil-12345"
  // S3 bucket for storing the dashboard
}

resource "aws_s3_bucket_website_configuration" "cost-dashboard" {
  bucket = aws_s3_bucket.cost-dashboard.id

  index_document {
    suffix = "index.html"
    // Index document for the website (this is has been done, find it in s3_dashboard folder)
  }

  error_document {
    key = "error.html"
    // Error document for the website (not done yet)
  }
}