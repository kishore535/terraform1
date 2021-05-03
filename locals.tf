data "aws_elb_service_account" "main" {
}

locals {
  bucket_name = "${var.name_prefix}-${var.name}"
  is_private  = true //var.acl != "public"
}
