#
# canonical user id for aws_s3_bucket_acl
#
data "aws_canonical_user_id" "current_user" {}

data "aws_caller_identity" "current_session" {}

# data "aws_canonical_user_id" "current_session" {}
