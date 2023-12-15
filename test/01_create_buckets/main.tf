module "opsteam-testecase-01" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-01-a-123456"

      # bucket_prefix = "Teste" # Não pode ser usado junto com o argumento bucket se não dá conflito

      force_destroy = true

      object_lock_enabled = true

      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
    },
    bucket02 = {
      bucket        = "carbon.emission.estimations"
      create_bucket = false
    },
  }
}

output "created_s3_buckets_info" {
  value = module.opsteam-testecase-01.created_s3_buckets_info
}

output "existing_s3_buckets_info" {
  value = module.opsteam-testecase-01.existing_s3_buckets_info
}