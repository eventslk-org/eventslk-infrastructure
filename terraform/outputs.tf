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
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}

output "security_group_id" {
  value = aws_security_group.main.id
}
