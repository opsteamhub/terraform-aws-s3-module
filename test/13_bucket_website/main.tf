module "opsteam-testecase" {
  source = "../.././"

  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"

      website_config = {
        index_document = {
          suffix = "index.html"
        }
        error_document = {
          key = "error.html"
        }
      }
    }
  }
}
