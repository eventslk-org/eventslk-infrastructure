variable "aws_region" {
  description = "Target AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_val" {
  description = "Optional AMI override. Leave empty to auto-resolve the latest Canonical Ubuntu 22.04 LTS AMI for the selected region."
  type        = string
  default     = ""
}

variable "root_volume_size" {
  description = "Root EBS volume size (GiB) for each cluster node."
  type        = number
  default     = 30
}

variable "key_name_val" {
  description = "Name of the AWS EC2 key pair for SSH access"
  type        = string
}

variable "master_instance_type" {
  description = "Instance type for the K8s master node"
  type        = string
  default     = "t3.medium"
}

variable "worker_instance_type" {
  description = "Instance type for K8s worker nodes"
  type        = string
  default     = "t3.medium"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_state" {
  description = "Desired EC2 state: running or stopped"
  type        = string
  default     = "stopped"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH into cluster nodes (e.g. your office or VPN egress IP)"
  type        = list(string)
}
