variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default     = "ami-2e1ef954"
}

variable "aws_key_name" {
  description = "existing ssh key in aws"
}

variable "instance_type" {
  description = "type of EC2 instance to provision."
  default     = "t2.micro"
}

variable "name" {
  description = "name to pass to Name tag"
  default     = "Vault Dev Server"
}

variable "ttl" {
  description = "ttl to pass to TTL tag"
  default     = "24"
}

variable "owner" {
  description = "Owner to pass to owner tag"
  default     = "Stenio Ferreira"
}

