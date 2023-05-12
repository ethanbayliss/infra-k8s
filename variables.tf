variable "AWS_DEFAULT_REGION" {
  default = "ap-southeast-2"
}

variable "env" {
}

variable "name" {
}

variable "admin_role_arn" {
  description = "Example: arn:aws:iam::158237111111:role/AWSReservedSSO_AdministratorAccess_17b27zzzzz385ed9"
}

variable "cluster_version" {
  default = "1.25"
}
