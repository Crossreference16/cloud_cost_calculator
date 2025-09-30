resource "aws_s3_bucket" "dashboard" {  
  bucket = "dasboard-bucket"
  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  // S3 bucket for storing the dashboard
}