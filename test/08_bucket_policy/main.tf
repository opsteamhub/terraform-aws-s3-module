module "opsteam-testecase" {
  source = "../.././"
  config = {
    bucket01 = {
      bucket = "opsteam-testecase-a"
      tags = {
        Name        = "My bucket"
        Environment = "Dev"
      }
      bucket_policy = {
        statement = [
          {
            actions = ["s3:GetObject"]
            effect  = "Allow"
            resources = [
              "arn:aws:s3:::opsteam-testecase-a",
              "arn:aws:s3:::opsteam-testecase-a/*"
            ]
            principals = [
              {
                type        = "AWS"
                identifiers = ["arn:aws:iam::849430204253:root"]
              }
            ]
            sid = "test"
          }
        ]
      }
    },
    bucket02 = {
      bucket        = "opsteam-testecase-b"
      create_bucket = false
      bucket_policy = {
        statement = [
          {
            actions = [
              "s3:GetObject",
              "s3:ListBucket",
              "s3:ListBucketVersions"
            ]
            effect = "Allow"
            resources = [
              "arn:aws:s3:::opsteam-testecase-b",
              "arn:aws:s3:::opsteam-testecase-b/*"
            ]
            principals = [
              {
                type        = "AWS"
                identifiers = ["arn:aws:iam::770831555164:user/carlos.biagolini"]
              }
            ]
            sid = "test"
          }
        ]
      }
    },
  }
}

output "aws_iam_policy_document_info" {
  value = module.opsteam-testecase.aws_iam_policy_document_info
}
