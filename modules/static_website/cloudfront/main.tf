resource "aws_cloudfront_function" "redirect_function" {
  # TODO: this should not be made if there is no domain name
  #count   = var.domain_name != "" ? 1 : 0  # TESTING
  name    = replace("${var.domain_name}-redirects", ".", "-")
  runtime = "cloudfront-js-1.0"
  comment = "Redirect to www.${var.domain_name}"
  code    = <<-EOF
        function handler(event) {
            var request = event.request;
            var host = request.headers.host.value;

            if (!host.startsWith("www.")) {
                return {
                    statusCode: 301,
                    statusDescription: "Permanently moved",
                    headers: {
                        location: { value: "https://www." + host },
                    },
                };
            }
            return request;
        }
  EOF
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2"
  default_root_object = "index.html"

  # TODO: this should not be made if there is no domain name
  aliases = var.domain_name != "" ? [
    var.domain_name,
    "www.${var.domain_name}"
  ] : []  # TESTING

  origin {
    domain_name = "${var.s3_bucket}.s3-website.${data.aws_region.current.name}.amazonaws.com"
    origin_id   = "S3-${var.s3_bucket}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      origin_read_timeout      = 30
      origin_keepalive_timeout = 5
    }
  }

  default_cache_behavior {
    target_origin_id       = "S3-${var.s3_bucket}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    default_ttl            = 86400
    max_ttl                = 31536000

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }

    # TODO: this should not be made if there is no domain name
    dynamic "function_association" {
      for_each = var.domain_name != "" ? [1] : []  # TESTING
      content {
        event_type = "viewer-request"
        function_arn = aws_cloudfront_function.redirect_function.arn
      }
    }
    #function_association {
      #count = var.domain_name != "" ? 1 : 0  # TESTING
      #event_type = "viewer-request"
      #function_arn = aws_cloudfront_function.redirect_function.arn
    #}
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 60
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_All"

  # if we have a certificate, use it
  dynamic "viewer_certificate" {
    for_each = var.certificate_arn != "" ? [1] : []  # TESTING
    content {
      acm_certificate_arn      = var.certificate_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.1_2016"
    }
  }

  # if we don't have a certificate, use the CloudFront default
  dynamic "viewer_certificate" {
    for_each = var.certificate_arn == "" ? [1] : []  # TESTING
    content {
      cloudfront_default_certificate = true
    }
  }
}

# TODO: this should not be made if there is no domain name
resource "aws_route53_record" "root_domain" {
  count  = var.domain_name != "" ? 1 : 0  # TESTING
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# TODO: this should not be made if there is no domain name
resource "aws_route53_record" "www_domain" {
  count = var.domain_name != "" ? 1 : 0  # TESTING
  zone_id = var.hosted_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.distribution.domain_name
    zone_id                = aws_cloudfront_distribution.distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# AWS policy to allow CloudFront to create invalidations; attach to role
data "aws_iam_policy_document" "cloudfront_invalidation_policy" {
  statement {
    actions   = ["cloudfront:CreateInvalidation"]
    resources = [aws_cloudfront_distribution.distribution.arn]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "cloudfront_invalidation_policy" {
  description = "IAM policy to allow CloudFront to create invalidations"
  policy      = data.aws_iam_policy_document.cloudfront_invalidation_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudfront_attachment" {
  role       = var.workflow_role_name
  policy_arn = aws_iam_policy.cloudfront_invalidation_policy.arn
}

resource "github_actions_secret" "cloudfront_distribution_id" {
  repository = "${split("/", var.repository)[1]}"
  secret_name = "${var.gh_secret_prefix}_CLOUDFRONT"
  plaintext_value = aws_cloudfront_distribution.distribution.id
}

data "aws_region" "current" {}
