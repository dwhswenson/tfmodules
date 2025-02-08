variable "github_oidc_provider_arn" {
  description = "The ARN of the OIDC provider for GitHub"
  type        = string
}

variable "repository" {
  description = "The GitHub repository"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone for the site; leave empty if not in Route53"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "The domain name of the site"
  type        = string
}

variable "bucket_name" {
  description = "The name of the production site bucket (staging will prefix `staging-`"
  type        = string
}

variable "production_workflows" {
  description = "The list of production workflows to deploy"
  type        = list(string)
}

variable "staging_workflows" {
  description = "The list of staging workflows to deploy"
  type        = list(string)
}

variable "force_www" {
  description = "Force www. in the domain for the main site"
  type        = bool
  default     = true
}

variable "production_secret_prefix" {
  description = "The prefix for the production secrets"
  type        = string
  default     = "PROD"
}

variable "staging_secret_prefix" {
  description = "The prefix for the staging secrets"
  type        = string
  default     = "STAGING"
}
