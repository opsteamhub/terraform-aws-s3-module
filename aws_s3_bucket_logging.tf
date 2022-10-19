resource "aws_s3_bucket_logging" "logging" {

  for_each = { for k, v in local.bucket_config :
    k => v["logging_config"] if v["logging_config"]["target_bucket"] != null
  }

  bucket = each.key

  target_bucket         = each.value["target_bucket"]
  target_prefix         = each.value["target_prefix"]
  expected_bucket_owner = each.value["expected_bucket_owner"]
  dynamic "target_grant" {
    for_each = { for x in [each.value["target_grant"]] :
      "target_grant" => x if x["permission"] != null
    }
    content {
      permission = target_grant.value["permission"]
      grantee {
        email_address = target_grant.value["grantee"]["email_address"]
        id            = target_grant.value["grantee"]["id"]
        type          = target_grant.value["grantee"]["type"]
        uri           = target_grant.value["grantee"]["uri"]
      }
    }
  }
}
