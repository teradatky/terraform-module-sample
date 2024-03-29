# AWS Terraform Module

## VPC Module

This module can provison these resources below.

* VPC
* Internet Gateway
* Public Subnet
* Public Route Table
* Public Route
* Public Route Table Association
* NAT Gateway
* EIP of NAT Gateway
* Private Subnet
* Private Route Table
* Private Route
* Private Route Table Association

### VPC Usage

```hcl
module "vpc_main" {
  source = "./module/vpc"

  name = "terraform-sample" # Used for Name_tag
  cidr = "10.8.0.0/16"
  azs  = ["ap-northeast-1a", "ap-northeast-1c"]

  public_subnets  = ["10.8.8.0/24", "10.8.16.0/24"]
  private_subnets = ["10.8.64.0/24", "10.8.72.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  common_tags = {
    Env    = "dev"
  }
}
```

### NAT Gateway Configuration

* No NAT Gateway
  * enable_nat_gateway = false

* Single NAT Gateway
  * enable_nat_gateway = true
  * single_nat_gateway = true

* Multiple NAT Gateway (Every Public Subnet)
  * enable_nat_gateway = true
  * single_nat_gateway = false

## EC2 Module

This module can provison these resources below.

* EC2 with EIP

### EC2 Usage

```hcl
module "ec2_bastion" {
  source = "./module/ec2"

  name                   = "bastion-linux" # Used for Name_tag
  ami                    = "ami-00000000000000000"
  instance_type          = "t3.micro"
  subnet_id              = "subnet-00000000000000000"
  vpc_security_group_ids = ["sg-00000000000000000"]
  private_ip             = "172.31.32.10"
  key_name               = "key_name"

  volume_size = 8
  volume_type = "gp2"

  # user_data = file("./user_data_hoge.sh")
  # iam_instance_profile = "admin_role_for_ec2"

  enable_eip = true

  common_tags = {
    Env    = "dev"
  }
}
```

### EIP Configuration

* Enable EIP (fixed global IP address) for instance such as bastion
  * enable_eip = true

* No EIP needed such as private instance
  * enable_eip = false

## How to use

```bash
git clone https://github.com/teradatky/terraform-module-sample
cd terraform-module-sample
cd environments/dev
terraform init
terraform plan
terraform apply
```
