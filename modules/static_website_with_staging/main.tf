terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      configuration_aliases = [ aws, aws.use1 ]
    }
  }
}

module "prod_site" {
  source = "../static_website"
  github_oidc_provider_arn = var.github_oidc_provider_arn
  repository = var.repository
  hosted_zone_id = var.hosted_zone_id
  bucket_name = var.bucket_name
  force_www = var.force_www
  domain_name = var.domain_name
  workflow_filter = var.production_workflows
  gh_secret_prefix = var.production_secret_prefix
  providers = {
    aws = aws
    aws.use1 = aws.use1
  }
}

module "staging_site" {
  source = "../static_website"
  github_oidc_provider_arn = var.github_oidc_provider_arn
  repository = var.repository
  hosted_zone_id = var.hosted_zone_id
  bucket_name = "staging-${var.bucket_name}"
  force_www = false
  domain_name = "staging.${var.domain_name}"
  workflow_filter = var.staging_workflows
  gh_secret_prefix = var.staging_secret_prefix
  read_only_buckets = [module.prod_site.bucket_name]
  providers = {
    aws = aws
    aws.use1 = aws.use1
  }
}

resource "github_actions_variable" "staging_website" {
  repository = "${split("/", var.repository)[1]}"
  variable_name = "STAGING_WEBSITE"
  value = "https://staging.${var.domain_name}"
}
