# MXRoute

*Terraform setup for Route53 DNS records for MXRoute.*

This module creates several email-related DNS records when using MXRoute as
your email provider. It creates the following records:

* `MX` records for the domain
* `TXT` records for SPF
* `TXT` records for DKIM
* `TXT` records for DMARC

Note that DMARC isn't really required, but it does come as part of this module.
I always set up DMARC, because... why not?

This module assumes that all MXRoute uses have MX records pointing to
`${NAME}.mxrouting.com` and `${NAME}-relay.mxrouting.com`, where `${NAME}` is
the same for a given user (but may differ between users). This matches my
experience and what I've seen in the documentation, but I'm not sure it is 100%
guaranteed. If your setup is different, note that you may need to modify this.
