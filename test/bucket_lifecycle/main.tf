module "opsteam-testecase-01-lifecycle" {
  source = "/Users/brunopaiuca/projects/opsteam/terraform-modules/terraform-s3-module"
  bucket_config = [
    { 
      bucket_name = "opsteam-testecase-001-nolifecycle"  # Objeto 1
    },
    {
      bucket_name = "opsteam-testecase-001-lifecycle-to-STDIA"  # Objeto 2
      lifecycle_config = {
        id = "move-logs-to-standard-ia"
        rule = [
            {
            id = "config"
            filter = {
              prefix = "config/"
            }
            noncurrent_version_expiration = {
              noncurrent_days = 90
            }
            noncurrent_version_transition = {
              noncurrent_days = 30
              storage_class   = "STANDARD_IA"
            }
            noncurrent_version_transition = {
              noncurrent_days = 60
              storage_class   = "GLACIER"
            }
            status = "Enabled"
          }
        ]
      }
    }
  ]
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

