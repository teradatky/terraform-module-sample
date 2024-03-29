###########################################################
# VPC variables
###########################################################
variable "name" {
  type    = string
  default = "terraform"
}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "azs" {
  type    = list(string)
  default = []
}

variable "public_subnets" {
  type    = list(string)
  default = []
}

variable "private_subnets" {
  type    = list(string)
  default = []
}

###########################################################
# NAT Gateway variables
###########################################################

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

###########################################################
# Other variables
###########################################################
variable "common_tags" {
  type    = map(string)
  default = {}
}



