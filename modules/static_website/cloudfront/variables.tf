variable "s3_bucket" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the distribution"
  type        = string
}

variable "hosted_zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}


