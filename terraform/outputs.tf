# Output for the Master Node
output "master_public_ip" {
  description = "Public IP of the Master Node"
  value       = aws_instance.eventslk_master.public_ip
}

# Output for all Worker Nodes
output "worker_public_ips" {
  description = "Public IPs of the Worker Nodes"
  value       = aws_instance.eventslk_worker[*].public_ip
}

# Optional: Get IDs if you need them for CLI commands
output "master_instance_id" {
  value = aws_instance.eventslk_master.id
}

output "worker_instance_ids" {
  value = aws_instance.eventslk_worker[*].id
}

output "new_public_ips" {
  value = {
    for id, eip in aws_eip.stopped_instance_ips : id => eip.public_ip
  }
}

