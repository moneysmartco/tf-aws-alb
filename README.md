# Application Load Balancer Module

[![CircleCI](https://circleci.com/gh/moneysmartco/tf-aws-alb.svg?style=svg&circle-token=ca851bec275a8519eaba43d6e0aef4a45e176c5a)](https://circleci.com/gh/moneysmartco/tf-aws-alb)

Update variables following the `variables.tf`

Example

```
# Set default listener arn
module "alb" {
  source  = "git@github.com:moneysmartco/tf-aws-alb.git?ref=master"
  env     = "${var.env}"
  vpc_id  = "${var.vpc_id}"
  public_subnet_ids     = "${var.public_subnet_ids}"
  project_name          = "${var.project_name}"
  alb_name              = "${var.alb_name}"
  #alb_internal          = true # -> set internal ALB
  alb_ssl_cert_arn      = "${var.alb_ssl_cert_arn}"
  alb_listener_default_https_arn = "${var.a_target_arn}"
}

# If you only want to create the ALB without the default listener
module "alb" {
  source  = "git@github.com:moneysmartco/tf-aws-alb.git?ref=master"
  env     = "${var.env}"
  vpc_id  = "${var.vpc_id}"
  public_subnet_ids     = "${var.public_subnet_ids}"
  project_name          = "${var.project_name}"
  alb_name              = "${var.alb_name}"
  alb_ssl_cert_arn      = "${var.alb_ssl_cert_arn}"
  alb_listener_https_count = false
}
```

## Testing

This requires `tflint` https://github.com/wata727/tflint

```
make test
```
