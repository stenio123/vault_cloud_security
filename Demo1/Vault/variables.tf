variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "ami_id" {
  description = "ID of the AMI to provision. Default is Ubuntu 14.04 Base Image"
  default     = "ami-2e1ef954"
}

variable "aws_account_id" {
  description = "id of AWS account"
}

variable "vault_addr" {
  description = "Address to the existing Vault server"
}

variable "vault_token" {
  description = "Vault token, if not using platform authentication"
}

