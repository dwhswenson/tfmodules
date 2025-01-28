# TODO:
# make_certificate = var.domain_name != "" and var.certificate_arn != ""
# do_dns = var.domain_name != "" and var.hosted_zone_id != ""
# force_www from vars

#locals {
  #make_certificate = (var.domain_name != "") && (var.certificate_arn != "")
  #do_dns = (var.domain_name != "") && (var.hosted_zone_id != "")
#}

module "certificate" {
  count = var.domain_name != "" ? 1 : 0
  source = "./r53certificate"
  domain_name = var.domain_name
  hosted_zone_id = var.hosted_zone_id
  providers = {
    aws = aws.use1
  }
}

#locals {
  #certificate_arn = (
    #length(module.certificate) > 0 ? module.certificate[0].certificate_arn : 
    #(var.certificate_arn != "" ? var.certificate_arn : "")
  #)
#}

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
  domain_name = var.domain_name  # now only used in function association and to force aliases
  workflow_role_name = module.bucket.role_name
  certificate_arn = length(module.certificate) > 0 ? module.certificate[0].certificate_arn : ""
  s3_bucket = var.bucket_name
  #hosted_zone_id = var.hosted_zone_id
  repository = var.repository
  gh_secret_prefix = var.gh_secret_prefix
}

module "dns" {
  count = var.domain_name != "" ? 1 : 0
  source = "./dns"
  domain_names = [
    var.domain_name,
    "www.${var.domain_name}"
  ]
  cloudfront_distribution_name = module.cloudfront.distribution_name
  cloudfront_distribution_hosted_zone = module.cloudfront.distribution_hosted_zone
  hosted_zone_id = var.hosted_zone_id
}

