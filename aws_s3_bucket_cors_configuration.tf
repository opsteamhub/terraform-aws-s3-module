# resource "aws_s3_bucket_cors_configuration" "cors_config" {
#   for_each = { for k, v in local.bucket_config :
#     k => v["cors_rule"] if v["cors_rule"] != []
#   }

#   bucket = each.key

#   dynamic "cors_rule" {
#     for_each = each.value
#     content {
#       allowed_methods = cors_rule.value["allowed_methods"]
#       allowed_origins = cors_rule.value["allowed_origins"]
#       allowed_headers = cors_rule.value["allowed_headers"]
#       expose_headers  = cors_rule.value["expose_headers"]
#       max_age_seconds = cors_rule.value["max_age_seconds"]
#     }
#   }
# }
