module "opsteam-testecase-sse-config-kms" {
  source = "/Users/brunopaiuca/projects/opsteam/terraform-modules/terraform-s3-module"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-sse-config-ssekms-default"
    },
    {
      bucket_name = "opsteam-testecase-sse-config-ssekms-explicity"
      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm = "aws:kms"
        }
      }
    },
#    {
#      bucket_name = "opsteam-testecase-sse-config-kms-ssekms-false"
#      sse_config = {
#         bucket_key_enabled = false
#      }
#    },
  ]
}
