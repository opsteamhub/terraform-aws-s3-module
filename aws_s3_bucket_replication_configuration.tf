resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.versioning] #   Must have bucket versioning enabled first

  for_each = {
    for key, value in var.config : key => value
    if try(value.replication != null && value.replication.rule != null, false)
  }

  bucket = each.value["bucket_prefix"] == null ? coalesce(each.value["bucket"], each.key) : aws_s3_bucket.bucket[each.key].id

  role = "arn:aws:iam::${data.aws_caller_identity.current_session.account_id}:role/tf-role-replication-${coalesce(each.value["bucket"], each.key)}"

  rule {
    delete_marker_replication { # Terraform documentation page define it as optional, however if you do not set this parameter, you receive an error message (The argument "xxxxx" is required, but no definition was found). Thus, we set as Required. 
      status = try(each.value.replication.rule.delete_marker_replication.status, null)
    }

    destination {

      dynamic "access_control_translation" {
        for_each = try(each.value.replication.rule.destination.access_control_translation, null) != null ? tomap({ "access_control_translation" = each.value.replication.rule.destination.access_control_translation }) : {}
        content {
          owner = try(access_control_translation.value.owner, null)
        }
      }

      account = try(each.value.replication.rule.destination.account, null)

      bucket = "arn:aws:s3:::${each.value.replication.rule.destination.bucket}"

      dynamic "encryption_configuration" {
        for_each = try(each.value.replication.rule.destination.encryption_configuration.replica_kms_key_id, null) != null ? each.value.replication.rule.destination.encryption_configuration : {}
        content {
          replica_kms_key_id = try(encryption_configuration.value["replica_kms_key_id"], null)
        }
      }

      dynamic "metrics" {
        for_each = try(each.value.replication.rule.destination.metrics.status, null) != null ? tomap({ "metrics" = each.value.replication.rule.destination.metrics }) : {}
        content {
          dynamic "event_threshold" {
            for_each = try(metrics.value.event_threshold.minutes, null) != null ? tomap({ "event_threshold" = metrics.value["event_threshold"] }) : {}
            content {
              minutes = try(metrics.value["event_threshold"]["minutes"], null)
            }
          }
          status = try(metrics.value["status"], null)
        }
      }

      dynamic "replication_time" {
        for_each = try(each.value.replication.rule.destination.replication_time.status, null) != null ? tomap({ "replication_time" = each.value.replication.rule.destination.replication_time }) : {}

        content {
          status = try(replication_time.value["status"], null)
          time {
            minutes = try(replication_time.value["time"]["minutes"], null)
          }
        }
      }

      storage_class = try(each.value.replication.rule.destination.storage_class, null)
    }

    dynamic "existing_object_replication" {
      for_each = try(each.value.replication.rule.existing_object_replication, null) != null ? each.value.replication.rule.existing_object_replication : {}
      content {
        status = try(existing_object_replication.value["status"], null)
      }
    }

    dynamic "filter" {
      for_each = try(each.value.replication.rule.filter, null) != null ? tomap({ "filter" = each.value.replication.rule.filter }) : {}

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

    id = try(each.value.replication.rule.id, null)

    priority = try(each.value.replication.rule.priority, null)

    dynamic "source_selection_criteria" {
      for_each = each.value.replication.rule.source_selection_criteria != null ? tomap({ "source_selection_criteria" = each.value["replication"]["rule"]["source_selection_criteria"] }) : {}
      content {
        replica_modifications {
          status = try(each.value.replication.rule.source_selection_criteria.replica_modifications.status, null)
        }
        sse_kms_encrypted_objects {
          status = try(each.value.replication.rule.source_selection_criteria.sse_kms_encrypted_objects.status, null)
        }
      }
    }

    status = try(each.value.replication.rule.status, null)
  }

  token = try(each.value.replication.token, null)
}
