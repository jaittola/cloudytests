variable "region" {
    default = "eu-central-1"
}

variable "availability_zone_count" {
    default = 2
}

variable "instance_type" {
    default = "t3.micro"
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
    default = "443"
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

variable "app_domain" {
    description = "The domain name for this site"
}

variable "frontend_name" {
    description = "The host name for the frontend of this site"
}

variable "backend_name" {
    description = "The host name for the backend of this site"
}

variable "frontend_protocol" {
    description = "The protocol for accessing the frontend"
    default = "https://"
}

variable "cloudfront_cert_arn" {
    description = "ARN of the certificate for CloudFront. You must create the cert in AWS console and pass its ARN to terraform."
}

variable "cloudfront_priceclass" {
    description = "Price class for the CloudFront distribution. PriceClass_100 includes only North America and Europe."
    default = "PriceClass_100"
}

variable "ecs_container_ami_id" {
    description = "ID of the AMI used for the EC2 hosts. This is AWS region specific. The default value is in Frankfurt."
    default = "ami-084ab95c0cbe247e5"
}
