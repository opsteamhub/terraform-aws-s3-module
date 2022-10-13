module "opsteam-testecase-01-metric" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-nometric"
    },
    {
      bucket_name = "opsteam-testecase-001-metric"
      metric = [
        {
          name = "teste"
          filter = [
            {
              prefix = "documents/*"
              tags = {
                class = "high"
              }
            }
          ]
        },
        {
          name = "teste2"
          filter = [
            {
              prefix = "documents2/*"
              tags = {
                class = "high2"
              }
            }
          ]
        }
      ]
    },
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-metric.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-metric.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-metric.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01-metric.finalconfig
}

