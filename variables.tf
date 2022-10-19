variable "bucket_config" {
  type = list(object({
    bucket_name = string                        # The name of the bucket.
    tags        = optional(map(string))         # A map of tags to assign to the bucket.
    acl = optional(object({                     # Provides an S3 bucket ACL resource.
      acl = optional(string)                    # The canned ACL to apply to the bucket.
      access_control_policy = optional(object({ # A configuration block that sets the ACL permissions for an object.
        grant = optional(set(object({           # Set of grant configuration blocks.
          grantee = optional(object({           # Configuration block for the person being granted permissions.
            email_address = optional(string)    # Email address of the grantee.
            id            = optional(string)    # The canonical user ID of the grantee.
            type          = optional(string)    # Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
            uri           = optional(string)    # URI of the grantee group.
          }))
          permission = optional(string) # Logging permissions assigned to the grantee for the bucket.
        })))
        owner = optional(object({ # Configuration block of the bucket owner's display name and ID.
          id = optional(string)   # The ID of the owner.
        }))
      }))
      expected_bucket_owner = optional(string) # The display name of the owner.
    }))

    bucket_policy = optional(object({         # Attaches a policy to an S3 bucket resource.
      statement = optional(set(object({       # A map of definitions of bucket policy.
        sid        = optional(string)         # Statement ID (Sid) is an identifier for a policy statement.
        effect     = optional(string)         # Whether this statement allows or denies the given actions. Valid values are Allow and Deny. Defaults to Allow.
        actions    = optional(set(string))    # List of actions that this statement either allows or denies. For example, ["ec2:RunInstances", "s3:*"].
        notactions = optional(set(string))    # List of actions that this statement does not apply to. Use to apply a policy statement to all actions except those listed.
        principals = optional(set(object({    # Configuration block for principals.
          type        = optional(string)      # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
          identifiers = optional(set(string)) # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
        })))
        not_principals = optional(set(object({ # Like principals except these are principals that the statement does not apply to.
          type        = optional(string)       # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
          identifiers = optional(set(string))  # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
        })))
        resources_prefix = optional(set(string)) # A string of characters at the beginning of the object key name.
      })))
    }))

    bucket_public_access_block = optional(object({ # Manages S3 bucket-level Public Access Block configuration.
      block_public_acls       = optional(bool)     # Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true causes the following behavior: # PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access. # PUT Object calls will fail if the request includes an object ACL.
      block_public_policy     = optional(bool)     # Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy. When set to true causes Amazon S3 to: # Reject calls to PUT Bucket policy if the specified bucket policy allows public access.
      ignore_public_acls      = optional(bool)     # Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true causes Amazon S3 to: # Ignore public ACLs on this bucket and any objects that it contains.
      restrict_public_buckets = optional(bool)     # Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true: # Only the bucket owner and AWS Services can access this buckets if it has a public policy.
    }))

    cors_rule = optional(set(object({         # Provides an S3 bucket CORS configuration resource. Identify the origins that you will allow to access your bucket, the operations (HTTP methods) that you will support for each origin, and other operation-specific information.
      id              = optional(string)      # Unique identifier for the rule. The value cannot be longer than 255 characters.
      allowed_headers = optional(set(string)) # Set of Headers that are specified in the Access-Control-Request-Headers header.
      allowed_methods = optional(set(string)) # Set of HTTP methods that you allow the origin to execute. Valid values are GET, PUT, HEAD, POST, and DELETE.
      allowed_origins = optional(set(string)) # Set of origins you want customers to be able to access the bucket from.
      expose_headers  = optional(set(string)) # Set of Headers that are specified in the Access-Control-Request-Headers header.
      max_age_seconds = optional(string)      # The time in seconds that your browser is to cache the preflight response for the specified resource.
    })))

    lifecycle_config = optional( # An S3 Lifecycle configuration is a set of rules that define actions that Amazon S3 applies to a group of objects
      object(
        {
          expected_bucket_owner = optional(string) # The account ID of the expected bucket owner. If the bucket is owned by a different account, the request will fail with an HTTP 403 (Access Denied) error.
          rule = optional(                         # List of configuration blocks describing the rules managing the replication
            list(
              object(
                {
                  id     = optional(string)                     # (Required) Unique identifier for the rule. The value cannot be longer than 255 characters.
                  status = optional(string)                     # (Required) Whether the rule is currently being applied. Valid values: Enabled or Disabled.
                  abort_incomplete_multipart_upload = optional( # Configuration block that specifies the days since the initiation of an incomplete multipart upload that Amazon S3 will wait before permanently removing all parts of the upload
                    object(
                      {
                        days_after_initiation = optional(string) # The number of days after which Amazon S3 aborts an incomplete multipart upload.
                      }
                    )
                  )
                  expiration = optional( # Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker 
                    object(
                      {
                        date                         = optional(string) #  The date the object is to be moved or deleted. Should be in RFC3339 format.
                        days                         = optional(string) #  The lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer.
                        expired_object_delete_marker = optional(bool)   # Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired; if set to false the policy takes no action.
                      }
                    )
                  )

                  filter = optional( # Configuration block used to identify objects that a Lifecycle Rule applies 
                    object(
                      {
                        and = optional(
                          object(
                            {
                              object_size_greater_than = optional(string) # Minimum object size (in bytes) to which the rule applies.
                              object_size_less_than    = optional(string) # Maximum object size (in bytes) to which the rule applies.
                              prefix                   = optional(string) # Prefix identifying one or more objects to which the rule applies. Defaults to an empty string ("") if not specified.                                
                              tags = optional(                            # Key-value map of resource tags. All of these tags must exist in the object's tag set in order for the rule to apply.
                                map(string)

                              )
                            }
                          )
                        )
                        object_size_greater_than = optional(string) # Minimum object size (in bytes) to which the rule applies.
                        object_size_less_than    = optional(string) # Maximum object size (in bytes) to which the rule applies.
                        prefix                   = optional(string) # Prefix identifying one or more objects to which the rule applies. Defaults to an empty string ("") if not specified
                        tag = optional(                             # A configuration block for specifying a tag key and value
                          object(
                            {
                              key   = optional(string) # Name of the object key.
                              value = optional(string) # Value of the tag.
                            }
                          )
                        )

                      }
                    )
                  )

                  noncurrent_version_expiration = optional( # Configuration block that specifies when noncurrent object versions expire
                    object(
                      {
                        newer_noncurrent_versions = optional(string) # The number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer.
                        noncurrent_days           = optional(string) # The number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer.
                      }
                    )
                  )
                  noncurrent_version_transition = optional( # Set of configuration blocks that specify the transition rule for the lifecycle rule that describes when noncurrent objects transition to a specific storage class documented below.
                    object(
                      {
                        newer_noncurrent_versions = optional(string) # The number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer.
                        noncurrent_days           = optional(string) # The number of days an object is noncurrent before Amazon S3 can perform the associated action.
                        storage_class             = optional(string) #  The class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR.
                      }
                    )
                  )

                  transition = optional( #  Set of configuration blocks that specify when an Amazon S3 object transitions to a specified storage clas
                    object(
                      {
                        date          = optional(string) # The date objects are transitioned to the specified storage class. The date value must be in RFC3339 format and set to midnight UTC e.g. 2023-01-13T00:00:00Z.
                        days          = optional(string) # The number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer. If both days and date are not specified, defaults to 0. Valid values depend on storage_class, see Transition objects using Amazon S3 Lifecycle for more details.
                        storage_class = optional(string) #  The class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR.
                      }
                    )
                  )
                }
              )
            )
          )
        }
      )
    )

    logging_config = optional(object({         # Provides an S3 bucket (server access) logging resource.
      expected_bucket_owner = optional(string) # The account ID of the expected bucket owner.
      target_bucket         = optional(string) # The name of the bucket where you want Amazon S3 to store server access logs.
      target_prefix         = optional(string) # A prefix for all log object keys.
      target_grant = optional(object({         # Set of configuration blocks with information for granting permissions.
        permission = optional(string)          # Logging permissions assigned to the grantee for the bucket. Valid values: FULL_CONTROL, READ, WRITE.
        grantee = optional(object({            # A configuration block for the person being granted permission.
          email_address = optional(string)     # Email address of the grantee.
          id            = optional(string)     # The canonical user ID of the grantee.
          type          = optional(string)     # Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
          uri           = optional(string)     # URI of the grantee group.
        }))
      }))
    }))

    metric = optional(set(object({     # Provides a S3 bucket metrics configuration resource.
      name = optional(string)          # Unique identifier of the metrics configuration for the bucket. Must be less than or equal to 64 characters in length.
      filter = optional(set(object({   # Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags
        prefix = optional(string)      # Object prefix for filtering (singular).
        tags   = optional(map(string)) # Object tags for filtering (up to 10).
      })))
    })))

    replication = optional( # Replication enables automatic, asynchronous copying of objects across Amazon S3 buckets.
      object(
        {
          different_accounts = optional(bool) # OpsTeam created element, to set if destination is in a different account - options true or false

          region = optional( # OpsTeam created element, to store source and destination regions
            object(
              {
                source      = optional(string)
                destination = optional(string)
              }
            )
          )

          role = optional(string) # role - (Required) The ARN of the IAM role for Amazon S3 to assume when replicating the objects.

          rule = optional( # (Required) List of configuration blocks describing the rules managing the replication.

            object(
              {
                delete_marker_replication = optional( # Whether delete markers are replicated. This argument is only valid with V2 replication configurations (i.e., when filter is used)
                  object(
                    {
                      status = optional(string) # Whether delete markers should be replicated. Either "Enabled" or "Disabled".
                    }
                  )
                )

                destination = optional( # Specifies the destination for the rule
                  object(
                    {

                      access_control_translation = optional( # A configuration block that specifies the overrides to use for object owners on replication. Specify this only in a cross-account scenario (where source and destination bucket owners are not the same), and you want to change replica ownership to the AWS account that owns the destination bucket. If this is not specified in the replication configuration, the replicas are owned by same AWS account that owns the source object. Must be used in conjunction with account owner override configuration.
                        object(
                          {
                            owner = optional(string) # Specifies the replica ownership. For default and valid values, see PUT bucket replication in the Amazon S3 API Reference. 
                          }
                        )
                      )

                      account = optional(string) # The Account ID to specify the replica ownership. Must be used in conjunction with access_control_translation override configuration.

                      bucket = optional(string) # The name of the S3 bucket where you want Amazon S3 to store replicas of the objects identified by the rule.

                      encryption_configuration = optional( #  A configuration block that provides information about encryption. If source_selection_criteria is specified, you must specify this element.
                        object(
                          {
                            replica_kms_key_id = optional(string) # The ID (Key ARN or Alias ARN) of the customer managed AWS KMS key stored in AWS Key Management Service (KMS) for the destination bucket.
                          }
                        )
                      )

                      metrics = optional( # A configuration block that specifies replication metrics-related settings enabling replication metrics and events.
                        object(
                          {
                            event_threshold = optional( # A configuration block that specifies the time threshold for emitting the s3:Replication:OperationMissedThreshold event.
                              object(
                                {
                                  minutes = optional(string) # Time in minutes. Valid values: 15.
                                }
                              )
                            )

                            status = optional(string) # The status of the Destination Metrics. Either "Enabled" or "Disabled".
                          }
                        )
                      )

                      replication_time = optional( # A configuration block that specifies S3 Replication Time Control (S3 RTC), including whether S3 RTC is enabled and the time when all objects and operations on objects must be replicated. Replication Time Control must be used in conjunction with metrics.
                        object(
                          {

                            status = optional(string) # The status of the Replication Time Control. Either "Enabled" or "Disabled".

                            time = optional( #  A configuration block specifying the time by which replication should be complete for all objects and operations on objects
                              object(
                                {
                                  minutes = optional(string) # Time in minutes. Valid values: 15.
                                }
                              )
                            )
                          }
                        )
                      )

                      storage_class = optional(string) # The storage class used to store the object. By default, Amazon S3 uses the storage class of the source object to create the object replica.
                    }
                  )
                )

                existing_object_replication = optional( # Replicate existing objects in the source bucket according to the rule configurations
                  object(
                    {
                      status = optional(string) # Whether the existing objects should be replicated. Either "Enabled" or "Disabled".
                    }
                  )
                )

                filter = optional( # Filter that identifies subset of objects to which the replication rule applies. If not specified, the rule will default to using prefix.
                  object(
                    {

                      prefix = optional(string) #   An object key name prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in lengt

                      tag = optional( # A configuration block for specifying a tag key and value
                        object(
                          {
                            key   = optional(string) # Name of the object key.
                            value = optional(string) # Value of the tag.
                          }
                        )
                      )
                      and = optional( # A configuration block for specifying rule filters. This element is required only if you specify more than one filter.
                        object(
                          {
                            prefix = optional(string) # An object key name prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length.
                            tags = optional(          # (Optional, Required if prefix is configured) A map of tags (key and value pairs) that identifies a subset of objects to which the rule applies. The rule applies only to objects having all the tags in its tagset.
                              list(
                                object(
                                  {
                                    key   = optional(string) # Name of the object key.
                                    value = optional(string) # Value of the tag.
                                  }
                                )
                              )
                            )
                          }
                        )
                      )
                    }
                  )

                )

                id = optional(string) # Unique identifier for the rule. Must be less than or equal to 255 characters in length.

                prefix = optional(string) #  (Optional, Conflicts with filter, Deprecated) Object key name prefix identifying one or more objects to which the rule applies. Must be less than or equal to 1024 characters in length. Defaults to an empty string ("") if filter is not specified.

                priority = optional(string) # The priority associated with the rule. Priority should only be set if filter is configured. If not provided, defaults to 0. Priority must be unique between multiple rules.

                source_selection_criteria = optional( # Specifies special object selection criteria              
                  object(
                    {
                      replica_modifications = optional(
                        object(
                          {
                            status = optional(string)
                          }
                        )
                      )
                      sse_kms_encrypted_objects = optional(
                        object(
                          {
                            status = optional(string)
                          }
                        )
                      )
                    }
                  )
                )
                status = optional(string) # The status of the rule. Either "Enabled" or "Disabled". The rule is ignored if status is not "Enabled".
              }
            )

          )
          token = optional(string) # (Optional) A token to allow replication to be enabled on an Object Lock-enabled bucket. You must contact AWS support for the bucket's "Object Lock token"
        }
      )
    )

    sse_config = optional(object({                                # Provides a S3 bucket server-side encryption configuration resource.
      apply_server_side_encryption_by_default = optional(object({ # A single object for setting server-side encryption by default.
        sse_algorithm     = string                                # The server-side encryption algorithm to use. Valid values are AES256 and aws:kms.
        kms_master_key_id = optional(string)                      # The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.
      }))
      bucket_key_enabled = optional(bool) # Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.
    }))

    versioning_configuration = optional(object({ # Provides a resource for controlling versioning on an S3 bucket. .
      status                = optional(string)   # The versioning state of the bucket. Valid values: Enabled or Suspended.
      expected_bucket_owner = optional(string)   # The account ID of the expected bucket owner.
    }))

    website_config = optional(object({   # Provides an S3 bucket website configuration resource. .
      error_document = optional(object({ # The name of the error document for the website.
        key = optional(string)           # The object key name to use when a 4XX class error occurs.
      }))
      index_document = optional(object({ # The name of the index document for the website.
        suffix = optional(string)        # A suffix that is appended to a request that is for a directory on the website endpoint. For example, if the suffix is index.html and you make a request to samplebucket/images/, the data that is returned will be for the object with the key name images/index.html. The suffix must not be empty and must not include a slash character.
      }))
      #redirect_all_requests_to
      routing_rule = optional(set(object({                   # List of rules that define when a redirect is applied and the redirect behavior.
        condition = optional(object({                        # A configuration block for describing a condition that must be met for the specified redirect to app.
          http_error_code_returned_equals = optional(string) # The HTTP error code when the redirect is applied. If specified with key_prefix_equals, then both must be true for the redirect to be applied.
          key_prefix_equals               = optional(string) # The object key name prefix when the redirect is applied. If specified with http_error_code_returned_equals, then both must be true for the redirect to be applied.
        }))
        redirect = optional(object({                 # A configuration block for redirect information.
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
