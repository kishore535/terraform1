###################################################################
# S3 BUCKET
###################################################################

resource "aws_s3_bucket" "main" {
  acl           = var.acl
  bucket        = local.bucket_name
  force_destroy = true

  lifecycle_rule {
    enabled = true
    id      = "${var.globally_unique_prefix}-${var.environment}-lifecycle-rule"
    prefix  = var.lifecycle_prefix
    tags    = var.lifecycle_tags

    expiration {
      days = var.expiration_days
    }

    noncurrent_version_expiration {
      days = var.noncurrent_version_expiration_days
    }

    noncurrent_version_transition {
      days          = var.noncurrent_version_transition_days
      storage_class = "GLACIER"
    }

    transition {
      days          = var.standard_transition_days
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = var.glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  /*logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "s3/"
  }*/

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

resource "aws_s3_bucket_public_access_block" "main" {
  block_public_acls       = local.is_private
  block_public_policy     = local.is_private
  bucket                  = aws_s3_bucket.main.bucket
  ignore_public_acls      = local.is_private
  restrict_public_buckets = local.is_private
}
