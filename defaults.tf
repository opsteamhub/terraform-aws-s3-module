locals {
  bucket_names = var.bucket_config[*]["bucket_name"]

  default_bucket_config = {

    acl = {
      acl = "private"
      expected_bucket_owner =  data.aws_caller_identity.current_session.account_id 
    }

    cors_rule = {
      allowed_origins = ["*"]
      allowed_methods = ["GET"]
    }

    sse_config = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "aws/s3"
      }
      bucket_key_enabled = true
    }

    bucket_public_access_block = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }

  }



  bucket_config = { for k, v in zipmap(local.bucket_names, var.bucket_config):
    k => {

      acl = {
        acl                   = try(v["acl"]["access_control_policy"], null) == null ? coalesce(try(v["acl"]["acl"], null), local.default_bucket_config["acl"]["acl"]) : null
        access_control_policy = try(v["acl"]["access_control_policy"], null)
        expected_bucket_owner = coalesce( try(v["acl"]["expected_bucket_owner"], null), local.default_bucket_config["acl"]["expected_bucket_owner"])
      }

      #cors_rule = v["cors_rule"]

      cors_rule = [ for item in v["cors_rule"]:
        {
          id              = item["id"] 
          allowed_methods = coalesce(item["allowed_headers"], local.default_bucket_config["cors_rule"]["allowed_methods"])
          allowed_origins = coalesce(item["allowed_origins"], local.default_bucket_config["cors_rule"]["allowed_origins"])
          allowed_headers = item["allowed_headers"] 
          expose_headers  = item["expose_headers"] 
          max_age_seconds = item["max_age_seconds"] 
        }
      ]

      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = try(v["sse_config"]["apply_server_side_encryption_by_default"]["sse_algorithm"], local.default_bucket_config["sse_config"]["apply_server_side_encryption_by_default"]["sse_algorithm"])
          kms_master_key_id = try(v["sse_config"]["apply_server_side_encryption_by_default"]["kms_master_key_id"], local.default_bucket_config["sse_config"]["apply_server_side_encryption_by_default"]["kms_master_key_id"])
        }
        bucket_key_enabled = coalesce(try(v["sse_config"]["bucket_key_enabled"], null), local.default_bucket_config["sse_config"]["bucket_key_enabled"]) 
      }




      bucket_public_access_block = {
        block_public_acls       = coalesce(try(v["bucket_public_access_block"]["block_public_acls"], null), local.default_bucket_config["bucket_public_access_block"]["block_public_acls"])
        block_public_policy     = coalesce(try(v["bucket_public_access_block"]["block_public_policy"], null), local.default_bucket_config["bucket_public_access_block"]["block_public_policy"]) 
        ignore_public_acls      = coalesce(try(v["bucket_public_access_block"]["ignore_public_acls"], null), local.default_bucket_config["bucket_public_access_block"]["ignore_public_acls"])
        restrict_public_buckets = coalesce(try(v["bucket_public_access_block"]["restrict_public_buckets"], null), local.default_bucket_config["bucket_public_access_block"]["restrict_public_buckets"])
      }
  }

    }



}

output "inputvar" {
   value = var.bucket_config
}
 
output "bucketnames" {
  value = local.bucket_names
}

output "for_input" {
  value = zipmap(local.bucket_names, var.bucket_config)
}

output "finalconfig" {
  value = local.bucket_config
}
