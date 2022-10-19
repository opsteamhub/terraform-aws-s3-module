locals {
  bucket_names = var.bucket_config[*]["bucket_name"]

  default_bucket_config = {

    acl = {
      acl                   = "private"
      expected_bucket_owner = data.aws_caller_identity.current_session.account_id
    }

    bucket_public_access_block = {
      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }

    cors_rule = {
      allowed_origins = ["*"]
      allowed_methods = ["GET"]
    }

    sse_config = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = "aws/s3"
      }
      bucket_key_enabled = true
    }

    versioning_configuration = {
      status                = "Disabled"
      expected_bucket_owner = data.aws_caller_identity.current_session.account_id
    }

    lifecycle_config = {
      expected_bucket_owner = data.aws_caller_identity.current_session.account_id
    }

    logging_config = {
      expected_bucket_owner = data.aws_caller_identity.current_session.account_id
    }

    website_config = {
      index_document = {
        suffix = "index.html"
      }
      error_document = {
        key = "error.html"
      }
    }

  }

  bucket_config = { for k, v in zipmap(local.bucket_names, var.bucket_config) :
    k => {
      acl = {
        acl                   = try(v["acl"]["access_control_policy"], null) == null ? coalesce(try(v["acl"]["acl"], null), local.default_bucket_config["acl"]["acl"]) : null
        access_control_policy = try(v["acl"]["access_control_policy"], null)
        expected_bucket_owner = coalesce(try(v["acl"]["expected_bucket_owner"], null), local.default_bucket_config["acl"]["expected_bucket_owner"])
      }

      bucket_policy = v["bucket_policy"]

      bucket_public_access_block = {
        block_public_acls       = coalesce(try(v["bucket_public_access_block"]["block_public_acls"], null), local.default_bucket_config["bucket_public_access_block"]["block_public_acls"])
        block_public_policy     = coalesce(try(v["bucket_public_access_block"]["block_public_policy"], null), local.default_bucket_config["bucket_public_access_block"]["block_public_policy"])
        ignore_public_acls      = coalesce(try(v["bucket_public_access_block"]["ignore_public_acls"], null), local.default_bucket_config["bucket_public_access_block"]["ignore_public_acls"])
        restrict_public_buckets = coalesce(try(v["bucket_public_access_block"]["restrict_public_buckets"], null), local.default_bucket_config["bucket_public_access_block"]["restrict_public_buckets"])
      }

      cors_rule = [for item in coalesce(v["cors_rule"], []) :
        {
          id              = item["id"]
          allowed_methods = coalesce(item["allowed_headers"], local.default_bucket_config["cors_rule"]["allowed_methods"])
          allowed_origins = coalesce(item["allowed_origins"], local.default_bucket_config["cors_rule"]["allowed_origins"])
          allowed_headers = item["allowed_headers"]
          expose_headers  = item["expose_headers"]
          max_age_seconds = item["max_age_seconds"]
        }
      ]
      lifecycle_config = {
        expected_bucket_owner = coalesce(try(v["lifecycle_config"]["expected_bucket_owner"], null), local.default_bucket_config["lifecycle_config"]["expected_bucket_owner"])

        rule = [for x in try(v["lifecycle_config"]["rule"], []) :
          {
            id = try(x["id"], null)

            status = try(x["status"], null)

            abort_incomplete_multipart_upload = {
              days_after_initiation = try(x["abort_incomplete_multipart_upload"]["days_after_initiation"], null)
            }

            expiration = {
              date                         = try(x["expiration"]["date"], null)
              days                         = try(x["expiration"]["days"], null)
              expired_object_delete_marker = try(x["expiration"]["expired_object_delete_marker"], null)
            }

            // Mesma lógica aplicada em noncurrent_version_transition, veja o comentário deste
            // Se tem and
            filter = sum([for item in tomap({ "filter" = x["filter"] }) : item != null ? 0 : 1]) > 0 ? null : {

              object_size_greater_than = try(x["filter"]["object_size_greater_than"], null)
              object_size_less_than    = try(x["filter"]["object_size_less_than"], null)
              prefix                   = try(x["filter"]["prefix"], null)
              // Mesma lógica aplicada em noncurrent_version_transition, veja o comentário deste
              tag = sum([for item in tomap({ "tag" = x["filter"]["tag"] }) : item != null ? 0 : 1]) > 0 ? null : {
                key   = try(x["filter"]["tag"]["key"], null)
                value = try(x["filter"]["tag"]["value"], null)
              }

              and = {
                object_size_greater_than = try(x["filter"]["and"]["object_size_greater_than"], null)
                object_size_less_than    = try(x["filter"]["and"]["object_size_less_than"], null)
                prefix                   = try(x["filter"]["and"]["prefix"], null)
                tags                     = try(x["filter"]["and"]["tags"], null)
              }
            }

            noncurrent_version_expiration = {
              newer_noncurrent_versions = try(x["noncurrent_version_expiration"]["newer_noncurrent_versions"], null)
              noncurrent_days           = try(x["noncurrent_version_expiration"]["noncurrent_days"], null)
            }


            # Para garantir que todos somente se houver 1 item não nulo, que esse parametro será definido Se todos forem nulos, o parametro será nulo por inteiro ("noncurrent_version_transition" = null), e não um mapa com elementos nulos dentro ("noncurrent_version_transition" = {"newer_noncurrent_versions" = null,"noncurrent_days"=null, "storage_class"=null  })
            noncurrent_version_transition = sum([for item in tomap({ "noncurrent_version_transition" = x["noncurrent_version_transition"] }) : item != null ? 0 : 1]) > 0 ? null : {
              newer_noncurrent_versions = try(x["noncurrent_version_transition"]["newer_noncurrent_versions"], null)
              noncurrent_days           = try(x["noncurrent_version_transition"]["noncurrent_days"], null)
              storage_class             = try(x["noncurrent_version_transition"]["storage_class"], null)
            }


            // Mesma lógica aplicada em noncurrent_version_transition, veja o comentário deste
            transition = sum([for item in tomap({ "transition" = x["transition"] }) : item != null ? 0 : 1]) > 0 ? null : {

              date          = try(x["transition"]["date"], null)
              days          = try(x["transition"]["days"], null)
              storage_class = try(x["transition"]["storage_class"], null)
            }
          }
        ]
      }

      logging_config = {
        target_bucket         = try(v["logging_config"]["target_bucket"], null)
        target_prefix         = try(v["logging_config"]["target_prefix"], null)
        expected_bucket_owner = coalesce(try(v["logging_config"]["expected_bucket_owner"], null), local.default_bucket_config["logging_config"]["expected_bucket_owner"])
        target_grant = {
          permission = try(v["logging_config"]["target_grant"]["permission"], null)
          grantee = {
            email_address = try(v["logging_config"]["target_grant"]["grantee"]["email_address"], null)
            id            = try(v["logging_config"]["target_grant"]["grantee"]["id"], null)
            type          = try(v["logging_config"]["target_grant"]["grantee"]["type"], null)
            uri           = try(v["logging_config"]["target_grant"]["grantee"]["uri"], null)
          }
        }
      }

      metric = { for x in coalesce(v["metric"], []) :
        format("%s-%s", k, x["name"]) => merge(x, { bucket_name : k })
      }

      // verifica o tamanho do item ["bucket_config"]["replication"], se for maior que 1 (ou seja, se o usuario passo alguma coisa), será processado o conteudo. Se for igual a zero (ou seja, não tem dado nenhum), será definido que replication = null
      replication = sum([for item in tomap({ "replication" = v["replication"] }) : item != null ? 0 : 1]) > 0 ? null : {

        different_accounts = try(v["replication"]["different_accounts"], null)
        region             = try(v["replication"]["region"], null) # Required
        role               = try(v["replication"]["role"], null)   # Required
        //  rule               = try(v["replication"]["rule"], null)

        rule = {
          delete_marker_replication = {
            status = try(v["replication"]["rule"]["delete_marker_replication"]["status"], null)
          }

          destination = {
            access_control_translation = {
              owner = try(v["replication"]["rule"]["destination"]["access_control_translation"]["owner"], null)
            }
            account = try(v["replication"]["rule"]["destination"]["account"], null)

            bucket = try(v["replication"]["rule"]["destination"]["bucket"], null)
            encryption_configuration = {
              replica_kms_key_id = try(v["replication"]["rule"]["destination"]["encryption_configuration"]["replica_kms_key_id"], null)
            }
            metrics = {
              event_threshold = {
                minutes = try(v["replication"]["rule"]["destination"]["metrics"]["event_threshold"]["minutes"], null)
              }
              status = try(v["replication"]["rule"]["destination"]["metrics"]["status"], null)
            }
            replication_time = {
              status = try(v["replication"]["rule"]["destination"]["replication_time"]["status"], null)
              time = {
                minutes = try(v["replication"]["rule"]["destination"]["replication_time"]["time"], null)
              }
            }
            storage_class = try(v["replication"]["rule"]["destination"]["storage_class"], null)
          }

          existing_object_replication = sum([for item in tomap({ "existing_object_replication" = v["replication"]["rule"]["existing_object_replication"] }) : item != null ? 0 : 1]) > 0 ? null : {
            status = try(v["replication"]["rule"]["existing_object_replication"]["status"], null)
          }

          filter = {
            prefix = try(v["replication"]["rule"]["filter"]["prefix"], null)
            tag = sum([for item in tomap({ "tag" = v["replication"]["rule"]["filter"]["tag"] }) : item != null ? 0 : 1]) > 0 ? null : {
              key   = try(v["replication"]["rule"]["filter"]["tag"]["key"], null)
              value = try(v["replication"]["rule"]["filter"]["tag"]["value"], null)
            }
            and = {
              prefix = try(v["replication"]["rule"]["filter"]["and"]["prefix"], null)
              tags   = try(v["replication"]["rule"]["filter"]["and"]["tags"], null)
            }
          }
          id       = try(v["replication"]["rule"]["id"], null)
          prefix   = try(v["replication"]["rule"]["prefix"], null)
          priority = try(v["replication"]["rule"]["priority"], null)

          source_selection_criteria = try(v["replication"]["rule"]["source_selection_criteria"]["replica_modifications"]["status"], null) == null && try(v["replication"]["rule"]["source_selection_criteria"]["sse_kms_encrypted_objects"]["status"], null) == null ? null : {
            replica_modifications = try(v["replication"]["rule"]["source_selection_criteria"]["replica_modifications"]["status"], null) == null ? null : {
              status = v["replication"]["rule"]["source_selection_criteria"]["replica_modifications"]["status"]
            }
            sse_kms_encrypted_objects = try(v["replication"]["rule"]["source_selection_criteria"]["sse_kms_encrypted_objects"]["status"], null) == null ? null : {
              status = v["replication"]["rule"]["source_selection_criteria"]["sse_kms_encrypted_objects"]["status"]
            }
          }
          status = try(v["replication"]["rule"]["status"], null)

        }


        token = try(v["replication"]["token"], null) # Required
      }

      sse_config = {
        apply_server_side_encryption_by_default = {
          sse_algorithm     = try(v["sse_config"]["apply_server_side_encryption_by_default"]["sse_algorithm"], local.default_bucket_config["sse_config"]["apply_server_side_encryption_by_default"]["sse_algorithm"])
          kms_master_key_id = try(v["sse_config"]["apply_server_side_encryption_by_default"]["kms_master_key_id"], local.default_bucket_config["sse_config"]["apply_server_side_encryption_by_default"]["kms_master_key_id"])
        }
        bucket_key_enabled = coalesce(try(v["sse_config"]["bucket_key_enabled"], null), local.default_bucket_config["sse_config"]["bucket_key_enabled"])
      }

      versioning_configuration = {
        status                = coalesce(try(v["versioning_configuration"]["status"], null), local.default_bucket_config["versioning_configuration"]["status"])
        expected_bucket_owner = coalesce(try(v["versioning_configuration"]["expected_bucket_owner"], null), local.default_bucket_config["versioning_configuration"]["expected_bucket_owner"])
      }

      #    website_config = { for a in coalesce([v["website_config"]], []):
      #index_document = { for x,y in tomap({ "suffix" = try(v["website_config"]["index_document"], []) }):
      #index_document = { for x,y in try(v["website_config"]["index_document"],[]):
      #  x => coalesce( try(y["suffix"], null), local.default_bucket_config["website_config"]["index_document"]["suffix"])
      #}
      #     "index_document" => { for x,y in try(a["index_document"],[]):
      #x => merge( try(y["suffix"], null), local.default_bucket_config["website_config"]["index_document"]["suffix"])
      #       "suffix" => merge( try(y["suffix"], null), local.default_bucket_config["website_config"]["index_document"]["suffix"])
      #     }
      #   }

      website_config = v["website_config"]

    }
  }

}

output "inputvar" {
  value = var.bucket_config
}

output "bucketnames" {
  value = local.bucket_names
}

output "for_input" {
  value = zipmap(local.bucket_names, var.bucket_config)
}
/*
output "finalconfig" {
  value = local.bucket_config
}
*/

output "finalconfig" {
  value = local.bucket_config["cb.replication.source"]["replication"]
}
