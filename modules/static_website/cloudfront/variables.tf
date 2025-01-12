variable "gh_secret_prefix" {
  description = "Prefix for the GitHub secret"
  type        = string
}

variable "repository" {
  description = "GitHub repository name"
  type        = string
}

variable "s3_bucket" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "workflow_role_name" {
  description = "Name of the IAM role for the workflow"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the distribution"
  type        = string
  default = ""
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}


