# Allocate the Elastic IPs
resource "aws_eip" "stopped_instance_ips" {
  for_each = toset(var.target_instance_ids)
  domain   = "vpc"

  tags = {
    Name = "eip-${each.value}"
  }
}

# Associate the IPs with the Instances
resource "aws_eip_association" "eip_assoc" {
  for_each      = toset(var.target_instance_ids)
  instance_id   = each.value
  allocation_id = aws_eip.stopped_instance_ips[each.key].id
}
