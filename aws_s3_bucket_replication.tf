# # # Ref. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration

# resource "aws_iam_role" "replication" {
#   depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

#   for_each = {
#     for key, value in var.config : key => value
#     if value.replication != null
#   }

#   name = "tf-role-replication-${each.value.bucket}"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "s3.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_policy" "replication" {
#   depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

#   for_each = {
#     for key, value in var.config : key => value
#     if value.replication != null
#   }

#   name = "tf-policy-replication-${each.value.bucket}"

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "s3:ListBucket",
#           "s3:GetReplicationConfiguration",
#           "s3:GetObjectVersionForReplication",
#           "s3:GetObjectVersionAcl",
#           "s3:GetObjectVersionTagging",
#           "s3:GetObjectRetention",
#           "s3:GetObjectLegalHold"
#         ]
#         Effect = "Allow"
#         Resource = [
#           "arn:aws:s3:::${each.value.bucket}",
#           "arn:aws:s3:::${each.value.bucket}/*",
#           "arn:aws:s3:::${each.value.replication.rule.destination.bucket}",
#           "arn:aws:s3:::${each.value.replication.rule.destination.bucket}/*"
#         ]
#       },
#       {
#         Action = [
#           "s3:ReplicateObject",
#           "s3:ReplicateDelete",
#           "s3:ReplicateTags",
#           "s3:ObjectOwnerOverrideToBucketOwner"
#         ],
#         Effect : "Allow",
#         Resource = [
#           "arn:aws:s3:::${each.value.bucket}/*",
#           "arn:aws:s3:::${each.value.replication.rule.destination.bucket}",
#           "arn:aws:s3:::${each.value.replication.rule.destination.bucket}/*"
#         ]
#       }
#     ]
#     }
#   )

# }
