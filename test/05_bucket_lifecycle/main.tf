module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
      bucket_lifecycle = {
        rule = [
          {
            id = "rule-1"

            filter = {
              prefix = "config/"
            }
            noncurrent_version_expiration = [
              {
                noncurrent_days = 90
              }
            ]
            status = "Enabled"
          }
        ]
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
      bucket_lifecycle = {
        rule = [
          {
            id = "rule-A"
            noncurrent_version_expiration = [
              {
                noncurrent_days = 90
              }
            ]
            noncurrent_version_transition = [
              {
                noncurrent_days = 30
                storage_class   = "STANDARD_IA"
              },
              {
                noncurrent_days = 60
                storage_class   = "GLACIER"
              }
            ]
            status = "Enabled"

          }
        ]
      }
    },
  }
}
