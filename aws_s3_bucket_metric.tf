resource "aws_s3_bucket_metric" "metric" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_metric != null
  }

  bucket = coalesce(each.value["bucket"], each.key)
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  name = try(each.value.bucket_metric.name, null)

  dynamic "filter" {
    for_each = each.value.bucket_metric.filter != null ? each.value.bucket_metric.filter : []
    content {
      prefix = try(filter.value.prefix, null)
      tags   = try(filter.value.tags, null)
    }
  }
}