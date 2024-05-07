resource "aws_s3_bucket" "bucket" {

  for_each = {
    for key, value in var.config : key => value if coalesce(value.create_bucket, true)
  }

  bucket = coalesce(each.value["bucket"], each.key)

  bucket_prefix = each.value["bucket_prefix"]

  force_destroy = each.value["force_destroy"]

  object_lock_enabled = each.value["object_lock_enabled"]

  tags = each.value["tags"]

}


data "aws_s3_bucket" "bucket" {
  for_each = {
    for key, value in var.config : key => value if !coalesce(value.create_bucket, true)
  }

  bucket = coalesce(each.value["bucket"], each.key)
}

