variable "env"                                {}
variable "vpc_id"                             {}
variable "public_subnet_ids"                  {}
variable "project_name"                       {}
variable "alb_name"                           {}
variable "alb_ssl_cert_arn"                   {}
variable "alb_listener_http_count"            {
  default = true
}
variable "alb_listener_default_http_arn"      {
  default = ""
}
variable "alb_listener_https_count"           {
  default = true
}
variable "alb_listener_default_https_arn"     {
  default = ""
}
