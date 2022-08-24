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

    sse_config  = optional(object({
      apply_server_side_encryption_by_default = optional(object({
        sse_algorithm     = string
        kms_master_key_id = optional(string)
      }))
      bucket_key_enabled  = optional(bool)
    })) 

  }))
}
