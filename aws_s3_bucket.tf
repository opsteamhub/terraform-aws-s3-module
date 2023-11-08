resource "aws_s3_bucket" "bucket" {
  for_each = zipmap(local.bucket_names, var.bucket_config)
  bucket   = each.value["bucket_name"]
  tags     = each.value["tags"]

}
