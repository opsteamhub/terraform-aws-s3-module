module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
      bucket_logging = {
        target_bucket = "opsteam-testecase-b" # Name of the bucket where you want Amazon S3 to store server access logs.
        target_prefix = "log/"

        target_object_key_format = [
          {
            # partitioned_prefix e simple_prefix entram em conflito

            partitioned_prefix = [
              {
                partition_date_source = "EventTime" # ou "DeliveryTime", conforme necessário
              }
            ]

            simple_prefix = false # Se você usar partitioned_prefix, você deve declarar simple_prefix como false, ou simplesmente omitir esse parametro para que seja entendido como nulo
            # simple_prefix = true # Não pode ser usado junto com uma declaração de partitioned_prefix 
          }
        ]
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false

    },
  }
}
