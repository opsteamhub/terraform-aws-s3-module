# resource "aws_s3_bucket_ownership_controls" "ownership_control" {
#   for_each = local.bucket_config
#   bucket   = each.key
#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }