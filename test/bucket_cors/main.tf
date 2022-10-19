module "opsteam-testecase-01-cors" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-cors"
      cors_rule = [
        {
          max_age_seconds = 3000
        },
        {
          max_age_seconds = 3001
        }
      ]
    },
    {
      bucket_name = "opsteam-testecase-001-nocors"
    }
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-cors.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-cors.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-cors.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01-cors.finalconfig
}

