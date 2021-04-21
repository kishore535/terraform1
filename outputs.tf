output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.logs.arn
}

output "bucket_domain_name" {
  description = "The bucket domain name of the S3 bucket."
  value       = aws_s3_bucket.logs.bucket_domain_name
}

output "bucket_id" {
  description = "The ID of the S3 bucket."
  value       = aws_s3_bucket.logs.id
}

output "bucket_name" {
  description = "The computed name of the S3 bucket."
  value       = aws_s3_bucket.logs.bucket
}
