###########################################################
# EC2 Configuration
###########################################################
resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  private_ip             = var.private_ip
  key_name               = var.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
    encrypted   = var.encrypted
    kms_key_id  = var.kms_key_id
  }

  user_data            = var.user_data
  iam_instance_profile = var.iam_instance_profile

  monitoring              = var.monitoring
  source_dest_check       = var.source_dest_check
  disable_api_termination = var.disable_api_termination

  tags = merge(
    { Name = "${var.name}-ec2" },
    var.common_tags
  )

}

###########################################################
# EIP Configuration
###########################################################
resource "aws_eip" "this" {
  # create and attach EIP if enable_eip == true
  count    = var.enable_eip ? 1 : 0
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(
    { Name = "${var.name}-eip" },
    var.common_tags
  )
}
