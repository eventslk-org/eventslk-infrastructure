# ── Elastic IPs (use these for SSH / Ansible inventory) ─────

output "master_elastic_ip" {
  description = "Stable Elastic IP of the master node"
  value       = aws_eip.master.public_ip
}

output "worker_elastic_ips" {
  description = "Stable Elastic IPs of the worker nodes"
  value       = aws_eip.worker[*].public_ip
}

# ── Instance IDs ─────────────────────────────────────────────

output "master_instance_id" {
  description = "Instance ID of the master node"
  value       = aws_instance.master.id
}

output "worker_instance_ids" {
  description = "Instance IDs of the worker nodes"
  value       = aws_instance.worker[*].id
}

# ── Network IDs (useful for debugging) ───────────────────────

output "vpc_id" {
  description = "VPC ID hosting the cluster."
  value       = aws_vpc.main.id
}

output "subnet_id" {
  description = "Public subnet ID where cluster nodes live."
  value       = aws_subnet.public.id
}

output "security_group_id" {
  description = "Security group ID applied to all cluster nodes."
  value       = aws_security_group.main.id
}

output "ami_id" {
  description = "AMI ID actually used for cluster nodes."
  value       = local.resolved_ami
}

# ── Event-images S3 (wire into event-api-deployment.yaml) ────

output "event_images_bucket" {
  description = "S3 bucket for event images — set as AWS_S3_BUCKET."
  value       = aws_s3_bucket.event_images.bucket
}

output "event_images_public_base_url" {
  description = "Public base URL of event images — set as AWS_S3_PUBLIC_BASE_URL (or leave the app default; swap for a CloudFront domain later)."
  value       = "https://${aws_s3_bucket.event_images.bucket_regional_domain_name}"
}

output "worker_iam_role_arn" {
  description = "Worker-node IAM role assumed by pods via IMDS for S3 uploads."
  value       = aws_iam_role.worker.arn
}
