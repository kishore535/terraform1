variable "acl" {
  default     = "log-delivery-write"
  description = ""
  type        = string
}

variable "aws_account_id" {
  description = "The account ID for the AWS account in which to add logging."
  type        = string
}

variable "expiration_days" {
  default     = 730
  description = "Number of days after which to expunge the objects"
  type        = number
}

variable "glacier_transition_days" {
  description = "Number of days after which to move the data to the glacier storage tier"
  type        = number
}

variable "lifecycle_prefix" {
  default     = ""
  description = "Prefix filter. Used to manage object lifecycle events."
  type        = string
}

variable "lifecycle_tags" {
  default     = {}
  description = "Tags filter. Used to manage object lifecycle events."
  type        = map(string)
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

variable "noncurrent_version_expiration_days" {
  default     = 90
  description = "Specifies when noncurrent object versions expire."
  type        = number
}

variable "noncurrent_version_transition_days" {
  default     = 30
  description = "Specifies when noncurrent object versions transitions"
  type        = number
}

variable "sse_algorithm" {
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
}

variable "standard_transition_days" {
  default     = 30
  description = "Number of days to persist in the standard storage tier before moving to the infrequent access tier"
  type        = number
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

variable "vpc_id" {
  description = "VPC id"
  type        = string
}
