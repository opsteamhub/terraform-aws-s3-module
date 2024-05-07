resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_cors != null
  }

  bucket = coalesce(each.value["bucket"], each.key)
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  dynamic "cors_rule" {
    for_each = each.value.bucket_cors.cors_rule != null ? each.value.bucket_cors.cors_rule : []

    content {
      allowed_methods = try(cors_rule.value.allowed_methods, null)
      allowed_origins = try(cors_rule.value.allowed_origins, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      id              = try(cors_rule.value.id, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }

  expected_bucket_owner = try(each.value.bucket_cors.expected_bucket_owner, null)

}


