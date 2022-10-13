module "opsteam-testecase-sse-config-01" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-sse-config-01-sses3-true"
      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm = "AES256"
        }
      }
    },
  ]
}
