variable "region" {
  type        = string
  description = "Region to deploy S3 bucket"
  default     = "us-east-1"
}

variable "config" {
  description = "Define attributes to manage S3 buckets"
  type = map(
    object(
      {
        create_bucket = optional(bool) # If true (default) OpsTeam module will create a new Bucket, if false OpsTeam module will retrive data of the bucket named as "bucket" parameter of  this current object.

        bucket = optional(string) # (Optional, Forces new resource) Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length. A full list of bucket naming rules may be found here. The name must not be in the format [bucket_name]--[azid]--x-s3. Use the aws_s3_directory_bucket resource to manage S3 Express buckets.

        bucket_prefix = optional(string) # (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket. Must be lowercase and less than or equal to 37 characters in length.

        force_destroy = optional(bool) # Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. These objects are not recoverable. This only deletes objects when the bucket is destroyed, not when setting this parameter to true. Once this parameter is set to true, there must be a successful terraform apply run before a destroy is required to update this value in the resource state. Without a successful terraform apply after this parameter is set, this flag will have no effect. If setting this field in the same operation that would require replacing the bucket or destroying the bucket, this flag will not work. Additionally when importing a bucket, a successful terraform apply is required to set this value in state before it will take effect on a destroy operation.

        object_lock_enabled = optional(bool) # (Optional, Forces new resource) Indicates whether this bucket has an Object Lock configuration enabled. Valid values are true or false. This argument is not supported in all regions or partitions.

        tags = optional(map(string)) # Map of tags to assign to the bucket. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level.

        bucket_acl = optional( # Provides an S3 bucket ACL resource.
          object(
            {
              acl = optional(string) # Canned ACL to apply to the bucket.
              access_control_policy = optional(
                object( # Configuration block that sets the ACL permissions for an object per grantee. 
                  {
                    grant = optional( # (Required) Set of grant configuration blocks. See below.
                      object(
                        {
                          grantee = optional( # (Required) Configuration block for the person being granted permissions. See below.
                            object(
                              {
                                email_address = optional(string) #  (Optional) Email address of the grantee. See Regions and Endpoints for supported AWS regions where this argument can be specified.
                                id            = optional(string) #  (Optional) Canonical user ID of the grantee.
                                type          = optional(string) #  (Required) Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
                                uri           = optional(string) #  (Optional) URI of the grantee group.
                              }
                            )
                          )
                          permission = optional(string) # (Required) Logging permissions assigned to the grantee for the bucket.
                        }
                      )
                    )
                    owner = optional( #(Required) Configuration block of the bucket owner's display name and ID. 
                      object(
                        {
                          id           = optional(string) #  (Required) ID of the owner.
                          display_name = optional(string) # (Optional) Display name of the owner.
                        }
                      )
                    )
                  }
                )
              )
              expected_bucket_owner = optional(string) #Account ID of the expected bucket owner.
            }
          )
        )

        bucket_cors = optional( # Provides an S3 bucket CORS configuration resource.
          object(
            {
              expected_bucket_owner = optional(string) #Account ID of the expected bucket owner.
              cors_rule = optional(                    # Set of origins and methods (cross-origin access that you want to allow). See below. You can configure up to 100 rules.
                list(
                  object(
                    {
                      allowed_headers = optional(set(string)) #  (Optional) Set of Headers that are specified in the Access-Control-Request-Headers header.
                      allowed_methods = optional(set(string)) #  (Required) Set of HTTP methods that you allow the origin to execute. Valid values are GET, PUT, HEAD, POST, and DELETE.
                      allowed_origins = optional(set(string)) #  (Required) Set of origins you want customers to be able to access the bucket from.
                      expose_headers  = optional(set(string)) #  (Optional) Set of headers in the response that you want customers to be able to access from their applications (for example, from a JavaScript XMLHttpRequest object).
                      id              = optional(string)      # (Optional) Unique identifier for the rule. The value cannot be longer than 255 characters.
                      max_age_seconds = optional(string)      # (Optional) Time in seconds that your browser is to cache the preflight response for the specified resource.
                    }
                  )
                )
              )
            }
          )
        )

        bucket_lifecycle = optional( # Provides an S3 bucket CORS configuration resource.
          object(
            {
              expected_bucket_owner = optional(string) #Account ID of the expected bucket owner.

              rule = optional( # List of configuration blocks describing the rules managing the replication
                list(
                  object(
                    {
                      abort_incomplete_multipart_upload = optional( # (Optional) Configuration block that specifies the days since the initiation of an incomplete multipart upload that Amazon S3 will wait before permanently removing all parts of the upload. See below.
                        object(
                          {
                            days_after_initiation = optional(string) # Number of days after which Amazon S3 aborts an incomplete multipart upload.
                          }
                        )
                      )

                      expiration = optional( # (Optional) Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker. See below.
                        object(
                          {
                            date                         = optional(string) #  (Optional) Date the object is to be moved or deleted. The date value must be in RFC3339 full-date format e.g. 2023-08-22.
                            day                          = optional(string) # (Optional) Lifetime, in days, of the objects that are subject to the rule. The value must be a non-zero positive integer.
                            expired_object_delete_marker = optional(string) # (Optional, Conflicts with date and days) Indicates whether Amazon S3 will remove a delete marker with no noncurrent versions. If set to true, the delete marker will be expired; if set to false the policy takes no action.
                          }
                        )
                      )

                      filter = optional( # (Optional) Configuration block used to identify objects that a Lifecycle Rule applies to. See below. If not specified, the rule will default to using prefix.
                        object(
                          {
                            and                      = optional(any)         #  (Optional) Configuration block used to apply a logical AND to two or more predicates. See below. The Lifecycle Rule will apply to any object matching all the predicates configured inside the and block.
                            object_size_greater_than = optional(string)      # (Optional) Minimum object size (in bytes) to which the rule applies.
                            object_size_less_than    = optional(string)      # (Optional) Maximum object size (in bytes) to which the rule applies.
                            prefix                   = optional(string)      #  (Optional) Prefix identifying one or more objects to which the rule applies. Defaults to an empty string ("") if not specified.
                            tag                      = optional(map(string)) #  (Optional) Configuration block for specifying a tag key and value
                          }
                        )
                      )

                      id = optional(string) # (Required) Unique identifier for the rule. The value cannot be longer than 255 characters.

                      noncurrent_version_expiration = optional( # (Optional) Configuration block that specifies when noncurrent object versions expire. See below.
                        set(
                          object(
                            {
                              newer_noncurrent_versions = optional(string) # (Optional) Number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer.
                              noncurrent_days           = optional(string) # (Optional) Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer.
                            }
                          )
                        )
                      )

                      noncurrent_version_transition = optional( # (Optional) Set of configuration blocks that specify the transition rule for the lifecycle rule that describes when noncurrent objects transition to a specific storage class. See below.
                        set(
                          object(
                            {
                              newer_noncurrent_versions = optional(string) # (Optional) Number of noncurrent versions Amazon S3 will retain. Must be a non-zero positive integer.
                              noncurrent_days           = optional(string) # (Optional) Number of days an object is noncurrent before Amazon S3 can perform the associated action.
                              storage_class             = optional(string) #(Required) Class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR.
                            }
                          )
                        )
                      )

                      #
                      # DEPRECATED
                      #
                      # prefix = optional(string) # (Optional) DEPRECATED Use filter instead. This has been deprecated by Amazon S3. Prefix identifying one or more objects to which the rule applies. Defaults to an empty string ("") if filter is not specified.

                      status = optional(string) # (Required) Whether the rule is currently being applied. Valid values: Enabled or Disabled.

                      transition = optional( # (Optional) Set of configuration blocks that specify when an Amazon S3 object transitions to a specified storage class. See below.
                        set(
                          object(
                            {
                              date          = optional(string) # (Optional, Conflicts with days) Date objects are transitioned to the specified storage class. The date value must be in RFC3339 full-date format e.g. 2023-08-22.
                              days          = optional(string) # (Optional, Conflicts with date) Number of days after creation when objects are transitioned to the specified storage class. The value must be a positive integer. If both days and date are not specified, defaults to 0. Valid values depend on storage_class, see Transition objects using Amazon S3 Lifecycle for more details.
                              storage_class = optional(string) # Class of storage used to store the object. Valid Values: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR.
                            }
                          )
                        )
                      )
                    }
                  )
                )
              )
            }
          )
        )

        bucket_logging = optional( # Provides an S3 bucket (server access) logging resource. For more information, see Logging requests using server access logging in the AWS S3 User Guide.
          object(
            {
              expected_bucket_owner = optional(string) # (Optional, Forces new resource) Account ID of the expected bucket owner.

              target_bucket = optional(string) # (Required) Name of the bucket where you want Amazon S3 to store server access logs.

              target_prefix = optional(string) # (Required) Prefix for all log object keys.

              target_grant = optional( # (Optional) Set of configuration blocks with information for granting permissions.
                set(
                  object(
                    {
                      grantee = optional( #  (Required) Configuration block for the person being granted permissions.
                        set(
                          object(
                            {
                              email_address = optional(string) # (Optional) Email address of the grantee. See Regions and Endpoints for supported AWS regions where this argument can be specified.
                              id            = optional(string) # (Optional) Canonical user ID of the grantee.
                              type          = optional(string) # (Required) Type of grantee. Valid values: CanonicalUser, AmazonCustomerByEmail, Group.
                              uri           = optional(string) # (Optional) URI of the grantee group.

                            }
                          )
                        )
                      )

                      permission = optional(string) # (Required) Logging permissions assigned to the grantee for the bucket. Valid values: FULL_CONTROL, READ, WRITE.
                    }
                  )
                )
              )

              target_object_key_format = optional( # (Optional) Amazon S3 key format for log objects. See below.
                set(
                  object(
                    {
                      partitioned_prefix = optional( # (Optional) Partitioned S3 key for log objects. See below.
                        set(
                          object(
                            {
                              partition_date_source = optional(string) # (Required) Specifies the partition date source for the partitioned prefix. Valid values: EventTime, DeliveryTime.
                            }
                          )
                        )
                      )
                      simple_prefix = optional(bool) # (Optional) Use the simple format for S3 keys for log objects. To use, set simple_prefix = true
                    }
                  )
                )
              )
            }
          )
        )

        bucket_metric = optional( # Provides a S3 bucket metrics configuration resource
          object(
            {
              name = optional(string) #  (Required) Unique identifier of the metrics configuration for the bucket. Must be less than or equal to 64 characters in length.

              filter = optional( # (Optional) Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags (documented below).
                set(
                  object(
                    {
                      prefix = optional(string)      # (Optional) Object prefix for filtering (singular).
                      tags   = optional(map(string)) # (Optional) Object tags for filtering (up to 10).
                    }
                  )
                )
              )
            }
          )
        )

        bucket_policy = optional( # Attaches a policy to an S3 bucket resource.
          object(
            {
              statement = optional( # A map of definitions of bucket policy.
                set(
                  object(
                    {
                      actions = optional(set(string)) # List of actions that this statement either allows or denies. For example, ["ec2:RunInstances", "s3:*"].

                      condition = optional(
                        set(
                          object(
                            {
                              test     = optional(string) # (Required) Name of the IAM condition operator to evaluate.
                              values   = optional(string) # (Required) Values to evaluate the condition against. If multiple values are provided, the condition matches if at least one of them applies. That is, AWS evaluates multiple values as though using an "OR" boolean operation.
                              variable = optional(string) # (Required) Name of a Context Variable to apply the condition to. Context variables may either be standard AWS variables starting with aws: or service-specific variables prefixed with the service name.
                            }
                          )
                        )
                      )

                      effect = optional(string) # Whether this statement allows or denies the given actions. Valid values are Allow and Deny. Defaults to Allow.

                      not_actions = optional(set(string)) # (Optional) - List of actions that this statement does not apply to. Use to apply a policy statement to all actions except those listed.

                      not_principals = optional(
                        set(
                          object(
                            {                                     # Like principals except these are principals that the statement does not apply to.
                              type        = optional(string)      # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
                              identifiers = optional(set(string)) # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
                            }
                          )
                        )
                      )

                      not_resources = optional(list(string)) # (Optional) - List of resource ARNs that this statement does not apply to. Use to apply a policy statement to all resources except those listed. Conflicts with resources.

                      principals = optional(
                        set(
                          object(
                            {                                     # Configuration block for principals.
                              type        = optional(string)      # Type of principal. Valid values include AWS, Service, Federated, CanonicalUser and *.
                              identifiers = optional(set(string)) # List of identifiers for principals. When type is AWS, these are IAM principal ARNs, e.g., arn:aws:iam::12345678901:role/yak-role. When type is Service, these are AWS Service roles, e.g., lambda.amazonaws.com. When type is Federated, these are web identity users or SAML provider ARNs, e.g., accounts.google.com or arn:aws:iam::12345678901:saml-provider/yak-saml-provider. When type is CanonicalUser, these are canonical user IDs, e.g., 79a59df900b949e55d96a1e698fbacedfd6e09d98eacf8f8d5218e7cd47ef2be.
                            }
                          )
                        )
                      )

                      resources = optional(set(string)) #  (Optional) - List of resource ARNs that this statement applies to. This is required by AWS if used for an IAM policy. Conflicts with not_resources.

                      sid = optional(string) # Statement ID (Sid) is an identifier for a policy statement.
                    }
                  )
                )
              )
            }
          )
        )

        public_access_block = optional( # Manages S3 bucket-level Public Access Block configuration
          object(
            {
              block_public_acls = optional(bool) #  (Optional) Whether Amazon S3 should block public ACLs for this bucket. Defaults to false. Enabling this setting does not affect existing policies or ACLs. When set to true causes the following behavior: PUT Bucket acl and PUT Object acl calls will fail if the specified ACL allows public access. PUT Object calls will fail if the request includes an object ACL.

              block_public_policy = optional(bool) #  (Optional) Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the existing bucket policy. When set to true causes Amazon S3 to: Reject calls to PUT Bucket policy if the specified bucket policy allows public access.

              ignore_public_acls = optional(bool) #  (Optional) Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false. Enabling this setting does not affect the persistence of any existing ACLs and doesn't prevent new public ACLs from being set. When set to true causes Amazon S3 to: Ignore public ACLs on this bucket and any objects that it contains.

              restrict_public_buckets = optional(bool) #  (Optional) Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false. Enabling this setting does not affect the previously stored bucket policy, except that public and cross-account access within the public bucket policy, including non-public delegation to specific accounts, is blocked. When set to true: Only the bucket owner and AWS Services can access this buckets if it has a public policy.
            }
          )
        )

        versioning = optional( # Provides a resource for controlling versioning on an S3 bucket. Deleting this resource will either suspend versioning on the associated S3 bucket or simply remove the resource from Terraform state if the associated S3 bucket is unversioned.
          object(
            {
              versioning_configuration = optional( # (Required) Configuration block for the versioning parameters. See below.
                object(
                  {
                    status     = optional(string) #  (Required) Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets.
                    mfa_delete = optional(string) #  (Optional) Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled.
                  }
                )
              )

              expected_bucket_owner = optional(string) # (Optional, Forces new resource) Account ID of the expected bucket owner.

              mfa = optional(string) # (Optional, Required if versioning_configuration mfa_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device.
            }
          )

        )

        replication = optional( # Provides an independent configuration resource for S3 bucket replication configuration.
          object(
            {
              external_account_info = optional( # OpsTeam specieal object used to provide configuration on destination buckets for different accounts
                object(
                  {
                    role_arn = optional(string) # origin role arn used to replicate objects
                  }
                )
              )

              direction = optional(string) # If Bi-Directional Replication

              destination = optional(string) # (Required) Name of the S3 bucket you want deposit your replication.

              role = optional(string) #  (Required) ARN of the IAM role for Amazon S3 to assume when replicating the objects.

              rule = optional( # (Required) List of configuration blocks describing the rules managing the replication. See below.
                object(
                  {
                    delete_marker_replication = optional( # (Optional) Whether delete markers are replicated. This argument is only valid with V2 replication configurations (i.e., when filter is used)documented below.
                      object(
                        {
                          status = optional(string) # (Required) Whether delete markers should be replicated. Either "Enabled" or "Disabled".
                        }
                      )
                    )

                    destination = optional( #  (Required) Specifies the destination for the rule. See below.
                      object(
                        {
                          access_control_translation = optional( #  (Optional) Configuration block that specifies the overrides to use for object owners on replication. See below. Specify this only in a cross-account scenario (where source and destination bucket owners are not the same), and you want to change replica ownership to the AWS account that owns the destination bucket. If this is not specified in the replication configuration, the replicas are owned by same AWS account that owns the source object. Must be used in conjunction with account owner override configuration.
                            object(
                              {
                                owner = optional(string) # (Required) Specifies the replica ownership. For default and valid values, see PUT bucket replication in the Amazon S3 API Reference. Valid values: Destination.
                              }
                            )
                          )

                          account = optional(string) #  (Optional) Account ID to specify the replica ownership. Must be used in conjunction with access_control_translation override configuration.

                          bucket = optional(string) #  (Required) ARN of the bucket where you want Amazon S3 to store the results.

                          encryption_configuration = optional( #  (Optional) Configuration block that provides information about encryption. See below. If source_selection_criteria is specified, you must specify this element.
                            object(
                              {
                                replica_kms_key_id = optional(string) #  (Required) ID (Key ARN or Alias ARN) of the customer managed AWS KMS key stored in AWS Key Management Service (KMS) for the destination bucket.

                              }
                            )
                          )

                          metrics = optional( #  (Optional) Configuration block that specifies replication metrics-related settings enabling replication metrics and events. See below.
                            object(
                              {
                                event_threshold = optional( #  (Optional) Configuration block that specifies the time threshold for emitting the s3:Replication:OperationMissedThreshold event. See below.
                                  object(
                                    {
                                      minutes = optional(string) # (Required) Time in minutes. Valid values: 15.
                                    }
                                  )
                                )
                                status = optional(string) #  (Required) Status of the Destination Metrics. Either "Enabled" or "Disabled".

                              }
                            )
                          )

                          replication_time = optional( #  (Optional) Configuration block that specifies S3 Replication Time Control (S3 RTC), including whether S3 RTC is enabled and the time when all objects and operations on objects must be replicated. See below. Replication Time Control must be used in conjunction with metrics.
                            object(
                              {
                                status = optional(string) # (Required) Status of the Replication Time Control. Either "Enabled" or "Disabled".

                                time = optional( # (Required) Configuration block specifying the time by which replication should be complete for all objects and operations on objects.
                                  object(
                                    {
                                      minutes = optional(string) # (Required) Time in minutes. Valid values: 15.
                                    }
                                  )
                                )
                              }
                            )
                          )

                          storage_class = optional(string) #  (Optional) The storage class used to store the object. By default, Amazon S3 uses the storage class of the source object to create the object replica.

                        }
                      )
                    )

                    existing_object_replication = optional( #  (Optional) Replicate existing objects in the source bucket according to the rule configurations. See below.
                      object(
                        {
                          status = optional(string) # (Required) Whether the existing objects should be replicated. Either "Enabled" or "Disabled".
                        }
                      )
                    )

                    filter = optional( #  (Optional, Conflicts with prefix) Filter that identifies subset of objects to which the replication rule applies. See below. If not specified, the rule will default to using prefix.
                      object(
                        {
                          and = optional( #  (Optional) Configuration block for specifying rule filters. This element is required only if you specify more than one filter. See and below for more details.
                            object(
                              {
                                prefix = optional(string) #  (Optional) Object key name prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length.

                                tags = optional( #  (Optional, Required if prefix is configured) Map of tags (key and value pairs) that identifies a subset of objects to which the rule applies. The rule applies only to objects having all the tags in its tagset.
                                  object(
                                    {
                                      key = optional(string) #  (Required) Name of the object key.

                                      value = optional(string) #  (Required) Value of the tag.
                                    }
                                  )
                                )
                              }
                            )
                          )

                          prefix = optional(string) #  (Optional) Object key name prefix that identifies subset of objects to which the rule applies. Must be less than or equal to 1024 characters in length.

                          tag = optional(string) # (Optional) Configuration block for specifying a tag key and value.
                        }
                      )
                    , null)

                    id = optional(string) # (Optional) Unique identifier for the rule. Must be less than or equal to 255 characters in length.

                    prefix = optional(string) #  (Optional, Conflicts with filter, Deprecated) Object key name prefix identifying one or more objects to which the rule applies. Must be less than or equal to 1024 characters in length. Defaults to an empty string ("") if filter is not specified.

                    priority = optional(string) #  (Optional) Priority associated with the rule. Priority should only be set if filter is configured. If not provided, defaults to 0. Priority must be unique between multiple rules.

                    source_selection_criteria = optional( #  (Optional) Specifies special object selection criteria. 
                      object(
                        {
                          replica_modifications = optional( # (Optional) Configuration block that you can specify for selections for modifications on replicas. Amazon S3 doesn't replicate replica modifications by default. In the latest version of replication configuration (when filter is specified), you can specify this element and set the status to Enabled to replicate modifications on replicas.
                            object(
                              {

                                status = optional(string) # (Required) Whether the existing objects should be replicated. Either "Enabled" or "Disabled".
                              }
                            )
                          )

                          sse_kms_encrypted_objects = optional( # (Optional) Configuration block for filter information for the selection of Amazon S3 objects encrypted with AWS KMS. If specified, replica_kms_key_id in destination encryption_configuration must be specified as well.
                            object(
                              {
                                status = optional(string) # (Required) Whether the existing objects should be replicated. Either "Enabled" or "Disabled".
                              }
                            )
                          )
                        }
                      )
                    )

                    status = optional(string) #  (Required) Status of the rule. Either "Enabled" or "Disabled". The rule is ignored if status is not "Enabled".
                  }
                )
              )

              token = optional(string) #  (Optional) Token to allow replication to be enabled on an Object Lock-enabled bucket. You must contact AWS support for the bucket's "Object Lock token". For more details, see Using S3 Object Lock with replication.

            }
          )
        )

        sse_config = optional( # Provides a S3 bucket server-side encryption configuration resource.
          object(
            {
              expected_bucket_owner = optional(string) # (Optional, Forces new resource) Account ID of the expected bucket owner.

              rule = optional( # Set of server-side encryption configuration rules. See below. Currently, only a single rule is supported.
                object(
                  {
                    apply_server_side_encryption_by_default = optional( # (Optional) Single object for setting server-side encryption by default. See below.
                      object(
                        {
                          sse_algorithm     = optional(string) #  (Required) Server-side encryption algorithm to use. Valid values are AES256, aws:kms, and aws:kms:dsse
                          kms_master_key_id = optional(string) # (Optional) AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms.
                        }
                      )
                    )

                    bucket_key_enabled = optional(string) # (Optional) Whether or not to use Amazon S3 Bucket Keys for SSE-KMS.

                  }
                )
              )

            }

          )
        )

      }
    )
  )
}