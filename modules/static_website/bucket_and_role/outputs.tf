output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.workflow_role.arn
}
