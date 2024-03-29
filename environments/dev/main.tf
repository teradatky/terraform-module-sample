module "vpc_main" {
  source = "../../module/vpc"

  name = "terraform-sample"
  cidr = "10.8.0.0/16"
  azs  = ["ap-northeast-1a", "ap-northeast-1c"]

  public_subnets  = ["10.8.8.0/24", "10.8.16.0/24"]
  private_subnets = ["10.8.64.0/24", "10.8.72.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  common_tags = {
    Env    = "dev"
    System = "terraform"
  }
}

module "ec2_bastion" {
  source = "../../module/ec2"

  name                   = "bastion-linux"
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc_main.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.bastion-sg.id]
  private_ip             = "10.8.8.8"
  # key_name               = "example_key"

  volume_size = 8
  volume_type = "gp2"

  # user_data = file("./user_data_hoge.sh")
  # iam_instance_profile = "admin_role_for_ec2"

  enable_eip = true

  common_tags = {
    Env    = "dev"
    System = "terraform"
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg"
  description = "bastion security group"
  vpc_id      = module.vpc_main.vpc_id

  ingress {
    description = "allow ssh from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["8.8.8.8/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "ec2_bastion"
    Env    = "dev"
    System = "terraform"
  }
}
