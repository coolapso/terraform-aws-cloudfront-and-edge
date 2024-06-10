resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = var.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_cloudfront.json

}

data "aws_iam_policy_document" "allow_cloudfront" {
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
  name                              = var.cloudfront_origin_name
  description                       = var.cloudfront_origin_description
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name              = var.s3_regional_domain_name
    origin_path              = var.s3_origin_path
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    origin_id                = var.s3_origin_id
  }

  enabled             = var.enable_distribution
  is_ipv6_enabled     = var.enable_ipv6
  default_root_object = var.default_root_object
  aliases             = var.aliases


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = var.forward_query_strings

      cookies {
        forward = var.cookies_forward
      }
    }

    dynamic "function_association" {
      for_each = aws_cloudfront_function.this

      content {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.this[0].arn
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses

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
}

resource "aws_cloudfront_function" "this" {
  count   = var.enable_noindex_function ? 1 : 0
  name    = "noindexhtml"
  runtime = "cloudfront-js-2.0"
  comment = "Serves files under subdirectories without index.html"
  publish = true
  code    = file("${path.module}/lambda/noindex.js")
}
