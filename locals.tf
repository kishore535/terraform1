data "aws_elb_service_account" "main" {
}

locals {
  bucket_name = "${var.globally_unique_prefix}-${var.environment}-${var.bucket_name}"
  is_private  = true //var.acl != "public"
}
