variable "region" {
    default = "eu-central-1"
}

variable "availability_zone" {
    default = "eu-central-1b"
}

variable "instance_type" {
    default = "t3.nano"
}

variable "environment_tag" {
    default = "Cloudy testing"
}

variable "cidr_block" {
    default = "10.100.0.0/16"
}

variable "public_subnet" {
    default = "10.100.1.0/24"
}

variable "private_subnet" {
    default = "10.100.2.0/24"
}
