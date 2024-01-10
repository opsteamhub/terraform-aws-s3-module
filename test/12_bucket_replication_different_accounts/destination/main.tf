
module "opsteam-replication-destiantion" {
  source = "../../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-s3-module-destination-bucket-770831555164"
      versioning = {
        versioning_configuration = {
          status = "Enabled"
        }
      }

      replication = {
        external_account_info = {
          role_arn = "arn:aws:iam::849430204253:role/tf-role-replication-opsteam-s3-module-source-bucket-849430204253"
        }
      }
    }
  }
}