###################################################################
# S3 BUCKET
###################################################################

resource "aws_s3_bucket" "main" {
  acl           = var.acl
  bucket        = local.bucket_name
  force_destroy = var.force_delete

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules

    content {
      enabled = lifecycle_rule.value.enabled
      //id      = "${var.name_prefix}-lifecycle-rule"
      prefix                                 = lifecycle_rule.value.prefix
      tags                                   = lifecycle_rule.value.tags
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      noncurrent_version_expiration {
        days = lifecycle_rule.value.noncurrent_version_expiration_days
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.enable_glacier_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.noncurrent_version_glacier_transition_days
          storage_class = "GLACIER"
        }
      }

      dynamic "noncurrent_version_transition" {
        for_each = lifecycle_rule.value.enable_deeparchive_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.noncurrent_version_deeparchive_transition_days
          storage_class = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_glacier_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.glacier_transition_days
          storage_class = "GLACIER"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_deeparchive_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.deeparchive_transition_days
          storage_class = "DEEP_ARCHIVE"
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.enable_standard_ia_transition ? [1] : []

        content {
          days          = lifecycle_rule.value.standard_transition_days
          storage_class = "STANDARD_IA"
        }
      }

      dynamic "expiration" {
        for_each = lifecycle_rule.value.enable_current_object_expiration ? [1] : []

        content {
          days = lifecycle_rule.value.expiration_days
        }
      }
    }
  }

  dynamic "logging" {
    for_each = var.logging == null ? [] : [1]
    content {
      target_bucket = var.logging["bucket_name"]
      target_prefix = var.logging["prefix"]
    }
  }

  # https://docs.aws.amazon.com/AmazonS3/latest/dev/bucket-encryption.html
  # https://www.terraform.io/docs/providers/aws/r/s3_bucket.html#enable-default-server-side-encryption
  /*server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "${var.sse_algorithm}"
        kms_master_key_id = "${var.kms_master_key_id}"
      }
    }
  }*/
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  versioning {
    enabled = var.versioning_enabled
  }

  tags = merge(var.tags, {
    Name = local.bucket_name
  })
}

###################################################################
# S3 BUCKET ACL
###################################################################

resource "aws_s3_bucket_public_access_block" "main" {
  block_public_acls       = local.is_private
  block_public_policy     = local.is_private
  bucket                  = aws_s3_bucket.main.bucket
  ignore_public_acls      = local.is_private
  restrict_public_buckets = local.is_private
}

###################################################################
# S3 BUCKET POLICY
###################################################################

data "aws_iam_policy_document" "main" {

  dynamic "statement" {
    for_each = var.allow_alb_logging ? [1] : []

    content {
      sid       = "ApplicationLoadBalancerACL"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.main.arn}/alb/*"]

      principals {
        identifiers = [data.aws_elb_service_account.main.arn]
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_cloudfront_logging ? [1] : []

    content {
      sid       = "CloudFrontLogDelivery"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.main.arn}/cloudfront/*"]

      principals {
        identifiers = ["arn:aws:iam::${var.aws_account_id}:root"]
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_vpc_flow_logging ? [1] : []

    content {
      sid       = "AWSLogDeliveryWrite"
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.main.arn}/AWSLogs/*"]

      principals {
        identifiers = ["delivery.logs.amazonaws.com"]
        type        = "Service"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_vpc_flow_logging ? [1] : []

    content {
      sid       = "AWSLogDeliveryAclCheck"
      effect    = "Allow"
      actions   = ["s3:GetBucketAcl"]
      resources = ["${aws_s3_bucket.main.arn}"]

      principals {
        identifiers = ["delivery.logs.amazonaws.com"]
        type        = "Service"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket     = aws_s3_bucket.main.bucket
  policy     = data.aws_iam_policy_document.main.json
  depends_on = [aws_s3_bucket_public_access_block.main]
}
