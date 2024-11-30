variable "aws_region" {
  description = "The AWS region to create the resources in"
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone to create the records in"
}

variable "ttl" {
  description = "The TTL for the records"
  default     = 300
}

variable "atproto_value" {
  description = "The value for the _atproto record; find by going to BlueSky settings => Handle => I have my own doamin"
}


