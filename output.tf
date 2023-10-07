output "lb_address" {
  value = aws_lb.test_alb.dns_name
  description = "DNS of load balancer"
}