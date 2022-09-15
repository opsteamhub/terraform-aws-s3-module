variable "bucket_config" {
  type = list(object({
    bucket_name = string # The name of the bucket.
    tags        = optional(map(string)) # A map of tags to assign to the bucket.
    acl = optional(object({ # Provides an S3 bucket ACL resource.
      acl = optional(string) # The canned ACL to apply to the bucket.
      access_control_policy = optional(object({ # A configuration block that sets the ACL permissions for an object.
        grant = optional(set(object({ # Set of grant configuration blocks.
          grantee = optional(object({ # Configuration block for the person being granted permissions.
            email_address = optional(string) # Email address of the grantee.
            id            = optional(string) # The canonical user ID of the grantee.
            type          = optional(string) # Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
            uri           = optional(string) # URI of the grantee group.
          }))
          permission = optional(string) # Logging permissions assigned to the grantee for the bucket.
        })))
        owner = optional(object({ # Configuration block of the bucket owner's display name and ID.
          id = optional(string) # The ID of the owner.
        }))
      }))
      expected_bucket_owner = optional(string) # The display name of the owner.
    }))

    bucket_policy = optional(object({ # Attaches a policy to an S3 bucket resource.
      statement   = optional(set(object({ # A map of definitions of bucket policy.
        sid = optional(string) # Statement ID (Sid) is an identifier for a policy statement.
        effect     = optional(string) # Whether this statement allows or denies the given actions. Valid values are Allow and Deny. Defaults to Allow.
        actions    = optional(set(string)) # List of actions that this statement either allows or denies. For example, ["ec2:RunInstances", "s3:*"].
        notactions    = optional(set(string)) # List of actions that this statement does not apply to. Use to apply a policy statement to all actions except those listed.
        principals = optional(set(object({ # Configuration block for principals.
          type        = optional(string) # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
          identifiers = optional(set(string)) # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
        })))
        not_principals = optional(set(object({ # Like principals except these are principals that the statement does not apply to.
          type         = optional(string) # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
          identifiers  = optional(set(string)) # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.

        })))
        resources_prefix  = optional(set(string)) # A string of characters at the beginning of the object key name.
      })))
    }))

    bucket_public_access_block = optional(object({ # Manages S3 bucket-level Public Access Block configuration.
      block_public_acls        = optional(bool) # Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true causes the following behavior: # PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access. # PUT Object calls will fail if the request includes an object ACL.
      block_public_policy      = optional(bool) # Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy. When set to true causes Amazon S3 to: # Reject calls to PUT Bucket policy if the specified bucket policy allows public access.
      ignore_public_acls       = optional(bool) # Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true causes Amazon S3 to: # Ignore public ACLs on this bucket and any objects that it contains.
      restrict_public_buckets  = optional(bool) # Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true: # Only the bucket owner and AWS Services can access this buckets if it has a public policy.
    }))
    
    cors_rule = optional(set(object({ # Provides an S3 bucket CORS configuration resource. Identify the origins that you will allow to access your bucket, the operations (HTTP methods) that you will support for each origin, and other operation-specific information.
      id              = optional(string) # Unique identifier for the rule. The value cannot be longer than 255 characters.
      allowed_headers = optional(set(string)) # Set of Headers that are specified in the Access-Control-Request-Headers header.
      allowed_methods = optional(set(string)) # Set of HTTP methods that you allow the origin to execute. Valid values are GET, PUT, HEAD, POST, and DELETE.
      allowed_origins = optional(set(string)) # Set of origins you want customers to be able to access the bucket from.
      expose_headers  = optional(set(string)) # Set of Headers that are specified in the Access-Control-Request-Headers header.
      max_age_seconds = optional(string) # The time in seconds that your browser is to cache the preflight response for the specified resource.
    })))

    logging_config   = optional(object({ # Provides an S3 bucket (server access) logging resource.
      expected_bucket_owner = optional(string) # The account ID of the expected bucket owner.
      target_bucket         = optional(string) # The name of the bucket where you want Amazon S3 to store server access logs.
      target_prefix         = optional(string) # A prefix for all log object keys.
      target_grant          = optional(object({ # Set of configuration blocks with information for granting permissions.
        permission = optional(string) # Logging permissions assigned to the grantee for the bucket. Valid values: FULL_CONTROL, READ, WRITE.
        grantee = optional(object({ # A configuration block for the person being granted permission.
          email_address = optional(string) # Email address of the grantee.
          id            = optional(string) # The canonical user ID of the grantee.
          type          = optional(string) # Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
          uri           = optional(string) # URI of the grantee group.
        }))
      }))
    }))

    metric = optional(set(object({ # Provides a S3 bucket metrics configuration resource.
      name = optional(string) # Unique identifier of the metrics configuration for the bucket. Must be less than or equal to 64 characters in length.
      filter = optional(set(object({ # Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags
        prefix = optional(string) # Object prefix for filtering (singular).
        tags = optional(map(string)) # Object tags for filtering (up to 10).
      })))
    })))
    

    sse_config  = optional(object({ # Provides a S3 bucket server-side encryption configuration resource.
      apply_server_side_encryption_by_default = optional(object({ # A single object for setting server-side encryption by default.
        sse_algorithm     = string # The server-side encryption algorithm to use. Valid values are AES256 and aws:kms.
        kms_master_key_id = optional(string) # The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.
      }))
      bucket_key_enabled  = optional(bool) # Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.
    })) 

    versioning_configuration = optional(object({ # Provides a resource for controlling versioning on an S3 bucket. .
      status                = optional(string) # The versioning state of the bucket. Valid values: Enabled or Suspended.
      expected_bucket_owner = optional(string) # The account ID of the expected bucket owner.
    }))

    website_config = optional(object({ # Provides an S3 bucket website configuration resource. .
      error_document = optional(object({ # The name of the error document for the website.
        key = optional(string) # The object key name to use when a 4XX class error occurs.
      }))    
      index_document = optional(object({ # The name of the index document for the website.
        suffix = optional(string) # A suffix that is appended to a request that is for a directory on the website endpoint. For example, if the suffix is index.html and you make a request to samplebucket/images/, the data that is returned will be for the object with the key name images/index.html. The suffix must not be empty and must not include a slash character.
      }))    
      #redirect_all_requests_to
      routing_rule = optional(set(object({ # List of rules that define when a redirect is applied and the redirect behavior.
        condition = optional(object({ # A configuration block for describing a condition that must be met for the specified redirect to app.
          http_error_code_returned_equals = optional(string) # The HTTP error code when the redirect is applied. If specified with key_prefix_equals, then both must be true for the redirect to be applied.
          key_prefix_equals               = optional(string) # The object key name prefix when the redirect is applied. If specified with http_error_code_returned_equals, then both must be true for the redirect to be applied.
        }))
        redirect = optional(object({ # A configuration block for redirect information.
          host_name               = optional(string) # The host name to use in the redirect request.
          http_redirect_code      = optional(string) # The HTTP redirect code to use on the response.
          protocol                = optional(string) # Protocol to use when redirecting requests. The default is the protocol that is used in the original request. Valid values: http, https.
          replace_key_prefix_with = optional(string) # The object key prefix to use in the redirect request. For example, to redirect requests for all pages with prefix docs/ (objects in the docs/ folder) to documents/, you can set a condition block with key_prefix_equals set to docs/ and in the redirect set replace_key_prefix_with to /documents.
          replace_key_with        = optional(string) # The specific object key to use in the redirect request. For example, redirect request to error.html.
        }))
      })))
    }))

  }))
}
