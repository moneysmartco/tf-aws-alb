output "alb_arn" {
  value = "${aws_alb.alb.arn}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.alb.arn_suffix}"
}
output "alb_sg_id" {
  value = "${aws_security_group.alb_sg.id}"
}

output "alb_listener_http_arn" {
  value = "${aws_alb_listener.alb_listener_http.arn}"
}

output "alb_listener_https_arn" {
  value = "${aws_alb_listener.alb_listener_https.arn}"
}

output "alb_url" {
  value = "${aws_alb.alb.dns_name}"
}

output "alb_security_group_id" {
  value = "${aws_security_group.alb_sg.id}"
}