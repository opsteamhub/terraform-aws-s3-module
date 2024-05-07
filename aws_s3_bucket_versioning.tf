resource "aws_s3_bucket_versioning" "versioning" {

  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.versioning != null
  }

  bucket = coalesce(each.value["bucket"], each.key)
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  versioning_configuration {
    status     = try(each.value.versioning.versioning_configuration.status, null)
    mfa_delete = try(each.value.versioning.versioning_configuration.mfa_delete, null)
  }

  expected_bucket_owner = try(each.value.versioning.expected_bucket_owner, null)

  mfa = try(each.value.versioning.mfa, null)

}

