resource "aws_route53_record" "atproto_record" {
  zone_id = var.hosted_zone_id
  name    = "_atproto"
  type    = "TXT"
  ttl     = var.ttl

  records = ["${var.atproto_value}"]
}
