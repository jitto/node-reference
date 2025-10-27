#3. Cluster:

resource "aws_ecs_cluster" "demo_cluster" {
  name = "demo_ecs_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#4. Capacity Provider

resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.demo_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

#5. Task Definition:

resource "aws_ecs_task_definition" "task_registration" {
  family                   = "task_definition_demo"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = ".5vCPU"
  memory = "1024"
  container_definitions    = jsonencode([
  {
    "name": "dotnet",
    "image": "nginx",
    "portMappings" = [
        {
          "containerPort" = 80
          "hostPort"      = 80
        }
    ],
    "essential": true,
  }
])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }
}

#6. ECS Service

resource "aws_ecs_service" "demo_service" {
  name               = "demo-fargate-service"
  cluster            = aws_ecs_cluster.demo_cluster.name 
  task_definition    = aws_ecs_task_definition.task_registration.arn
  desired_count   = 2
  deployment_maximum_percent          = 200
  deployment_minimum_healthy_percent  = 100
  enable_ecs_managed_tags = "true"
  launch_type = "FARGATE"
  network_configuration {
    subnets           = [aws_subnet.priv_subnet_1.id, aws_subnet.priv_subnet_2.id, aws_subnet.priv_subnet_3.id]
    security_groups   = [aws_security_group.allow_http.id]
    assign_public_ip  = "true"
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.alb-example.arn
    container_name   = "dotnet"
    container_port   = 80
  }
}