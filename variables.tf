# This file allows for easily applying changes to infrastructure through variables. 
# created 2/28/24
# last modified 2/28/24

variable "profile" {
    default = "ec2-user"
}

variable "region" {
    default = "us-east-1"
}
variable "availability_zone" {
  default = "us-east-1a"
}

variable "ami-id" {
  default = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
}

variable "instance_type" {
  default = "t2.micro"
}