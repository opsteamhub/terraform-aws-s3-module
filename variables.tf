variable "bucket_config" {
  type = list(object({
    bucket_name = string
    tags        = optional(map(string))

    acl = optional(object({
      acl = optional(string)
      access_control_policy = optional(object({
        grant = optional(set(object({
          grantee = optional(object({
            email_address = optional(string)
            id            = optional(string)
            type          = optional(string)
            uri           = optional(string)
          }))
          permission = optional(string)
        })))
        owner = optional(object({
          id = optional(string)
        }))
      }))
      expected_bucket_owner = optional(string)
    }))

    bucket_policy = optional(object({
      statement   = optional(set(object({
        sid = optional(string)
        effect     = optional(string)
        actions    = optional(set(string))
        notactions    = optional(set(string))
        principals = optional(set(object({
          type        = optional(string)
          identifiers = optional(set(string))
        })))
        not_principals = optional(set(object({
          type         = optional(string)
          identifiers  = optional(set(string))
        })))
        resources_prefix  = optional(set(string))
      })))
    }))

    bucket_public_access_block = optional(object({
      block_public_acls        = optional(bool)
      block_public_policy      = optional(bool)
      ignore_public_acls       = optional(bool)
      restrict_public_buckets  = optional(bool)
    }))
    

    cors_rule = optional(set(object({
      id              = optional(string)
      allowed_headers = optional(set(string))
      allowed_methods = optional(set(string))
      allowed_origins = optional(set(string))
      expose_headers  = optional(set(string))
      max_age_seconds = optional(string)
    })))

    logging_config   = optional(object({
      expected_bucket_owner = optional(string)
      target_bucket         = optional(string)
      target_prefix         = optional(string)
      target_grant          = optional(object({
        permission = optional(string)
        grantee = optional(object({
          email_address = optional(string)
          id            = optional(string)
          type          = optional(string)
          uri           = optional(string)
        }))
      }))
    }))

    metric = optional(set(object({
      name = optional(string)
      filter = optional(set(object({
        prefix = optional(string)
        tags = optional(map(string))
      })))
    })))
    

    sse_config  = optional(object({
      apply_server_side_encryption_by_default = optional(object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      }))
      bucket_key_enabled  = optional(bool)
    })) 

    versioning_configuration = optional(object({
      status                = optional(string)
      expected_bucket_owner = optional(string)
    }))

    website_config = optional(object({
      error_document = optional(object({
        key = optional(string)
      }))    
      index_document = optional(object({
        suffix = optional(string)
      }))    
      #redirect_all_requests_to
      routing_rule = optional(set(object({
        condition = optional(object({
          http_error_code_returned_equals = optional(string)
          key_prefix_equals               = optional(string)
        }))
        redirect = optional(object({
          host_name               = optional(string)
          http_redirect_code      = optional(string)
          protocol                = optional(string)
          replace_key_prefix_with = optional(string)
          replace_key_with        = optional(string)
        }))
      })))
    }))

  }))
}
