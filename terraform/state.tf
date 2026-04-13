resource "aws_ec2_instance_state" "master_state" {
  instance_id = aws_instance.eventslk_master.id
  state       = var.instance_state
}

resource "aws_ec2_instance_state" "worker_state" {
  count       = 2
  instance_id = aws_instance.eventslk_worker[count.index].id
  state       = var.instance_state
}
