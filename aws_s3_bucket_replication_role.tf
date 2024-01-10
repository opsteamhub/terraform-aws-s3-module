resource "aws_iam_policy" "replication" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if try(value.replication != null && value.replication.is_source == true, false)
  }

  name = "tf-policy-replication-${each.value.bucket}"

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "s3:ListBucket",
            "s3:GetReplicationConfiguration",
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging",
            "s3:GetObjectRetention",
            "s3:GetObjectLegalHold"
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:s3:::${each.value.bucket}",
            "arn:aws:s3:::${each.value.bucket}/*",
            "arn:aws:s3:::${each.value.replication.rule.destination.bucket}",
            "arn:aws:s3:::${each.value.replication.rule.destination.bucket}/*"
          ]
        },
        {
          Action = [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags",
            "s3:ObjectOwnerOverrideToBucketOwner"
          ],
          Effect : "Allow",
          Resource = [
            "arn:aws:s3:::${each.value.bucket}/*",
            "arn:aws:s3:::${each.value.replication.rule.destination.bucket}/*"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_role" "replication" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if try(value.replication != null && value.replication.is_source == true, false)
  }

  name = "tf-role-replication-${each.value.bucket}"

  description = "This policy is designed to ensure the IAM role can access and perform replication tasks between the specified buckets efficiently and securely."

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  for_each   = aws_iam_role.replication
  role       = each.value.name
  policy_arn = aws_iam_policy.replication[each.key].arn
}

