variable "attach_s3_bucket_policy" {
  description = "attach a policy to s3 bucket to allow this distribution"
  type        = bool
  default     = true
}

variable "s3_bucket_id" {
  description = "Name of s3 bucket"
  type        = string
}

variable "s3_objects" {
  description = "The s3 onjects to allow access to ARN/objects"
  type        = list(any)
}

variable "cloudfront_origin_name" {
  description = "The name of the cloudfront origin"
  type        = string
}

variable "cloudfront_origin_description" {
  description = "Description for the origin"
  type        = string
}

variable "s3_regional_domain_name" {
  description = "The regional domain name of the bucket"
  type        = string
}

variable "s3_origin_id" {
  description = "unique origin id"
  type        = string
  default     = "s3Website"
}

variable "s3_origin_path" {
  description = "objects origin path if using subfolders"
  type        = string
  default     = null
}

variable "enable_distribution" {
  description = "Enables the cf distributuion"
  type        = bool
  default     = true
}

variable "enable_ipv6" {
  description = "Enables ipv6 for the cloudfront distributuion"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "The default website root object"
  type        = string
  default     = null
}

variable "aliases" {
  description = "Alternate domain names"
  type        = list(string)
  default     = null
}

variable "price_class" {
  description = "Price class for this distribution"
  type        = string
  default     = "PriceClass_All"
}

variable "allowed_methods" {
  description = "default cache behavior allowed methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "default cache behavior cached methods"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "set_forwarded_values" {
  description = "enables / disables cache behavior forwarded values"
  type        = bool
  default     = true
}

variable "forward_query_strings" {
  description = "Enables/disables query string forwarding"
  type        = bool
  default     = false
}

variable "cookies_forward" {
  description = "cookies forwarding"
  type        = string
  default     = "none"
}

variable "viewer_protocol_policy" {
  description = "specify the protocol that users can use to access the files in the origin"
  type        = string
  default     = "redirect-to-https"
}

variable "geo_restriction_type" {
  description = "whitelist/blacklist"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "locations to apply restrictions to"
  type        = list(string)
  default     = []
}

variable "min_ttl" {
  description = "Min cache ttl"
  type        = number
  default     = 0
}

variable "default_ttl" {
  description = "Default cache ttl"
  type        = number
  default     = 1800
}

variable "max_ttl" {
  description = "Max cache ttl"
  type        = number
  default     = 3600
}

variable "custom_error_responses" {
  description = "Custom error response definitions"
  type = list(object({
    error_caching_min_ttl = optional(number)
    error_code            = optional(number)
    response_code         = optional(number)
    response_page_path    = optional(string)
  }))
  default = null
}

variable "acm_certificate_arn" {
  description = "ACM Certificate ARN, must be us-east-1"
  type        = string
}

variable "ssl_support_method" {
  description = "SSL support method to be used"
  type        = string
  default     = "sni-only"
}

variable "tls_minimum_protocol_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLSv1.2_2021"
}

variable "enable_noindex_function" {
  description = "Enables lambda@edge function to serve files inside subfolders"
  type        = bool
  default     = false
}
