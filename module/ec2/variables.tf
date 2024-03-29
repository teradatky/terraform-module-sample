###########################################################
# EC2 variables
###########################################################
variable "name" {
  type    = string
  default = "terraform"
}

variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = null
}

variable "private_ip" {
  type    = string
  default = null
}

variable "key_name" {
  type    = string
  default = null
}

variable "volume_size" {
  type    = number
  default = 20
}

variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "encrypted" {
  type    = bool
  default = false
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "monitoring" {
  type    = bool
  default = false
}

variable "source_dest_check" {
  type    = bool
  default = true
}

variable "disable_api_termination" {
  type    = bool
  default = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}

###########################################################
# EIP variables
###########################################################
variable "enable_eip" {
  type    = bool
  default = false
}
