resource "aws_s3_bucket_server_side_encryption_configuration" "sse_config" {
  for_each = local.bucket_config

  bucket   = each.key

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = each.value["sse_config"]["apply_server_side_encryption_by_default"]["kms_master_key_id"]
      sse_algorithm     = each.value["sse_config"]["apply_server_side_encryption_by_default"]["sse_algorithm"]
    }
    bucket_key_enabled  = each.value["sse_config"]["bucket_key_enabled"]
  }
}
