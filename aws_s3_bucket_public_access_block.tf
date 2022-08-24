resource "aws_s3_bucket_public_access_block" "public_access_block" {
  for_each = local.bucket_config

  bucket                  = each.key

  block_public_acls       = each.value["bucket_public_access_block"]["block_public_acls"]
  block_public_policy     = each.value["bucket_public_access_block"]["block_public_policy"]
  ignore_public_acls      = each.value["bucket_public_access_block"]["ignore_public_acls"]
  restrict_public_buckets = each.value["bucket_public_access_block"]["restrict_public_buckets"]

}
