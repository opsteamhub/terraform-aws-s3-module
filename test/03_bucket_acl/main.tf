module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }

      bucket_acl = {

        # acl = "public-read"

        access_control_policy = {
          grant = {
            grantee = {
              id   = data.aws_canonical_user_id.current.id
              type = "CanonicalUser"
            }
            permission = "READ"
          }
          owner = {
            id = data.aws_canonical_user_id.current.id
          }
        }
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
    },
  }
}

output "created_s3_buckets_info" {
  value = module.opsteam-testecase.created_s3_buckets_info
}

output "existing_s3_buckets_info" {
  value = module.opsteam-testecase.existing_s3_buckets_info
}