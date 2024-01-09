

module "opsteam-replication-source" {
  source = "../.././"

  region = "us-east-1"

  config = {
    bucket01 = {
      bucket        = "opsteam-s3-module-source-bucket-849430204253"
      create_bucket = false

      # replication = { #   Must have bucket versioning enabled 
      #   rule = {
      #     destination = {
      #       bucket = "teste-modulo-s3-opsteam-106926544454" # HUB CLAW OPERATION HUB #106926544454 
      #     }

      #     delete_marker_replication = {
      #       status = "Enabled"
      #     }

      #     filter = {
      #       prefix = "replicar"
      #     }

      #     id = "teste-opsteam"

      #     status = "Enabled"
      #   }

      #   different_accounts = true

      # }

      versioning = {
        versioning_configuration = {
          status = "Enabled"
        }
      }

      # sse_config = {
      #   apply_server_side_encryption_by_default = {
      #     sse_algorithm = "AES256"
      #   }
      # }

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