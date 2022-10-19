module "opsteam-testecase-01-nobucketpolicy" {
  source = "../.././"
  bucket_config = [
    {
      bucket_name = "opsteam-testecase-001-nobucketpolicy"
    },
    {
      bucket_name = "opsteam-testecase-001-bucketpolicy"
      bucket_policy = {
        statement = [
          {
            effect           = "Allow"
            actions          = ["s3:GetObject"]
            resources_prefix = ["*"]
            principals = [
              {
                type        = "AWS"
                identifiers = ["arn:aws:iam::770831555164:user/juan.ferreira"]
              }
            ]
            notprincipals = [
              {
                type        = "AWS"
                identifiers = ["arn:aws:iam::770831555164:user/juan.ferreira"]
              }
            ]
          }
        ]
      }
    },
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-nobucketpolicy.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-nobucketpolicy.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-nobucketpolicy.for_input
}

output "finalconfig" {
  value = module.opsteam-testecase-01-nobucketpolicy.finalconfig
}

