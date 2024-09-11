# Define a bucket policy for the destination S3 bucket, specifically for scenarios
# where the source bucket is in a different AWS account.
resource "aws_s3_bucket_policy" "replication_destination_bucket_policy" {
  # Iterate over 'config' variable, selecting entries that meet specific conditions:
  # - Must have a replication configuration.
  # - The replication must involve an external account (identified by role_arn).
  # - A custom bucket policy should not be already specified (i.e., bucket_policy is null).
  # This ensures that this policy is applied only when these conditions are met
  # and a manual bucket policy configuration has not been provided.
  for_each = {
    for key, value in var.config : key => value
    if try(value.replication != null && value.replication.external_account_info.role_arn != null && value.bucket_policy == null, false)
  }

  bucket = each.value["bucket_prefix"] == null ? coalesce(each.value["bucket"], each.key) : null

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid    = "Set-permissions-for-objects",
          Effect = "Allow",
          Principal = {
            AWS = "${each.value.replication.external_account_info.role_arn}"
          },
          Action   = ["s3:ReplicateObject", "s3:ReplicateDelete"],
          Resource = "arn:aws:s3:::${coalesce(each.value["bucket"], each.key)}/*",
        },
        {
          Sid    = "Set-permissions-on-bucket",
          Effect = "Allow",
          Principal = {
            AWS = "${each.value.replication.external_account_info.role_arn}"
          },
          Action = [
            "s3:List*",
            "s3:GetBucketVersioning",
            "s3:PutBucketVersioning"
          ],
          Resource = "arn:aws:s3:::${coalesce(each.value["bucket"], each.key)}",
        }
      ]
    }
  )
}