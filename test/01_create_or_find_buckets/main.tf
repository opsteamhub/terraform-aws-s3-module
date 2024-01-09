module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"

      # bucket_prefix = "Teste" # Não pode ser usado junto com o argumento bucket se não dá conflito

      force_destroy = true

      object_lock_enabled = true

      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
    },
  }
}

output "created_s3_buckets_info" {
  value = module.opsteam-testecase.created_s3_buckets_info
}

output "existing_s3_buckets_info" {
  value = module.opsteam-testecase.existing_s3_buckets_info
}