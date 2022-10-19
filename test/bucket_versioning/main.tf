module "opsteam-testecase-01-versioning" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-01-versioning"
      versioning_configuration = {
        status = "Enabled"
      }
    },
    {
      bucket_name = "opsteam-testecase-01-versioningdisabled"
    }
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-versioning.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-versioning.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-versioning.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01-versioning.finalconfig
}

