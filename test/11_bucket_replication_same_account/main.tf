

module "opsteam-replication-source" {
  source = "../.././"

  region = "us-east-1"

  config = {
    bucket01 = {
      bucket        = "opsteam-s3-module-source-bucket-849430204253"
      create_bucket = false
      is_source     = true
      replication = {
        rule = {
          destination = {
            bucket = "opsteam-s3-module-destination-bucket-849430204253"
          }
          id = "replicateAll"
          delete_marker_replication = {
            status = "Enabled"
          }
          filter = {
            prefix = "*"
          }
          status = "Enabled"
        }
        different_accounts = false
      }

      versioning = { #   Must have bucket versioning enabled 
        versioning_configuration = {
          status = "Enabled"
        }
      }
    }
  }
}


module "opsteam-replication-destiantion" {
  source = "../.././"
  region = "us-east-2"
  config = {
    bucket01 = {
      bucket        = "opsteam-s3-module-destination-bucket-849430204253"
      create_bucket = false
      versioning = {
        versioning_configuration = {
          status = "Enabled"
        }
      }
    }
  }
}