module "opsteam-testecase-01-lifecycle" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-no-lifecycle-null-test"
    },
    {
      bucket_name = "opsteam-testecase-001-lifecycle-com-lifecycle"
      lifecycle_config = {
        rule = [
          {
            id     = "Testing rules"
            status = "Disabled"
            expiration = {
              days = 100
            }
            transition = {
              days          = 30
              storage_class = "STANDARD_IA"
            }
            transition = {
              days          = 60
              storage_class = "GLACIER"
            }
            filter = {
              tag = {
                key   = "Name"
                value = "Staging"
              }
            }
          }
        ]
      }
    },
    {
      bucket_name = "opsteam-testecase-001-lifecycle-com-lifecycle-several-filters"
      lifecycle_config = {
        rule = [
          {
            id = "Several filters"
            filter = {
              and = {
                prefix                   = "logs/"
                object_size_greater_than = 500
                object_size_less_than    = 64000
                tags = {
                  cycle = "yes"
                  team  = "sales"
                }
              }
            }
            expiration = {
              date = "2023-01-13T00:00:00Z"
            }
            status = "Enabled"
          }
        ]
      }
    },
  ]
}

provider "aws" {
  profile = "terraformKey"
}

output "inputvar" {
  value = module.opsteam-testecase-01-lifecycle.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-lifecycle.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-lifecycle.for_input
}


output "finalconfig" {
  value = module.opsteam-testecase-01-lifecycle.finalconfig
}
