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
      }
    )
  )
}