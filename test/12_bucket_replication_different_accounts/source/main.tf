module "opsteam-replication-source" {
  source = "../../.././"
  config = {
    bucket01 = {
      bucket        = "opsteam-s3-module-source-bucket-849430204253"
      create_bucket = false
      replication = {
        rule = {
          destination = {

            bucket = "opsteam-s3-module-destination-bucket-770831555164"

            account = "770831555164" # only required if is been replicated to a different account owner
            access_control_translation = {
              owner = "Destination"
            }
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
      }

      versioning = { #   Must have bucket versioning enabled 
        versioning_configuration = {
          status = "Enabled"
        }
      }
    }
  }
}
