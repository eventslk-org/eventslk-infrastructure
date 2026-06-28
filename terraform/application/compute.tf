# ── Master Node ──────────────────────────────────────────────

resource "aws_instance" "master" {
  ami                    = var.ami_val
  instance_type          = var.master_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name_val
  tags                   = { Name = "eventslk-master" }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }
}

# ── Worker Nodes ─────────────────────────────────────────────

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = var.ami_val
  instance_type          = var.worker_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name_val
  tags                   = { Name = "eventslk-worker-${count.index}" }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted = true
  }
}

# ── Elastic IPs (stable IPs that survive stop/start) ────────

resource "aws_eip" "master" {
  domain = "vpc"
  tags   = { Name = "eip-eventslk-master" }
}

resource "aws_eip_association" "master" {
  instance_id   = aws_instance.master.id
  allocation_id = aws_eip.master.id
}

resource "aws_eip" "worker" {
  count  = var.worker_count
  domain = "vpc"
  tags   = { Name = "eip-eventslk-worker-${count.index}" }
}

resource "aws_eip_association" "worker" {
  count         = var.worker_count
  instance_id   = aws_instance.worker[count.index].id
  allocation_id = aws_eip.worker[count.index].id
}

# ── Instance State Management ────────────────────────────────
# Controls whether instances are running or stopped.
# Set instance_state = "running" to start, "stopped" to stop.

resource "aws_ec2_instance_state" "master" {
  instance_id = aws_instance.master.id
  state       = var.instance_state
}

resource "aws_ec2_instance_state" "worker" {
  count       = var.worker_count
  instance_id = aws_instance.worker[count.index].id
  state       = var.instance_state
}
