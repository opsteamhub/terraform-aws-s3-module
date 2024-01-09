module "opsteam-testecase" {
  source = "../../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"

      replication = { #   Must have bucket versioning enabled 
        rule = {
          destination = {
            bucket = "teste-modulo-s3-opsteam-106926544454" # HUB CLAW OPERATION HUB #106926544454 
          }

          delete_marker_replication = {
            status = "Enabled"
          }

          filter = {
            prefix = "replicar"
          }

          id = "teste-opsteam"

          status = "Enabled"
        }

        different_accounts = true

      }

      versioning = {
        versioning_configuration = {
          status = "Enabled"
        }
      }

      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm = "AES256"
        }
      }



    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false

      versioning = {
        versioning_configuration = {
          status = "Enabled"
        }
      }
    },
  }
}


# module "opsteam-testecase-01-replication" {
#   source = "../.././"
#   bucket_config = [
#     {
#       bucket_name = "opsteam-testecase-001-no-replication-null-test"
#     },
#     {
#       bucket_name = "cb.replication.source"

#       versioning_configuration = {
#         status = "Enabled"
#       }
#       sse_config = {
#         apply_server_side_encryption_by_default = {
#           sse_algorithm = "AES256"
#         }
#       }
#       replication = {

#         different_accounts = true

#         rule = {
#           delete_marker_replication = {
#             status = "Enabled"
#           }

#           destination = {
#             bucket = "cb.replication.destination"
#           }

#           filter = {
#             prefix = "replicar"
#           }
#           id     = "teste-opsteam"
#           status = "Enabled"
#         }
#       }
#     }
#   ]
# }

# provider "aws" {
#   profile = "terraformKey"
# }


# output "inputvar" {
#   value = module.opsteam-testecase-01-replication.inputvar
# }

# output "bucketnames" {
#   value = module.opsteam-testecase-01-replication.bucketnames
# }

# output "for_input" {
#   value = module.opsteam-testecase-01-replication.for_input
# }


# output "finalconfig" {
#   value = module.opsteam-testecase-01-replication.finalconfig
# }

