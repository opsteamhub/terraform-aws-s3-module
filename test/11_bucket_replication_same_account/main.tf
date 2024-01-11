module "opsteam-replication-source" {
  source = "../.././"

  region = "us-east-1"

  config = {
    bucket01 = {
      bucket = "opsteam-s3-module-source-bucket-849430204253"
      # create_bucket = false # Use false If the bucket already exists
      replication = {
        rule = { # Só tem rule quem é source bucket
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

      }

      versioning = { # Bucket de origem e destino precisam ter versionamento ativado 
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
      bucket = "opsteam-s3-module-destination-bucket-849430204253"
      # create_bucket = false # Use false If the bucket already exists
      versioning = { # Bucket de origem e destino precisam ter versionamento ativado 
        versioning_configuration = {
          status = "Enabled"
        }
      }
    }
  }
}