resource "aws_s3_bucket_versioning" "versioning" {
  for_each = local.bucket_config

  bucket = each.key

  versioning_configuration {
    status = each.value["versioning_configuration"]["status"]
  }
  expected_bucket_owner = each.value["versioning_configuration"]["expected_bucket_owner"]

}
