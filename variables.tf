variable "acl" {
  default     = "private"
  description = "Canned ACL to apply to the new bucket."
  type        = string
}

variable "bucket_name" {
  description = "Name of the bucket, added as a suffix to computed bucket name."
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "expiration_days" {
  default     = 180
  description = "Number of days after which to expunge the objects"
  type        = number
}

variable "glacier_enabled" {
  default     = false
  description = "Determines whether a lifecycle rule is created to automatically convert objects to Glacier storage class."
  type        = bool
}

variable "glacier_transition_days" {
  default     = 90
  description = "Number of days after which to move the data to the glacier storage tier"
  type        = number
}

variable "globally_unique_prefix" {
  description = "Prefix added to bucket name to make it globally unique."
  type        = string
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

variable "policy_name" {
  default     = "bucket-policy"
  description = "Name of the JSON file containing the bucket policy."
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role which has access to put objects in the bucket."
  type        = string
}

variable "sse_algorithm" {
  default     = "AES256"
  description = "The server-side encryption algorithm to use. Valid values are AES256 and aws:kms"
  type        = string
}

variable "versioning_enabled" {
  default     = false
  description = "Determines whether objects are versioned."
  type        = bool
}
