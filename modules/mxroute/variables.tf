variable "hosted_zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "mxrouting_host" {
  description = "Basename for the mxrouting host"
  type        = string
}

variable "dkim_selector" {
  description = "The DKIM selector for MXRoute"
  type        = string
  default     = "x"
}

variable "dkim_p_value" {
  description = "The DKIM public key value"
  type        = string
}

variable "dmarc_email" {
  description = "The email address for DMARC rua and ruf reporting"
  type        = string
}

variable "ttl" {
  description = "Time-to-live for DNS records"
  type        = number
  default     = 300
}

variable "mail_cnames" {
  description = "List of mail CNAMEs to create; these will map to the mxrouting_host"
  type        = list(string)
  default     = []
}
