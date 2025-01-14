variable "domain_name" {
  description = "The domain name for the Route 53 hosted zone"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "The ID of the Route 53 hosted zone"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "github_oidc_provider_arn" {
  description = "The ARN of the GitHub OIDC provider"
  type        = string
}

variable "repository" {
  description = "The name of the GitHub repository"
  type        = string
}

variable "workflow_filter" {
  description = "The filter for the GitHub Actions workflow"
  type        = list(string)
}

variable "gh_secret_prefix" {
  description = "The prefix for the GitHub secret"
  type        = string
}
