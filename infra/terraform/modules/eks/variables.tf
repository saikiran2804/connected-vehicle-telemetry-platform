variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version. Leave null to use the current EKS default (avoids extended-support surcharge). Set explicitly only if needed."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnets for the EKS control plane ENIs (public + private is fine)."
  type        = list(string)
}

variable "node_subnet_ids" {
  description = "Subnets for worker nodes. Public subnets avoid a paid NAT Gateway."
  type        = list(string)
}

variable "node_instance_type" {
  description = "EC2 instance type for worker nodes."
  type        = string
  default     = "t3.small"
}

variable "node_desired_size" {
  description = "Desired number of worker nodes."
  type        = number
  default     = 1
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}
