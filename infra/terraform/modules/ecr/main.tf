# =====================================================================
# ECR MODULE — creates one private Docker registry per service.
# Uses for_each so adding a service is just adding a name to the list.
# =====================================================================

resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)

  name = each.value

  # MUTABLE lets CI re-push the "latest" tag. (IMMUTABLE would block that.)
  image_tag_mutability = "MUTABLE"

  # Free, built-in vulnerability scan every time an image is pushed.
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encrypt images at rest (AES256, free).
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(var.tags, { Name = each.value })
}

# Lifecycle policy: keep storage tiny (and free). Delete untagged images
# after 7 days, and never keep more than 10 images per repo.
resource "aws_ecr_lifecycle_policy" "this" {
  for_each   = aws_ecr_repository.this
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep only the 10 most recent images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = { type = "expire" }
      }
    ]
  })
}
