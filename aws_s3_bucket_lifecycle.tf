resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle_configuration" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_lifecycle != null
  }

  bucket = each.value["bucket_prefix"] == null ? coalesce(each.value["bucket"], each.key) : aws_s3_bucket.bucket[each.key].id
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  expected_bucket_owner = try(each.value.bucket_lifecycle.expected_bucket_owner, null)
  dynamic "rule" {
    for_each = each.value.bucket_lifecycle.rule != null ? each.value.bucket_lifecycle.rule : []
    content {
      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload != null ? tomap({ "abort_incomplete_multipart_upload" = rule.value.abort_incomplete_multipart_upload }) : {}
        content {
          days_after_initiation = try(abort_incomplete_multipart_upload.value.days_after_initiation, null)
        }
      }

      dynamic "expiration" {
        for_each = rule.value.expiration != null ? tomap({ "expiration" = rule.value.expiration }) : {}
        content {
          date = try(expiration.value.date, null)
          # day = try(expiration.value.day, null) # Está na documentação, mas inserir no codigo temos o erro de Unexpected attribute
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      dynamic "filter" {
        for_each = rule.value.filter != null ? tomap({ "filter" = rule.value.filter }) : {}
        content {
          # and = try(filter.value.and, null) # Está na documentação, mas inserir no codigo temos o erro de Unexpected attribute

          object_size_greater_than = try(filter.value.object_size_greater_than, null)

          object_size_less_than = try(filter.value.object_size_less_than, null)

          prefix = try(filter.value.prefix, null)

          # tag = try(filter.value.tag, null) # Está na documentação, mas inserir no codigo temos o erro de Unexpected attribute
        }
      }


      id = try(rule.value.id, null)

      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? rule.value.noncurrent_version_expiration : []
        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transition != null ? rule.value.noncurrent_version_transition : []
        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = try(noncurrent_version_transition.value.storage_class, null)
        }
      }

      #
      # DEPRECATED
      #
      # prefix = try(rule.value.prefix, null)

      status = try(rule.value.status, null)

      dynamic "transition" {
        for_each = rule.value.transition != null ? rule.value.transition : []
        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = try(transition.value.storage_class, null)
        }
      }
    }

  }
}


