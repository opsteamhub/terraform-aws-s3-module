resource "aws_s3_bucket_website_configuration" "website_config" {
  for_each = { for k, v in local.bucket_config :
    k => v["website_config"] if v["website_config"] != null
  }

  bucket = each.key

  dynamic "index_document" {
    for_each = each.value["index_document"] != null ? tomap({ "index_document" = each.value["index_document"] }) : {}
    content {
      suffix = index_document.value["suffix"]
    }
  }

  dynamic "error_document" {
    for_each = each.value["error_document"] != null ? tomap({ "error_document" = each.value["error_document"] }) : {}
    content {
      key = error_document.value["key"]
    }
  }

  dynamic "routing_rule" {
    for_each = each.value["routing_rule"] != null ? each.value["routing_rule"] : []

    content {

      dynamic "condition" {
        for_each = routing_rule.value["condition"] != null ? [routing_rule.value["condition"]] : []
        content {
          http_error_code_returned_equals = can(condition.value["http_error_code_returned_equals"]) ? condition.value["http_error_code_returned_equals"] : null
          key_prefix_equals               = can(condition.value["key_prefix_equals"]) ? condition.value["key_prefix_equals"] : null
        }
      }

      dynamic "redirect" {
        for_each = routing_rule.value["redirect"] != null ? [routing_rule.value["redirect"]] : []
        content {
          replace_key_prefix_with = redirect.value["replace_key_prefix_with"]
          host_name               = redirect.value["host_name"]
          http_redirect_code      = redirect.value["http_redirect_code"]
          protocol                = redirect.value["protocol"]
          replace_key_with        = redirect.value["replace_key_with"]
        }
      }

    }
  }

}
