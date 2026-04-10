# Description: Defines the variables required for EventsLK infrastructure

variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_val" {
  description = "AMI ID for Ubuntu 22.04 LTS"
  type        = string
}

variable "master_instance_type" {
  description = "Instance type for the Master node"
  type        = string
  default     = "t3.medium" # Recommended for K8s Master
}

variable "worker_instance_type" {
  description = "Instance type for the Worker node"
  type        = string
  default     = "t3.small"
}

variable "subnet_id_val" {
  description = "Subnet ID to launch instances"
  type        = string
}

variable "key_name_val" {
  description = "SSH Key pair name"
  type        = string
}

variable "security_groups_val" {
  description = "List of security group IDs"
  type        = list(string)
}