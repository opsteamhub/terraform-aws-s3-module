module "opsteam-testecase-01" {
  source = "/Users/brunopaiuca/projects/opsteam/terraform-modules/terraform-s3-module"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-01-a"
    },
    {
      bucket_name = "opsteam-testecase-01-b"
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
