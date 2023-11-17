data "aws_caller_identity" "current_session" {}
data "aws_canonical_user_id" "current_session" {}

output "s3_bucket" {
  value = aws_s3_bucket.bucket
}
