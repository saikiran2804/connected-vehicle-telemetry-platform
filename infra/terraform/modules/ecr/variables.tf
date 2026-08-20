variable "repository_names" {
  description = "List of ECR repository names to create (one per service)."
  type        = list(string)
}

variable "tags" {
  description = "Extra tags applied to every repository."
  type        = map(string)
  default     = {}
}
