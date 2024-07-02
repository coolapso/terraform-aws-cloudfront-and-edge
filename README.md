# Terraform AWS Cloudfront for s3 

Fully written and tested using [OpenTofu](https://github.com/opentofu/opentofu)

Simple AWS Cloudfront to serve static websites from S3.

## Key features

* lambda@edge function if you want to serve content in subfolders without needing to provide the index.html, 
for example: `https://foo.bar/somepage/`
* Custom error reponses


## TODO:

* Add tests

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_cloudfront_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_function) | resource |
| [aws_cloudfront_origin_access_control.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control) | resource |
| [aws_s3_bucket_policy.allow_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_iam_policy_document.allow_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | ACM Certificate ARN, must be us-east-1 | `string` | n/a | yes |
| <a name="input_aliases"></a> [aliases](#input\_aliases) | Alternate domain names | `list(string)` | `null` | no |
| <a name="input_attach_s3_bucket_policy"></a> [attach\_s3\_bucket\_policy](#input\_attach\_s3\_bucket\_policy) | attach a policy to s3 bucket to allow this distribution | `bool` | `true` | no |
| <a name="input_cloudfront_origin_description"></a> [cloudfront\_origin\_description](#input\_cloudfront\_origin\_description) | Description for the origin | `string` | n/a | yes |
| <a name="input_cloudfront_origin_name"></a> [cloudfront\_origin\_name](#input\_cloudfront\_origin\_name) | The name of the cloudfront origin | `string` | n/a | yes |
| <a name="input_cookies_forward"></a> [cookies\_forward](#input\_cookies\_forward) | cookies forwarding | `string` | `"none"` | no |
| <a name="input_custom_error_responses"></a> [custom\_error\_responses](#input\_custom\_error\_responses) | Custom error response definitions | <pre>list(object({<br>    error_caching_min_ttl = optional(number)<br>    error_code            = optional(number)<br>    response_code         = optional(number)<br>    response_page_path    = optional(string)<br>  }))</pre> | `null` | no |
| <a name="input_default_root_object"></a> [default\_root\_object](#input\_default\_root\_object) | The default website root object | `string` | `null` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default cache ttl | `number` | `1800` | no |
| <a name="input_enable_distribution"></a> [enable\_distribution](#input\_enable\_distribution) | Enables the cf distributuion | `bool` | `true` | no |
| <a name="input_enable_ipv6"></a> [enable\_ipv6](#input\_enable\_ipv6) | Enables ipv6 for the cloudfront distributuion | `bool` | `true` | no |
| <a name="input_enable_noindex_function"></a> [enable\_noindex\_function](#input\_enable\_noindex\_function) | Enables lambda@edge function to serve files inside subfolders | `bool` | `false` | no |
| <a name="input_forward_query_strings"></a> [forward\_query\_strings](#input\_forward\_query\_strings) | Enables/disables query string forwarding | `bool` | `false` | no |
| <a name="input_geo_restriction_locations"></a> [geo\_restriction\_locations](#input\_geo\_restriction\_locations) | locations to apply restrictions to | `list(string)` | `[]` | no |
| <a name="input_geo_restriction_type"></a> [geo\_restriction\_type](#input\_geo\_restriction\_type) | whitelist/blacklist | `string` | `"none"` | no |
| <a name="input_max_ttl"></a> [max\_ttl](#input\_max\_ttl) | Max cache ttl | `number` | `3600` | no |
| <a name="input_min_ttl"></a> [min\_ttl](#input\_min\_ttl) | Min cache ttl | `number` | `0` | no |
| <a name="input_price_class"></a> [price\_class](#input\_price\_class) | Price class for this distribution | `string` | `"PriceClass_All"` | no |
| <a name="input_s3_bucket_id"></a> [s3\_bucket\_id](#input\_s3\_bucket\_id) | Name of s3 bucket | `string` | n/a | yes |
| <a name="input_s3_objects"></a> [s3\_objects](#input\_s3\_objects) | The s3 onjects to allow access to ARN/objects | `list(any)` | n/a | yes |
| <a name="input_s3_origin_id"></a> [s3\_origin\_id](#input\_s3\_origin\_id) | unique origin id | `string` | `"s3Website"` | no |
| <a name="input_s3_origin_path"></a> [s3\_origin\_path](#input\_s3\_origin\_path) | objects origin path if using subfolders | `string` | `null` | no |
| <a name="input_s3_regional_domain_name"></a> [s3\_regional\_domain\_name](#input\_s3\_regional\_domain\_name) | The regional domain name of the bucket | `string` | n/a | yes |
| <a name="input_set_forwarded_values"></a> [set\_forwarded\_values](#input\_set\_forwarded\_values) | enables / disables cache behavior forwarded values | `bool` | `true` | no |
| <a name="input_ssl_support_method"></a> [ssl\_support\_method](#input\_ssl\_support\_method) | SSL support method to be used | `string` | `"sni-only"` | no |
| <a name="input_tls_minimum_protocol_version"></a> [tls\_minimum\_protocol\_version](#input\_tls\_minimum\_protocol\_version) | Minimum TLS version | `string` | `"TLSv1.2_2021"` | no |
| <a name="input_viewer_protocol_policy"></a> [viewer\_protocol\_policy](#input\_viewer\_protocol\_policy) | specify the protocol that users can use to access the files in the origin | `string` | `"redirect-to-https"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
