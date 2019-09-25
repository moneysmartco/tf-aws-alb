variable "env"                                {}

variable "vpc_id"                             {}

variable "public_subnet_ids"                  {}

variable "project_name"                       {}

variable "alb_name"                           {}

variable "alb_ssl_cert_arn"                   {}

variable "alb_listener_https_count"           {
  description = "Use alb_listener_default_https_arn as default target group on ALB"
  default     = true
}

variable "alb_listener_default_https_arn"     {
  description = "Default target group for HTTPS listener"
  default     = ""
}

variable "alb_internal" {
  description = "Set LB to be private or public"
  default = false
}

variable "alb_enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer"
  default = false
}

variable "alb_s3_access_log_bucket" {
  description = "S3 bucket name to store ALB access logs"
  default = ""
}

variable "alb_s3_access_log_enabled" {
  description = "Boolean to enable / disable ALB access logs"
  default = false
}

variable "alb_ingress_whitelist_ips" {
  description = "List of IPs that ALB allows to connect to. Use comma to separate multiple IPs"
  type = "string"
  default = ""
}

variable "alb_ingress_source_security_group_ids" {
  description = "List of source Security Group IDs that ALB allows to connect to. Use comma to separate multiple Ids"
  type = "string"
  default = ""
}

variable "tags" {
  description = "Tagging resources with default values"
  default = {
    "Name" = ""
    "Country" = ""
    "Environment" = ""
    "Repository" = ""
    "Owner" = ""
    "Department" = ""
    "Team" = "shared"
    "Product" = "common"
    "Project" = "common"
    "Stack" = ""
  }
}
