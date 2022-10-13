module "opsteam-testecase-01-logging" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-logging"
      logging_config = {
        target_bucket = "opsteam-testecase-001-nologging"
        target_prefix = "/log"
      }
    },
    {
      bucket_name = "opsteam-testecase-001-nologging"
    },
    {
      bucket_name = "opsteam-testecase-002-logging"
      logging_config = {
        target_bucket = "opsteam-testecase-001-nologging"
        target_prefix = "/log"
        target_grant = {
          permission = "READ"
          grantee = {
            type = "CanonicalUser"
            id   = "e2fdf456ca518ed2dc91e27cee7687b17b47d4aafef38abd07b5383e0ffc5e2c"
          }
        }
      }
    }
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-logging.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-logging.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-logging.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01-logging.finalconfig
}
