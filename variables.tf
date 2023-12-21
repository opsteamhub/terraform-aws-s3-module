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

      }
    )
  )
}