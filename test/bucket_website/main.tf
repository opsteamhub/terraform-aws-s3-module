module "opsteam-testecase-01-websiteconfig" {
  source = ".././"
  bucket_config = [
    { 
      bucket_name = "opsteam-testecase-001-nowebsiteconfig" 
    },
    { 
      bucket_name = "opsteam-testecase-001-websiteconfig"
      website_config = {
        index_document = {
          suffix = "index.html"
        }
      }
    },
    { 
      bucket_name = "opsteam-testecase-002-websiteconfig"
      website_config = {
        index_document = {
          suffix = "index.html"
        }
        error_document = {
          key = "error.html"
        }
      }
    },
    { 
      bucket_name = "opsteam-testecase-003-websiteconfig"
      website_config = {
        index_document = {
          suffix = "index.html"
        }
        routing_rule = [{
          condition = {
            key_prefix_equals = "docs/"
          }
          redirect = {
            replace_key_prefix_with = "documents/"
          }
        }]
      }
    },
  ]
}



output "inputvar" {
  value = module.opsteam-testecase-01-websiteconfig.inputvar
}

output "bucketnames" {
  value = module.opsteam-testecase-01-websiteconfig.bucketnames
}

output "for_input" {
  value = module.opsteam-testecase-01-websiteconfig.for_input
}

output "finalconfig" {
value = module.opsteam-testecase-01-websiteconfig.finalconfig
}

