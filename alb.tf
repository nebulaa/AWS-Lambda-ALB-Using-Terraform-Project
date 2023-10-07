resource "aws_security_group" "test_api" {
  name        = "Test-SG"
  description = "ALB security group"
  vpc_id      = aws_vpc.test_vpc.id
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.test_api.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_https" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.test_api.id
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.test_api.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_lb" "test_alb" {
  name               = "Test-API-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.test_api.id]
  subnets            = [aws_subnet.subnetfirst.id, aws_subnet.subnetsecond.id]
  enable_cross_zone_load_balancing = true

  tags = {
    Name = "test-API"
  }
}

resource "aws_lb_target_group" "test_TG" {
  name        = "test-API-TG"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "test_TG" {
  target_group_arn = aws_lb_target_group.test_TG.arn
  target_id        = data.aws_lambda_function.test_lambda_func.arn
  depends_on       = [aws_lambda_permission.allow_alb_invocation]
}

data "aws_lambda_function" "test_lambda_func" {
  function_name = aws_lambda_function.test_lambda_func.function_name
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.test_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test_TG.arn
  }
}
