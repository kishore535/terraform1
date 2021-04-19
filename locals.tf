locals {
  bucket_name = "${var.globally_unique_prefix}-${var.environment}-${var.bucket_name}"
  is_private  = var.acl != "public"
}
