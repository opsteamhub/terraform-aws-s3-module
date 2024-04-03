

resource "aws_s3_bucket_ownership_controls" "bucket_ownership_control" {

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_acl != null
  }

  bucket = each.value.bucket
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }

}


resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.bucket_acl != null
  }

  bucket = each.value.bucket
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  acl = try(each.value.bucket_acl.acl, null)

  dynamic "access_control_policy" {
    for_each = each.value.bucket_acl.access_control_policy != null ? tomap({ "access_control_policy" = each.value.bucket_acl.access_control_policy }) : {}

    content {
      dynamic "grant" {
        for_each = access_control_policy.value.grant != null ? tomap({ "grant" = access_control_policy.value.grant }) : {}

        content {
          grantee {
            email_address = try(grant.value.grantee.email_address, null)
            id            = try(grant.value.grantee.id, null)
            type          = try(grant.value.grantee.type, null)
            uri           = try(grant.value.grantee.uri, null)
          }
          permission = try(grant.value.permission, null)
        }
      }

      dynamic "owner" {
        for_each = access_control_policy.value.owner != null ? tomap({ "owner" = access_control_policy.value.owner }) : tomap({ "owner" = { id = data.aws_canonical_user_id.current_user.id, display_name = null } })


        content {
          id           = try(owner.value.id, null)
          display_name = try(owner.value.display_name, null)
        }
      }
    }
  }

  expected_bucket_owner = try(each.value.bucket_acl.expected_bucket_owner, null)

}


