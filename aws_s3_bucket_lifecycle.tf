resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  for_each = { for k, v in local.bucket_config :
    k => v if v["lifecycle_config"]["rule"] != null # se for verdadeiro entra na lista    
  }

  bucket = each.key # Required        

  dynamic "rule" { # Required
    for_each = each.value["lifecycle_config"]["rule"] != null ? each.value["lifecycle_config"]["rule"] : []
    content {

      id = rule.value["id"] # Required

      status = rule.value["status"] # Required

      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value["abort_incomplete_multipart_upload"] != null? tomap({"abort_incomplete_multipart_upload" = rule.value["abort_incomplete_multipart_upload"]}) : {}
        content {
          days_after_initiation = rule.value["abort_incomplete_multipart_upload"]["days_after_initiation"]
        }
      }
      dynamic "expiration"  {
        for_each = rule.value["expiration"] != null? tomap({"expiration" = rule.value["expiration"]}) : {}
      // for_each = toset([rule.value["expiration"]]) // Funciona, mas não é o jeito palmeirense de ser feito
        content {
          date = try(expiration.value["date"],null)
          days = try(expiration.value["days"],null)
          expired_object_delete_marker = try(expiration.value["expired_object_delete_marker"],null)
        }        
      }

      dynamic "filter"  {
        for_each = rule.value["filter"] != null? tomap({"filter" = rule.value["filter"]}) : {}
      // for_each = toset([rule.value["expiration"]]) // Funciona, mas não é o jeito palmeirense de ser feito
        content {
          object_size_greater_than = try(filter.value["object_size_greater_than"],null)
          object_size_less_than = try(filter.value["object_size_less_than"],null)
          prefix = try(filter.value["prefix"],null)
          
          dynamic "tag"  {
          for_each = filter.value["tag"] != null? tomap({"tag" = filter.value["tag"]}) : {}
           content {
            key   = try(tag.value["key"],null)
            value   = try(tag.value["value"],null)
           }
          }          
        }        
      }

      dynamic "noncurrent_version_expiration"  {
        for_each = rule.value["noncurrent_version_expiration"] != null? tomap({"noncurrent_version_expiration" = rule.value["noncurrent_version_expiration"]}) : {}
        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value["date"],null)
          noncurrent_days = try(noncurrent_version_expiration.value["days"],null)
        }        
      }

      dynamic "noncurrent_version_transition"  {
        for_each = rule.value["noncurrent_version_transition"] != null? tomap({"noncurrent_version_transition" = rule.value["noncurrent_version_transition"]}) : {}
        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value["date"],null)
          noncurrent_days = try(noncurrent_version_transition.value["days"],null)
          storage_class = try(noncurrent_version_transition.value["storage_class"],null)
        }        
      }

      dynamic "transition"  {
        for_each = rule.value["transition"] != null? tomap({"transition" = rule.value["transition"]}) : {}
        content {
          date = try(transition.value["date"],null)
          days = try(transition.value["days"],null)
          storage_class = try(transition.value["storage_class"],null)
        }        
      }
    

    }
  }
}


