resource "aws_ecr_repository" "ai_dev_agent" {
  name                 = "ai-dev-agent"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "ai-autonomous-devops-agent"
  }
}
