module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
      bucket_metric = {
        name = "teste"

        filter = [
          {
            prefix = "documents/*"
            tags = {
              class = "high"
            }
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
