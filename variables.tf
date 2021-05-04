variable "acl" {
  default     = "log-delivery-write"
  description = ""
  type        = string
}

variable "allow_alb_logging" {
  default     = false
  description = ""
  type        = bool
}

variable "allow_cloudfront_logging" {
  default     = false
  description = ""
  type        = bool
}

variable "allow_vpc_flow_logging" {
  default     = false
  description = ""
  type        = bool
}

variable "aws_account_id" {
  description = "The account ID for the AWS account in which to add logging."
  type        = string
}

variable "force_delete" {
  default     = true
  description = ""
  type        = bool
}

variable "lifecycle_rules" {
  default = [{
    enabled = false
    prefix  = ""
    tags    = {}

    enable_glacier_transition        = true
    enable_deeparchive_transition    = false
    enable_standard_ia_transition    = false
    enable_current_object_expiration = true

    abort_incomplete_multipart_upload_days         = 90
    noncurrent_version_glacier_transition_days     = 30
    noncurrent_version_deeparchive_transition_days = 60
    noncurrent_version_expiration_days             = 90

    standard_transition_days    = 30
    glacier_transition_days     = 60
    deeparchive_transition_days = 90
    expiration_days             = 730
  }]
  description = "A list of lifecycle rules"
  type = list(object({
    prefix  = string
    enabled = bool
    tags    = map(string)

    enable_glacier_transition        = bool
    enable_deeparchive_transition    = bool
    enable_standard_ia_transition    = bool
    enable_current_object_expiration = bool

    abort_incomplete_multipart_upload_days         = number
    noncurrent_version_glacier_transition_days     = number
    noncurrent_version_deeparchive_transition_days = number
    noncurrent_version_expiration_days             = number

    standard_transition_days    = number
    glacier_transition_days     = number
    deeparchive_transition_days = number
    expiration_days             = number
  }))
}

variable "logging" {
  type = object({
    bucket_name = string
    prefix      = string
  })
  default     = null
  description = "Bucket access logging configuration."
}

variable "kms_master_key_id" {
  default     = ""
  description = "The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms"
  type        = string
}

variable "name" {
  description = ""
  type        = string
}

variable "name_prefix" {
  description = "Prefix added to bucket name."
  type        = string
}

variable "sse_algorithm" {
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
}

variable "tags" {
  description = ""
  type        = map(string)
}

variable "versioning_enabled" {
  default     = false
  description = ""
  type        = bool
}
