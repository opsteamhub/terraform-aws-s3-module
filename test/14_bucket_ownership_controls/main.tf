module "opsteam-testecase" {
  source = "../.././"

  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"

      ownership_controls = {
        rule = {
          object_ownership = "BucketOwnerPreferred"
        }
      }
    }
  }
}
