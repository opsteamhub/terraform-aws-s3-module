terraform {
  required_version = ">=1.4.5"

  backend "s3" {
    bucket = "opsteam-terraform-modules-tfstate-dev"
    key    = "terraform/OpsTeamModules/s3.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  # Common tags to be used in all new resources
  default_tags {
    tags = {
      "opsteam:id"        = "0001"
      "opsteam:client_id" = "CL001"
      environment         = "Dev"
      owner               = "TFProviders"
      project             = "ASG"
    }
  }
}
