resource "aws_s3_bucket_logging" "bucket_logging" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_logging != null
  }

  bucket = coalesce(each.value["bucket"], each.key)
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  expected_bucket_owner = try(each.value.bucket_logging.expected_bucket_owner, null)

  target_bucket = try(each.value.bucket_logging.target_bucket, null)

  target_prefix = try(each.value.bucket_logging.target_prefix, null)

  dynamic "target_grant" {
    for_each = each.value.bucket_logging.target_grant != null ? each.value.bucket_logging.target_grant : []
    content {
      dynamic "grantee" {
        for_each = target_grant.value.grantee != null ? target_grant.value.grantee : []
        content {
          email_address = try(grantee.value.email_address, null)
          id            = try(grantee.value.id, null)
          type          = try(grantee.value.type, null)
          uri           = try(grantee.value.uri, null)
        }
      }
      permission = try(target_grant.value.permission, null)
    }
  }

  dynamic "target_object_key_format" {
    for_each = each.value.bucket_logging.target_object_key_format != null ? each.value.bucket_logging.target_object_key_format : []
    content {
      dynamic "partitioned_prefix" {
        for_each = target_object_key_format.value.partitioned_prefix != null ? target_object_key_format.value.partitioned_prefix : []
        content {
          partition_date_source = try(partitioned_prefix.value.partition_date_source, null)
        }
      }
      dynamic "simple_prefix" {
        for_each = try(target_object_key_format.value.simple_prefix, false) == true ? [tomap({ "simple_prefix" = "" })] : []
        content {}
      }
    }
  }
}
