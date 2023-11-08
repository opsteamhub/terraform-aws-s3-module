# Ref. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration

resource "aws_iam_role" "replication" {
  for_each = { for k, v in local.bucket_config :
    k => v if v["replication"] != null && try(v["replication"]["different_accounts"], false)
  }

  name = "tf-role-replication-${each.key}"

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

resource "aws_iam_policy" "replication" {
  for_each = { for k, v in local.bucket_config :
    k => v if v["replication"] != null && try(v["replication"]["different_accounts"], false)
  }
  name = "tf-policy-replication-${each.key}"

  policy = jsonencode({
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
          "arn:aws:s3:::${each.key}",
          "arn:aws:s3:::${each.key}/*",
          "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}",
          "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}/*"
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
          "arn:aws:s3:::${each.key}/*",
          "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}",
          "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}/*"
        ]
      }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "replication" {
  depends_on = [aws_iam_policy.replication]
  for_each = { for k, v in local.bucket_config :
    k => v if v["replication"] != null && try(v["replication"]["different_accounts"], false)
  }
  role       = "tf-role-replication-${each.key}"
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current_session.account_id}:policy/tf-policy-replication-${each.key}"
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.versioning] #   Must have bucket versioning enabled first
  for_each = { for k, v in local.bucket_config :
    k => v if v["replication"] != null && try(v["replication"]["different_accounts"], false)
  }

  bucket = each.key

  role = "arn:aws:iam::${data.aws_caller_identity.current_session.account_id}:role/tf-role-replication-${each.key}"

  rule {
    delete_marker_replication { # Terraform documentation page define it as optional, however if you do not set this parameter, you receive an error message (The argument "xxxxx" is required, but no definition was found). Thus, we set as Required. 
      status = each.value["replication"]["rule"]["delete_marker_replication"]["status"]
    }

    destination {
      dynamic "access_control_translation" {
        for_each = each.value["replication"]["rule"]["destination"]["access_control_translation"]["owner"] != null ? each.value["replication"]["rule"]["destination"]["access_control_translation"] : {}
        content {
          owner = access_control_translation.value["owner"]
        }
      }

      account = each.value["replication"]["rule"]["destination"]["account"]

      bucket = "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}"

      dynamic "encryption_configuration" {
        for_each = each.value["replication"]["rule"]["destination"]["encryption_configuration"]["replica_kms_key_id"] != null ? each.value["replication"]["rule"]["destination"]["encryption_configuration"] : {}
        content {
          replica_kms_key_id = encryption_configuration.value["replica_kms_key_id"]
        }
      }

      dynamic "metrics" {
        for_each = each.value["replication"]["rule"]["destination"]["metrics"]["status"] != null ? each.value["replication"]["rule"]["destination"]["metrics"] : {}
        content {
          dynamic "event_threshold" {
            for_each = metrics.value["event_threshold"]["minutes"] != null ? tomap({ "event_threshold" = metrics.value["event_threshold"] }) : {}
            content {
              minutes = metrics.value["event_threshold"]["minutes"]
            }
          }
          status = metrics.value["status"]
        }
      }

      dynamic "replication_time" {
        for_each = each.value["replication"]["rule"]["destination"]["replication_time"]["status"] != null ? each.value["replication"]["rule"]["destination"]["replication_time"] : {}
        content {
          status = replication_time.value["status"]
          time {
            minutes = replication_time.value["time"]["minutes"]
          }
        }
      }
      storage_class = each.value["replication"]["rule"]["destination"]["storage_class"]
    }

    dynamic "existing_object_replication" {
      for_each = each.value["replication"]["rule"]["existing_object_replication"] != null ? each.value["replication"]["rule"]["existing_object_replication"] : {}
      content {
        status = existing_object_replication.value["status"]
      }
    }

    dynamic "filter" {
      for_each = each.value["replication"]["rule"]["filter"] != null ? tomap({ "filter" = each.value["replication"]["rule"]["filter"] }) : {}
      content {
        prefix = try(filter.value["prefix"], null)
        dynamic "tag" {
          for_each = filter.value["tag"] != null ? tomap({ "tag" = filter.value["tag"] }) : {}
          content {
            key   = try(filter.value["tag"]["key"], null)
            value = try(filter.value["tag"]["value"], null)
          }
        }
        and {
          prefix = try(filter.value["and"]["prefix"], null)
          tags   = try(filter.value["and"]["tags"], null)
        }
      }
    }

    id = each.value["replication"]["rule"]["id"]

    prefix = each.value["replication"]["rule"]["prefix"]

    priority = each.value["replication"]["rule"]["priority"]

    dynamic "source_selection_criteria" {
      for_each = each.value["replication"]["rule"]["source_selection_criteria"] != null ? tomap({ "source_selection_criteria" = each.value["replication"]["rule"]["source_selection_criteria"] }) : {}
      content {
        replica_modifications {
          status = each.value["replication"]["rule"]["source_selection_criteria"]["replica_modifications"]["status"]
        }
        sse_kms_encrypted_objects {
          status = each.value["replication"]["rule"]["source_selection_criteria"]["sse_kms_encrypted_objects"]["status"]
        }
      }
    }

    status = each.value["replication"]["rule"]["status"]
  }

  token = each.value["replication"]["token"]
}


resource "local_file" "template" { // Create policy to attach in destination Bucket
  for_each = { for k, v in local.bucket_config :
    k => v if v["replication"] != null && try(v["replication"]["different_accounts"], false)
  }
  // && try(v["replication"]["different_accounts"],false)]

  content = templatefile("${path.module}/templates/aws_aim_s3_bucket_policy_replication.tftpl",
    { arn_role_origin_account = "arn:aws:iam::${data.aws_caller_identity.current_session.account_id}:role/tf-role-replication-${each.key}", arn_destination_bucket = "arn:aws:s3:::${each.value["replication"]["rule"]["destination"]["bucket"]}"
  })

  filename = "output/policy-replication-${each.value["replication"]["rule"]["destination"]["bucket"]}.json" //  In destination bucket account: edit source bucket permission to allow the owners of the role created in the previous step write objects in destination bucket.  Navigate through path: Storage → S3→ Buckets→ Open destination Bucket → Permissions → Bucket policy → Attach this policy 
}