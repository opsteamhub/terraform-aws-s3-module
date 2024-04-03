data "aws_iam_policy_document" "bucket_policy" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_policy != null
  }

  dynamic "statement" {
    for_each = each.value.bucket_policy.statement

    content {

      actions = try(statement.value["actions"], null)

      dynamic "condition" {
        for_each = statement.value["condition"] != null ? statement.value["condition"] : []
        content {
          test     = try(condition.value["test"], null)
          values   = try(condition.value["values"], null)
          variable = try(condition.value["variable"], null)
        }
      }

      effect = try(statement.value["effect"], null)

      not_actions = try(statement.value["not_actions"], null)

      dynamic "not_principals" {
        for_each = statement.value["not_principals"] != null ? statement.value["not_principals"] : []
        content {
          type        = try(not_principals.value["type"], null)
          identifiers = try(not_principals.value["identifiers"], null)
        }
      }

      not_resources = try(statement.value["not_resources"], null)

      dynamic "principals" {
        for_each = statement.value["principals"] != null ? statement.value["principals"] : []
        content {
          type        = try(principals.value["type"], null)
          identifiers = try(principals.value["identifiers"], null)
        }
      }

      resources = try(statement.value["resources"], null)

      sid = try(statement.value["sid"], null)

    }
  }
}


resource "aws_s3_bucket_policy" "bucket_policy" {

  depends_on = [data.aws_iam_policy_document.bucket_policy]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_policy != null
  }

  bucket = each.value.bucket
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  policy = data.aws_iam_policy_document.bucket_policy[each.key].json

}

