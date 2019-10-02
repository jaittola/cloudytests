variable "region" {
    default = "eu-central-1"
}

variable "availability_zone_count" {
    default = 2
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

variable "app_port" {
    default = "8000"
}

variable "ext_port" {
    default = "80"
}

variable "health_check_path" {
    default = "/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "db_port" {
    description = "RDS PostgreSQL listen port"
    default = "5432"
}
