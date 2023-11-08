resource "aws_s3_bucket_acl" "bucket_acl" {
  for_each              = local.bucket_config
  bucket                = each.key
  acl                   = each.value["acl"]["acl"]
  expected_bucket_owner = each.value["acl"]["expected_bucket_owner"]
  dynamic "access_control_policy" {
    for_each = each.value["acl"]["access_control_policy"] != null ? [each.value["acl"]["access_control_policy"]] : []
    content {
      dynamic "grant" {
        for_each = try(access_control_policy.value["grant"], [])
        content {
          grantee {
            id            = grant.value["grantee"]["id"]
            email_address = grant.value["grantee"]["email_address"]
            type          = grant.value["grantee"]["type"]
            uri           = grant.value["grantee"]["uri"]
          }
          permission = grant.value["permission"]
        }
      }
      owner {
        id = try(tostring(access_control_policy.value["owner"]), tostring(data.aws_canonical_user_id.current_session.id))
      }
    }
  }
  depends_on = [aws_s3_bucket_public_access_block.public_access_block, aws_s3_bucket_ownership_controls.ownership_control]
}