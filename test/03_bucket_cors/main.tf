module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"

      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }

      bucket_cors = {
        cors_rule = [
          {
            allowed_headers = ["*"]
            allowed_methods = ["PUT", "POST"]
            allowed_origins = ["https://s3-website-test.hashicorp.com"]
            expose_headers  = ["ETag"]
            max_age_seconds = 3000
          },
          {
            allowed_methods = ["GET"]
            allowed_origins = ["*"]
          }
        ]
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false

      bucket_cors = {
        cors_rule = [
          {
            allowed_headers = ["*"]
            allowed_methods = ["PUT", "POST"]
            allowed_origins = ["https://s3-website-test.hashicorp.com"]
            expose_headers  = ["ETag"]
            max_age_seconds = 3000
          },
          {
            allowed_methods = ["GET"]
            allowed_origins = ["*"]
          }
        ]
      }
    },
  }
}
