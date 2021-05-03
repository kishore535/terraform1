###################################################################
# S3 BUCKET
###################################################################

resource "aws_s3_bucket" "main" {
  acl           = var.acl
  bucket        = local.bucket_name
  force_destroy = true

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
# S3 BUCKET POLICY
###################################################################

data "template_file" "main" {
  template = file("${path.module}/json/bucket-policy.json")

  vars = {
    aws_account_id    = var.aws_account_id
    alb_principal_arn = data.aws_elb_service_account.main.arn
    bucket_arn        = aws_s3_bucket.main.arn
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.bucket
  policy = data.template_file.main.rendered
}





/*data "aws_iam_policy_document" "bucket_policy" {
  count = module.this.enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.allow_encrypted_uploads_only ? [1] : []

    content {
      sid       = "DenyIncorrectEncryptionHeader"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${join("", aws_s3_bucket.default.*.id)}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "StringNotEquals"
        values   = [var.sse_algorithm]
        variable = "s3:x-amz-server-side-encryption"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_encrypted_uploads_only ? [1] : []

    content {
      sid       = "DenyUnEncryptedObjectUploads"
      effect    = "Deny"
      actions   = ["s3:PutObject"]
      resources = ["arn:${data.aws_partition.current.partition}:s3:::${join("", aws_s3_bucket.default.*.id)}/*"]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "Null"
        values   = ["true"]
        variable = "s3:x-amz-server-side-encryption"
      }
    }
  }

  dynamic "statement" {
    for_each = var.allow_ssl_requests_only ? [1] : []

    content {
      sid     = "ForceSSLOnlyAccess"
      effect  = "Deny"
      actions = ["s3:*"]
      resources = [
        "arn:${data.aws_partition.current.partition}:s3:::${join("", aws_s3_bucket.default.*.id)}",
        "arn:${data.aws_partition.current.partition}:s3:::${join("", aws_s3_bucket.default.*.id)}/*"
      ]

      principals {
        identifiers = ["*"]
        type        = "*"
      }

      condition {
        test     = "Bool"
        values   = ["false"]
        variable = "aws:SecureTransport"
      }
    }
  }
}

data "aws_iam_policy_document" "aggregated_policy" {
  count         = module.this.enabled ? 1 : 0
  source_json   = var.policy
  override_json = join("", data.aws_iam_policy_document.bucket_policy.*.json)
}

resource "aws_s3_bucket_policy" "default" {
  count      = module.this.enabled && (var.allow_ssl_requests_only || var.allow_encrypted_uploads_only || var.policy != "") ? 1 : 0
  bucket     = join("", aws_s3_bucket.default.*.id)
  policy     = join("", data.aws_iam_policy_document.aggregated_policy.*.json)
  depends_on = [aws_s3_bucket_public_access_block.default]
}*/



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
