variable "environment" {
  description = "The environment name"
  type        = string
}

variable "profile_name" {
  description = "The profile name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = ""
}

variable "iam_path" {
  description = "IAM roles will be created on this path."
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "If provided, all IAM roles will be created with this permissions boundary attached."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of subnets for the EKS Fargate profile."
  type        = list(string)
  default     = []
}

variable "namespace" {
  description = "The Kubernetes namespace for the Fargate profile"
  type        = string
}

variable "labels" {
  description = "The Kubernetes labels for the Fargate profile"
  type        = map(string)
}
