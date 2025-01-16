
module "certificate" {
  count = var.domain_name != "" ? 1 : 0
  source = "./r53certificate"
  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  providers = {
    aws = aws.use1
  }
}

module "bucket" {
  source = "./bucket_and_role"
  bucket_name = var.bucket_name
  oidc_provider_arn = var.github_oidc_provider_arn
  workflow_filter = var.workflow_filter
  repository = var.repository
  gh_secret_prefix = var.gh_secret_prefix
  read_only_buckets = var.read_only_buckets
}

module "cloudfront" {
  source = "./cloudfront"
  domain_name = var.domain_name
  workflow_role_name = module.bucket.role_name
  certificate_arn = length(module.certificate) > 0 ? module.certificate[0].certificate_arn : ""
  s3_bucket = var.bucket_name
  hosted_zone_id = var.hosted_zone_id
  repository = var.repository
  gh_secret_prefix = var.gh_secret_prefix
}
