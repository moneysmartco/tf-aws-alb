#--------------------
# Security Group
#--------------------
resource "aws_security_group" "alb_sg" {
  name = "${var.alb_name}-sg"
  description = "${var.alb_name} ALB SecGroup"

  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.alb_name}-sg"
  }
}


#--------------------
# ALB
#--------------------
resource "aws_alb" "alb_name" {
  name            = "${var.alb_name}"
  internal        = false
  security_groups = ["${aws_security_group.alb_sg.id}"]
  subnets         = ["${split(",", var.public_subnet_ids)}"]

  enable_deletion_protection = false

  # access_logs {
  #   bucket = "${aws_s3_bucket.alb_logs.bucket}"
  #   prefix = "test-alb"
  # }

  tags {
    Name        = "${var.alb_name}"
    Project     = "${var.project_name}"
    Environment = "${var.env}"
    Type        = "alb"
    Layer       = "alb"
  }
}


#-------------------------
# HTTP Listener Defaulti, Given alb_listener_default_http_arn
#-------------------------
resource "aws_alb_listener" "alb_listener_http" {
  count = "${var.alb_listenter_default_http_arn == "" ? 0 : 1}"
  load_balancer_arn = "${aws_alb.alb_name.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${var.alb_listenter_default_http_arn}"
    type             = "forward"
  }
}


#-------------------------
# HTTPS Listener Default, Given alb_listener_default_http_arn
#-------------------------
resource "aws_alb_listener" "alb_listener_https" {
  count = "${var.alb_listenter_default_http_arn == "" ? 0 : 1}"
  load_balancer_arn = "${aws_alb.alb_name.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_ssl_cert_arn}"

  default_action {
    target_group_arn = "${var.alb_listenter_default_http_arn}"
    type             = "forward"
  }
}


#-------------------------
# ALB Target Group when without default http_arn
#-------------------------
resource "aws_alb_target_group" "default" {
  count = "${var.alb_listenter_default_http_arn == "" ? 1 : 0}"
  name = "alb-default-${var.env}-${var.project_name}"
  port = "80"
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"

  health_check {
    path = "/"
  }
}


#-------------------------
# HTTP Listener Default, without default http_arn
#-------------------------
resource "aws_alb_listener" "alb_listener_http_empty_target_group" {
  count = "${var.alb_listenter_default_http_arn == "" ? 1 : 0}"
  load_balancer_arn = "${aws_alb.alb_name.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}


#-------------------------
# HTTPS Listener Default, without default http_arn
#-------------------------
resource "aws_alb_listener" "alb_listener_https_empty_target_group" {
  count = "${var.alb_listenter_default_http_arn == "" ? 1 : 0}"
  load_balancer_arn = "${aws_alb.alb_name.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${var.alb_ssl_cert_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.arn}"
    type             = "forward"
  }
}