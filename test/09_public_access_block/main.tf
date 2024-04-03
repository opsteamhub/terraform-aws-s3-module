module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
      public_access_block = {
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = false
        restrict_public_buckets = false
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
      public_access_block = {
        block_public_acls       = false
        block_public_policy     = false
        ignore_public_acls      = true
        restrict_public_buckets = true
      }
    },
  }
}
