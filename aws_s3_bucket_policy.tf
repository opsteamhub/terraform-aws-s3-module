data "aws_iam_policy_document" "bucket_policy" {
  for_each = { for k, v in local.bucket_config :
    k => v["bucket_policy"] if v["bucket_policy"] != null
  }

  dynamic "statement" {
    for_each = each.value["statement"]
    content {
      sid     = statement.value["sid"]
      effect  = statement.value["effect"]
      actions = statement.value["actions"]
      resources = [for x in coalesce(statement.value["resources_prefix"], []) :
        format("%s/%s", aws_s3_bucket.bucket[each.key].arn, x)
      ]
      dynamic "principals" {
        for_each = statement.value["principals"] != null ? statement.value["principals"] : []
        content {
          type        = principals.value["type"]
          identifiers = principals.value["identifiers"]
        }
      }
      dynamic "not_principals" {
        for_each = statement.value["not_principals"] != null ? statement.value["not_principals"] : []
        content {
          type        = not_principals.value["type"]
          identifiers = not_principals.value["identifiers"]
        }
      }
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  for_each = { for k, v in local.bucket_config :
    k => v["bucket_policy"] if v["bucket_policy"] != null
  }
  bucket = each.key
  policy = data.aws_iam_policy_document.bucket_policy[each.key].json
}
