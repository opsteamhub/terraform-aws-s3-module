module "opsteam-testecase-source" {
  source = "../.././"

  region = "us-east-1"

  config = {
    bucket01 = {
      bucket = "opsteam-s3-module-dev-replication-source"
    }
  }
}


module "opsteam-testecase-destiantion" {
  source = "../.././"

  region = "us-east-2"

  config = {
    bucket01 = {
      bucket = "opsteam-s3-module-dev-replication-destination"
    }
  }
}