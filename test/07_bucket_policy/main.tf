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

            effect = "Allow"

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
    },
  }
}






# output "aws_iam_policy_document_info" {
#   value = module.opsteam-testecase.aws_iam_policy_document_info
# }



# module "opsteam-testecase-01-nobucketpolicy" {
#   source = "../.././"
#   bucket_config = [
#     {
#       bucket_name = "opsteam-testecase-001-nobucketpolicy"
#     },
#     {
#       bucket_name = "opsteam-testecase-001-bucketpolicy"
#       bucket_policy = {
#         statement = [
#           {
#             effect           = "Allow"
#             actions          = ["s3:GetObject"]
#             resources_prefix = ["*"]
#             principals = [
#               {
#                 type        = "AWS"
#                 identifiers = ["arn:aws:iam::770831555164:user/juan.ferreira"]
#               }
#             ]
#             notprincipals = [
#               {
#                 type        = "AWS"
#                 identifiers = ["arn:aws:iam::770831555164:user/juan.ferreira"]
#               }
#             ]
#           }
#         ]
#       }
#     },
#   ]
# }



# output "inputvar" {
#   value = module.opsteam-testecase-01-nobucketpolicy.inputvar
# }

# output "bucketnames" {
#   value = module.opsteam-testecase-01-nobucketpolicy.bucketnames
# }

# output "for_input" {
#   value = module.opsteam-testecase-01-nobucketpolicy.for_input
# }

# output "finalconfig" {
#   value = module.opsteam-testecase-01-nobucketpolicy.finalconfig
# }



