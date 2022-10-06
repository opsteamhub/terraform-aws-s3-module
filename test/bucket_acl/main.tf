module "opsteam-testecase-01-acl-public" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-acl-public"
      acl = {
        access_control_policy = {
          grant = [
            {
              grantee = {
                id   = "e2fdf456ca518ed2dc91e27cee7687b17b47d4aafef38abd07b5383e0ffc5e2c" 
                type = "CanonicalUser"
              }
              permission = "READ"
            }
          ]
        }
      }
    },
    {
      bucket_name = "opsteam-testecase-002-acl-public"
      acl = {
        acl = "public-read"
      }
      bucket_public_access_block = {
        block_public_acls       = false
        block_public_policy     = false
        ignore_public_acls      = false
        restrict_public_buckets = false
      }
    },
    { 
      bucket_name = "opsteam-testecase-003-acl-private-implicity" 
    }
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-acl-public.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-acl-public.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-acl-public.for_input
}

output "finalconfig" {
value = module.opsteam-testecase-01-acl-public.finalconfig
}

