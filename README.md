# Application Load Balancer Module

Update variables following the `variables.tf`

Example

```
module "alb" {
  source  = "git@github.com:moneysmartco/terraform-aws.git//alb"
  env     = "${var.env}"
  vpc_id  = "${var.vpc_id}"
  public_subnet_ids     = "${var.public_subnet_ids}"
  project_name          = "${var.project_name}"
  alb_name              = "${var.alb_name}"
  alb_ssl_cert_arn      = "${var.alb_ssl_cert_arn}"
  alb_listenter_default_http_arn  = "${var.a_target_arn}"
  alb_listenter_default_https_arn = "${var.a_target_arn}"
}
```