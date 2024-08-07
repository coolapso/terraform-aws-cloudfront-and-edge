resource "aws_s3_bucket_policy" "allow_cloudfront" {
  count = var.attach_s3_bucket_policy ? 1 : 0

  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_cloudfront[0].json
}

data "aws_iam_policy_document" "allow_cloudfront" {
  count = var.attach_s3_bucket_policy ? 1 : 0

  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = var.s3_objects

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.this.arn]
    }

  }
}

resource "aws_cloudfront_origin_access_control" "this" {
  count = var.enable_cloudfront_origin_access_control ? 1 : 0

  name                              = var.cloudfront_origin_name
  description                       = var.cloudfront_origin_description
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

data "aws_cloudfront_cache_policy" "managed" {
  count = var.managed_cache_policy_name == null && var.custom_cache_policy != true ? 0 : 1

  name = var.managed_cache_policy_name
}

resource "aws_cloudfront_cache_policy" "this" {
  count = var.custom_cache_policy == true && var.managed_cache_policy_name == null ? 1 : 0

  name        = var.cache_policy_name
  comment     = var.cache_policy_comment
  default_ttl = var.default_ttl
  max_ttl     = var.max_ttl
  min_ttl     = var.min_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = var.cookies_forwarding_behavior
    }

    headers_config {
      header_behavior = var.headers_forwarding_behavior
    }


    query_strings_config {
      query_string_behavior = var.query_string_forwarding_behavior
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = var.s3_regional_domain_name
    origin_path              = var.s3_origin_path
    origin_access_control_id = var.enable_cloudfront_origin_access_control ? aws_cloudfront_origin_access_control.this[0].id : null
    origin_id                = var.s3_origin_id

    dynamic "s3_origin_config" {
      for_each = var.origin_access_identity != null ? { "key" = 1 } : {}

      content {
        origin_access_identity = var.origin_access_identity
      }
    }
  }

  enabled             = var.enable_distribution
  is_ipv6_enabled     = var.enable_ipv6
  default_root_object = var.default_root_object
  aliases             = var.aliases
  price_class         = var.price_class


  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = var.s3_origin_id
    cache_policy_id  = local.cache_policy

    dynamic "function_association" {
      for_each = var.enable_noindex_function ? { "key" = 1 } : {}

      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.this[0].arn
      }
    }

    dynamic "function_association" {
      for_each = var.custom_edge_function_associations

      content {
        event_type   = function_association.value.event_type
        function_arn = function_association.value.function_arn
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses != null ? var.custom_error_responses : []

    content {
      error_caching_min_ttl = var.custom_error_responses[custom_error_response.key].error_caching_min_ttl
      error_code            = var.custom_error_responses[custom_error_response.key].error_code
      response_code         = var.custom_error_responses[custom_error_response.key].response_code
      response_page_path    = var.custom_error_responses[custom_error_response.key].response_page_path
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.tls_minimum_protocol_version
  }

  # depends_on = [ aws_cloudfront_function.this[0] ] 
}

resource "aws_cloudfront_function" "this" {
  count = var.enable_noindex_function ? 1 : 0

  name    = "noindexhtml"
  runtime = "cloudfront-js-2.0"
  comment = "Serves files under subdirectories without index.html"
  publish = true
  code    = file("${path.module}/lambda/noindex.js")
}
