variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}
variable "avail_zone" {}
variable "my_ip" {}            # CIDR, e.g. 203.0.113.10/32
variable "instance_type" {}

variable "ami_id" {
  default = "ami-0011550b539717e2a"   # your RHEL 8 image
}
variable "key_name" {
  default = "server-build"            # must already exist in ap-south-1
}
