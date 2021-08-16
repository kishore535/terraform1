## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_elb_service_account.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | n/a | `string` | `"log-delivery-write"` | no |
| <a name="input_allow_alb_logging"></a> [allow\_alb\_logging](#input\_allow\_alb\_logging) | n/a | `bool` | `false` | no |
| <a name="input_allow_cloudfront_logging"></a> [allow\_cloudfront\_logging](#input\_allow\_cloudfront\_logging) | n/a | `bool` | `false` | no |
| <a name="input_allow_knoxville_logging"></a> [allow\_knoxville\_logging](#input\_allow\_knoxville\_logging) | n/a | `bool` | `true` | no |
| <a name="input_allow_vpc_flow_logging"></a> [allow\_vpc\_flow\_logging](#input\_allow\_vpc\_flow\_logging) | n/a | `bool` | `false` | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The account ID for the AWS account in which to add logging. | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | n/a | `bool` | `true` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms | `string` | `""` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | A list of lifecycle rules | <pre>list(object({<br>    enabled = bool<br>    prefix  = string<br>    tags    = map(string)<br><br>    enable_current_object_expiration = bool<br>    enable_deeparchive_transition    = bool<br>    enable_glacier_transition        = bool<br>    enable_standard_ia_transition    = bool<br><br>    abort_incomplete_multipart_upload_days         = number<br>    noncurrent_version_deeparchive_transition_days = number<br>    noncurrent_version_expiration_days             = number<br>    noncurrent_version_glacier_transition_days     = number<br><br>    deeparchive_transition_days = number<br>    expiration_days             = number<br>    glacier_transition_days     = number<br>    standard_transition_days    = number<br>  }))</pre> | <pre>[<br>  {<br>    "abort_incomplete_multipart_upload_days": 90,<br>    "deeparchive_transition_days": 90,<br>    "enable_current_object_expiration": true,<br>    "enable_deeparchive_transition": false,<br>    "enable_glacier_transition": true,<br>    "enable_standard_ia_transition": false,<br>    "enabled": false,<br>    "expiration_days": 730,<br>    "glacier_transition_days": 60,<br>    "noncurrent_version_deeparchive_transition_days": 60,<br>    "noncurrent_version_expiration_days": 90,<br>    "noncurrent_version_glacier_transition_days": 30,<br>    "prefix": "",<br>    "standard_transition_days": 30,<br>    "tags": {}<br>  }<br>]</pre> | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Bucket access logging configuration. | <pre>object({<br>    bucket_name = string<br>    prefix      = string<br>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix added to bucket name. | `string` | n/a | yes |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use. Valid values are AES256 and aws:kms | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_versioning_enabled"></a> [versioning\_enabled](#input\_versioning\_enabled) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The bucket domain name of the S3 bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The ID of the S3 bucket. |
| <a name="output_bucket_name"></a> [bucket\_name](#output\_bucket\_name) | The computed name of the S3 bucket. |
