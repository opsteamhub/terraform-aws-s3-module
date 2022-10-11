module "opsteam-testecase-01-lifecycle" {
  source = "../.././"
  bucket_config = [
    /*
    { 
      bucket_name = "opsteam-testecase-001-nolifecycle" 
    },
    */
    {
      bucket_name = "opsteam-testecase-001-lifecycle-com-lifecycle-aaaa123456"
      lifecycle_config = {
        rule = [
          {
            id = "rule-1"
            status = "Enabled"
            expiration = {
              days = 100
            }
            transition = {
              days          = 30
              storage_class = "STANDARD_IA"
            }
          }
        ]
      }
    },
    {
      bucket_name = "opsteam-testecase-001-lifecycle-com-lifecycle--aaaa123456-2"
      lifecycle_config = {
        rule = [          
        {
          id = "tmp"

          filter = {
            prefix = "tmp/"
            }

          expiration = {
            date = "2023-01-13T00:00:00Z"
          }
          status = "Disabled"
        }          
        ]
      }
    },

  ]
}

provider "aws" {
  profile = "terraformKey"
}

/*
output "inputvar" {
  value = module.opsteam-testecase-01-lifecycle.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-lifecycle.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-lifecycle.for_input
}
*/


output "finalconfig" {
  value = module.opsteam-testecase-01-lifecycle.finalconfig
}

/*
output "leitura_entrada"{
  value = module.opsteam-testecase-01-lifecycle.entrada
}
*/