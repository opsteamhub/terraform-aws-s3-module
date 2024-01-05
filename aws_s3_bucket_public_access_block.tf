resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {

  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.public_access_block != null
  }

  bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  block_public_acls = try(each.value.public_access_block.block_public_acls, null)

  block_public_policy = try(each.value.public_access_block.block_public_policy, null)

  ignore_public_acls = try(each.value.public_access_block.ignore_public_acls, null)

  restrict_public_buckets = try(each.value.public_access_block.restrict_public_buckets, null)

}
