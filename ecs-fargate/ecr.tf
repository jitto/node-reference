########################################################################################################################
## Container registry for the service's Docker image

resource "aws_ecr_repository" "ecr" {
  name  = "demo-ecr"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}
