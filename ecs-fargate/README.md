```bash
aws configure #User with permissions to provision network, ECS, API GW and service map
terraform init
terraform apply -auto-approve
```

This example provisions an ECS Fargate cluster, task definition, service, IAM roles, load balancer and networking in AWS. Run the two commands in the ecs-fargate folder after exporting your AWS credentials and region to the environment.

ECS service is available to the outside world via API GW (HTTP API) which uses ALB to route to the running ECS tasks.  Example does not have any authentication added and thus anybody can call the API GW endpoint.  Adding authentication and authorization is a must.

ECS tasks are using a public dockerhub image.  Using AWS ECR should be a must for application workloads.