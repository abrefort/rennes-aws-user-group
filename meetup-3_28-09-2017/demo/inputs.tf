variable "bucket_name" {
  type = "string"
}

variable "cloudfront_alias" {
  type = "string"
}

variable "origin_domain_name" {
  type = "string"
}

variable "cron" {
  default = ""
  type    = "string"
}
