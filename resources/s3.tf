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

# resource "aws_s3_bucket_public_access_block" "dashboard" {
#   bucket = aws_s3_bucket.cost-dashboard.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
#   // This configuration allows public access to the S3 bucket
# }


# resource "aws_s3_bucket_policy" "public_read" {
#   bucket = aws_s3_bucket.cost-dashboard.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = "*"
#         Action = "s3:GetObject"
#         Resource = "${aws_s3_bucket.cost-dashboard.arn}/*"
#       }
#     ]
#   })
#   // This policy makes the S3 bucket publicly readable
# }

