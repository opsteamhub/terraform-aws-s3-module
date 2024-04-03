module "opsteam-testecase" {
  source = "../.././"

  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm = "AES256"
        }
      }
    }
  }
}
