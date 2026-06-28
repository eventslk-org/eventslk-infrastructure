# ── AMI lookup (Canonical Ubuntu 22.04 LTS, amd64) ───────────

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  resolved_ami = var.ami_val != "" ? var.ami_val : data.aws_ami.ubuntu.id
}

# ── Master Node ──────────────────────────────────────────────

resource "aws_instance" "master" {
  ami                    = local.resolved_ami
  instance_type          = var.master_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name_val
  tags                   = { Name = "eventslk-master" }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }
}

# ── Worker Nodes ─────────────────────────────────────────────

resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = local.resolved_ami
  instance_type          = var.worker_instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.main.id]
  key_name               = var.key_name_val
  tags                   = { Name = "eventslk-worker-${count.index}" }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
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
