# OpsTeam Terraform Modules: AWS S3

## Overview

This Terraform module is designed to streamline the creation and management of Amazon S3 buckets within our organization and clients. It provides a flexible and efficient way to set up new S3 buckets or modify existing ones across different AWS regions. This module is particularly useful for the OpsTeam, as it encapsulates various S3 configurations in a reusable and standardized format.

## Features

The module supports a wide range of configurations for S3 buckets, including:

- **Bucket Creation:** Ability to create S3 buckets in different AWS regions.
- **Access Control Lists (ACLs):** Define or edit bucket ACLs for fine-grained access control.
- **Cross-Origin Resource Sharing (CORS):** Setup CORS configurations for your buckets.
- **Lifecycle Management:** Automate transitions of objects to different storage classes and manage expirations.
- **Logging:** Configure bucket logging for monitoring and auditing.
- **Metrics:** Setup and manage bucket-level metrics for performance monitoring.
- **Bucket Policies:** Define and edit bucket policies for access management.
- **Public Access:** Manage public access settings for buckets.
- **Versioning:** Enable or configure bucket versioning for object version control.
- **Replication:** Setup replication for buckets within the same or different AWS accounts.
- **Static Website Hosting:** Configure S3 buckets to host static websites.

## Usage

To use this module, define a Terraform configuration that specifies the module source and the desired bucket configurations. Here is an example:

```hcl 
module "opsteam-test-case" {
  # Use this source in CI/CD pipelines to point to the GitHub repository containing the Terraform module.
  source = "git@github.com:opsteamhub/terraform-aws-s3-module.git"

  # For local development and testing scenarios, switch the source to the relative path of the module.
  # source = "../.././"

  config = { # Add the relevant configurations for each bucket.
    bucket01 = { # 'bucket_n' can be replaced with a meaningful identifier for each new bucket.
      # 'bucket': Specifies the name for the first S3 bucket.
      bucket = "opsteam-testecase-a"

      # 'create_bucket': Optional. Set to 'false' to alter an existing bucket. Defaults to 'true' if not specified, creating a new bucket.
      # create_bucket = <true | false>

      # Add further configuration for 'bucket01' below. Configurations may include ACLs, CORS, Lifecycle rules, and other S3 settings.

    },
    bucket02 = {
      # 'bucket': Define another bucket here. Repeat this pattern for additional buckets.
      bucket = "opsteam-testecase-b"

      # Additional settings for 'bucket02' go here, similar to 'bucket01'.

    },
    # ... You can duplicate the bucket configuration block as many times as necessary to manage multiple buckets within the same Terraform configuration.
  }
}
```

## Test Cases

Please refer to the `test` folder in the root directory of this project for practical examples of module usage.

# References:

HashicCorp (2023) Resource: Resource: aws_s3_bucket. Retrieved from: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket. (Accessed: 2023-11-08).
