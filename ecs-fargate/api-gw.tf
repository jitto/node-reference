# 7. API Gateway V2 (HTTP API) with VPC Link to reach the Fargate service using Cloud Map DNS
resource "aws_apigatewayv2_api" "http_api" {
  name          = "demo-http-api"
  protocol_type = "HTTP"
}

# Create a VPC Link so the HTTP API can reach resources inside the VPC
resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name        = "demo-vpc-link"
  subnet_ids  = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id, aws_subnet.pub_subnet_3.id]
  security_group_ids = [aws_security_group.allow_http.id]

  depends_on = [aws_alb.alb]
}

resource "aws_apigatewayv2_integration" "alb_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "HTTP_PROXY"
  integration_method = "ANY" # Or specific methods like GET, POST, etc.
  connection_type  = "VPC_LINK"
  connection_id    = aws_apigatewayv2_vpc_link.vpc_link.id
  integration_uri      = aws_lb_listener.http_listener.arn # ARN of your ALB listener
}

resource "aws_apigatewayv2_route" "alb_route" {
  api_id        = aws_apigatewayv2_api.http_api.id
  route_key     = "$default"
  target        = "integrations/${aws_apigatewayv2_integration.alb_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}