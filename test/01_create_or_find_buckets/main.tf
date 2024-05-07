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
    "opsteam-testecase-b" = {
      # Método alternativo de criar bucket, sem usar nenhum argumento. Nesse caso será usado a chave do map como nome do bucket

    },
    # bucket03 = {
    #   # Nesse exemplo nós não criamos o bucket, mas sim usamos um bucket já existente
    #   bucket        = "opsteam-testecase-c"
    #   create_bucket = false
    # },
  }
}

output "created_s3_buckets_info" {
  value = module.opsteam-testecase.created_s3_buckets_info
}

output "existing_s3_buckets_info" {
  value = module.opsteam-testecase.existing_s3_buckets_info
}