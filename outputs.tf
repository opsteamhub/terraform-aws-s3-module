output "created_s3_buckets_info" {
  value = { for k, v in aws_s3_bucket.bucket : k => try(v, null) }
}

output "existing_s3_buckets_info" {
  value = { for k, v in data.aws_s3_bucket.bucket : k => try(v, null) }
}