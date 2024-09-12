resource "aws_s3_bucket_website_configuration" "website_config" {
  depends_on = [aws_s3_bucket.bucket, data.aws_s3_bucket.bucket]

  for_each = {
    for key, value in var.config : key => value
    if value.website_config != null
  }

  bucket = each.value["bucket_prefix"] == null ? coalesce(each.value["bucket"], each.key) : aws_s3_bucket.bucket[each.key].id
  # bucket = coalesce(each.value.create_bucket, true) ? aws_s3_bucket.bucket[each.key].id : data.aws_s3_bucket.bucket[each.key].id

  dynamic "error_document" {
    for_each = each.value.website_config.error_document != null ? tomap({ "error_document" = each.value.website_config.error_document }) : {}
    content {
      key = try(error_document.value.key, null)
    }
  }

  expected_bucket_owner = try(each.value.website_config.expected_bucket_owner, null)

  dynamic "index_document" {
    for_each = each.value.website_config.index_document != null ? tomap({ "index_document" = each.value.website_config.index_document }) : {}
    content {
      suffix = try(index_document.value.suffix, null)
    }
  }

  dynamic "redirect_all_requests_to" {
    for_each = each.value.website_config.redirect_all_requests_to != null ? tomap({ "redirect_all_requests_to" = each.value.website_config.redirect_all_requests_to }) : {}
    content {
      host_name = try(redirect_all_requests_to.value.host_name, null)
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }

  dynamic "routing_rule" {
    for_each = each.value.website_config.routing_rule != null ? tomap({ "routing_rule" = each.value.website_config.routing_rule }) : {}
    content {
      dynamic "condition" {
        for_each = routing_rule.value.condition != null ? tomap({ "condition" = routing_rule.value.condition }) : {}
        content {
          http_error_code_returned_equals = try(condition.value.http_error_code_returned_equals, null)
          key_prefix_equals               = try(condition.value.key_prefix_equals, null)
        }
      }
      dynamic "redirect" {
        for_each = routing_rule.value.redirect != null ? tomap({ "redirect" = routing_rule.value.redirect }) : {}
        content {
          host_name               = try(redirect.value.host_name, null)
          http_redirect_code      = try(redirect.value.http_redirect_code, null)
          protocol                = try(redirect.value.protocol, null)
          replace_key_prefix_with = try(redirect.value.replace_key_prefix_with, null)
          replace_key_with        = try(redirect.value.replace_key_with, null)
        }
      }
    }
  }
}
