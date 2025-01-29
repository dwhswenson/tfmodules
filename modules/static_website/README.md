# static_website

This Terraform module creates a static website hosted on AWS S3 and deployed
using GitHub Actions. It can also create a CloudFront distribution in front of
the S3 bucket, and a certificate in ACM to enable HTTPS.

I usually use this by setting up 2 instantiations of this module: one for the
production site, and one for the staging site.

## Use cases

This assumes that you're keeping most of your infrastructure on AWS. However,
in practice, many people register domains with a registrar other than Route 53.
For the most common cases, this module should work with minimal changes.

The main issues are around creating a certificate to validate the domain name
to CloudFront, and in setting up the DNS records to point to the CloudFront
distribution.

Note that pointing the apex domain to the CloudFront distribution, (e.g., just
example.com instead of www.example.com), depends on your DNA provider. If using
Route 53 for DNS, this is easily done with an alias record (as done in the
module).

### DNS managed by Route 53

This is the easiest case to set up. Provide the `domain_name` and
`hosted_zone_id` variables, and the module will create both the certificate and
the DNS records pointing to the CloudFront distribution.

### DNS managed by another provider

If you're using another DNS provider, you'll need to manually create the
certificate in Amazon Certificate Manager (ACM). I strongly recommend DNS
validation, which will require you to then add specific DNS records at your DNS
provider to prove ownership of the domain. Then you can use this module to
create the infrastructure. Finally, you can manually create the DNS records to
point to your CloudFront distribution. In detail:

#### 1. Create the certificate in ACM, and validate it using DNS.

Either manually or using IaC, create the certificate in ACM. I strongly
recommend using DNS validation, as that allows AWS to automatically renew your
certificate. Once you've created the certificate, ACM will provide you with
CNAME records to add to your DNS provider. ???details???

#### 2. Use this module to create the infrastructure.

In this case, you should provide the `domain_name` and `certificate_arn`
parameters to the module, and leave the `hosted_zone_id` parameter as default
(empty string).

#### 3. Manually create the DNS records to point to the CloudFront distribution.

You can get the CloudFront distribution domain name from the output of this
module. Use that as the target of your DNS record.

### Hosted zone without a domain

In some cases (in particular, if you're setting this up as part of migrating a
domain to AWS), it can make sense to set things up without a link to a domain.
You can use this module for that situation by not providing any of
`domain_name`, `hosted_zone_id`, or `certificate_arn`.

One of the conveniences of this approach is that it makes it very easy to add
in full hosting later if you're transferring a domain to AWS. Once the domain
is transferred in, a quick update of the Terraform here will make it point to
the existing bucket.

## Component Submodules

### r53certificate

### bucket_and_role

### cloudfront

### dns

