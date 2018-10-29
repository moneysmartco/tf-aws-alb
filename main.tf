#--------------------
# Security Group
#--------------------
resource "aws_security_group" "alb_sg" {
  name_prefix = "tf-${var.alb_name}-sg"
  description = "${var.alb_name} ALB SecGroup"

  vpc_id = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.alb_name}-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_http_all" {
  count             = "${length(compact(var.alb_ingress_whitelist_ips)) == 0 ? 1: 0}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb_sg.id}"
}

resource "aws_security_group_rule" "allow_http_custom" {
  count             = "${length(compact(var.alb_ingress_whitelist_ips)) != 0 ? 1: 0}"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = "${var.alb_ingress_whitelist_ips}"
  security_group_id = "${aws_security_group.alb_sg.id}"
}

resource "aws_security_group_rule" "allow_https_all" {
  count             = "${length(compact(var.alb_ingress_whitelist_ips)) == 0 ? 1: 0}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb_sg.id}"
}

resource "aws_security_group_rule" "allow_https_custom" {
  count             = "${length(compact(var.alb_ingress_whitelist_ips)) != 0 ? 1: 0}"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = "${var.alb_ingress_whitelist_ips}"
  security_group_id = "${aws_security_group.alb_sg.id}"
}


#--------------------
# ALB
#--------------------
resource "aws_alb" "alb" {
  # Wait until https://github.com/hashicorp/terraform/pull/16997 is merged
  # Otherwise alb name_prefix must be shorter than 6 chars
  # name_prefix     = "${var.alb_name}"
  name            = "${var.alb_name}"
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = ["${split(",", var.public_subnet_ids)}"]
  internal        = "${var.alb_internal}"
  enable_deletion_protection = "${var.alb_enable_deletion_protection}"

  access_logs {
    bucket  = "${var.alb_s3_access_log_bucket}"
    prefix  = "${var.alb_name}"
    enabled = "${var.alb_s3_access_log_enabled}"
  }

  tags {
    Name        = "${var.alb_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    Type        = "alb"
    Layer       = "alb"
  }

  lifecycle {
    create_before_destroy = true
  }
}


#-------------------------
# HTTP Listener Default
#-------------------------
resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


#-------------------------
# HTTPS Listener Default
#-------------------------
resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_ssl_cert_arn}"

  default_action {
    target_group_arn = "${var.alb_listener_https_count ? var.alb_listener_default_https_arn : aws_alb_target_group.default_https.arn}"
    type             = "forward"
  }
}


#--------------------------------------------------
# HTTP ALB Target Group without default http_arn
#--------------------------------------------------
resource "aws_alb_target_group" "default_http" {
  name = "alb-default-${var.env}-${var.project_name}"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}

#--------------------------------------------------
# HTTPS ALB Target Group without default https_arn
#--------------------------------------------------
resource "aws_alb_target_group" "default_https" {
  name = "alb-default-${var.env}-${var.project_name}"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}
