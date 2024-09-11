resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  for_each = {
    for key, value in var.config : key => value
    if value.ownership_controls != null
  }

  bucket = each.value["bucket_prefix"] == null ? coalesce(each.value["bucket"], each.key) : null
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  rule {
    object_ownership = try(each.value.ownership_controls.rule.object_ownership, null)

  }
}