module "opsteam-testecase-01" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-01-a-123456"
    },
    {
      bucket_name = "opsteam-testecase-01-b-123456"
    },
  ]
}

output "inputvar" {
  value = module.opsteam-testecase-01.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01.finalconfig
}
