resource "aws_s3_bucket_metric" "metric" {
  for_each = zipmap(tolist(flatten([for x, y in flatten(values(local.bucket_config)[*]["metric"]) :
    [for z in y :
      z
    ]
    ]))[*]["name"], tolist(flatten([for x, y in flatten(values(local.bucket_config)[*]["metric"]) :
    [for z in y :
      z
    ]
    ]))
  )

  bucket = each.value["bucket_name"]
  name   = each.value["name"]

  dynamic "filter" {
    for_each = each.value["filter"]
    content {
      prefix = filter.value["prefix"]
      tags   = filter.value["tags"]
    }
  }

}