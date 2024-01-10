resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {

  for_each = {
    for key, value in var.config : key => value
    if value.sse_config != null
  }

  bucket = each.value.bucket

  expected_bucket_owner = try(each.value.sse_config.expected_bucket_owner, null)

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = try(each.value.sse_config.apply_server_side_encryption_by_default.kms_master_key_id, "aws/s3")
      sse_algorithm     = try(each.value.sse_config.apply_server_side_encryption_by_default.sse_algorithm, "aws:kms")
    }
    bucket_key_enabled = try(each.value.sse_config.bucket_key_enabled, true)
  }
}
