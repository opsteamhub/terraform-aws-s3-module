module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      versioning = {
        versioning_configuration = {
          # status = "Enabled"
          status = "Suspended"
        }
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
      versioning = {
        versioning_configuration = {
          status = "Disabled"
        }
      }
    },
  }
}


output "created_s3_buckets_info" {
  value = module.opsteam-testecase.created_s3_buckets_info
}

output "existing_s3_buckets_info" {
  value = module.opsteam-testecase.existing_s3_buckets_info
}