resource "aws_route53_record" "mx_records" {
  name    = ""
  zone_id = var.hosted_zone_id
  type    = "MX"
  ttl     = var.ttl

  records = [
    "10 ${var.mxrouting_host}.mxrouting.com",
    "20 ${var.mxrouting_host}-relay.mxrouting.com"
  ]
}

resource "aws_route53_record" "spf_record" {
  zone_id = var.hosted_zone_id
  name    = ""
  type    = "TXT"
  ttl     = var.ttl

  records = ["v=spf1 include:mxlogin.com ~all"]
}

resource "aws_route53_record" "dkim_record" {
  zone_id = var.hosted_zone_id
  name    = "${var.dkim_selector}._domainkey"
  type    = "TXT"
  ttl     = var.ttl

  # AWS has a maximum length for TXT records that is too short for the DKIM
  # key; we split the string with substr to work around that.
  records = ["v=DKIM1; k=rsa; p=${substr(var.dkim_p_value, 0, 200)}\"\"${substr(var.dkim_p_value, 200, -1)}"]
}

resource "aws_route53_record" "dmarc_record" {
  zone_id = var.hosted_zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = var.ttl

  records = ["v=DMARC1; p=none; rua=mailto:${var.dmarc_email}; ruf=mailto:${var.dmarc_email}; fo=1"]
}
