resource "aws_alb" "alb" {
  name            = "demo-ALB"
  security_groups = [aws_security_group.allow_http.id]
  subnets         = [aws_subnet.priv_subnet_1.id, aws_subnet.priv_subnet_2.id, aws_subnet.priv_subnet_3.id]
}

resource "aws_alb_target_group" "alb-example" {
  name        = "tf-example-lb-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type          = "ip"
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb-example.arn
  }
}

output "ALB_http_api_endpoint" {
  value = aws_alb.alb.dns_name
}