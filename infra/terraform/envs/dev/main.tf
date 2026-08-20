# The dev environment wires the reusable VPC module with dev-specific values.
# source = local path to the module folder we wrote.
module "vpc" {
  source = "../../modules/vpc"

  name = "${var.project}-${var.environment}" # e.g. cvtp-dev

  # Explicit CIDRs keep the network predictable. 10.0.0.0/16 = 65k addresses.
  cidr_block           = "10.0.0.0/16"
  az_count             = 2
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

# Private Docker registries — one per microservice. EKS will pull from here.
module "ecr" {
  source = "../../modules/ecr"

  repository_names = [
    "${var.project}/telemetry-ingest",
    "${var.project}/alerts-processor",
  ]
}
