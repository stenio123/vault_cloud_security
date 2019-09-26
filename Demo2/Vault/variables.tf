variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "aws_account_id" {
  description = "AWS account id without hifens"
  default     = "753646501470"
}

variable "vault_addr" {
  description = "Address to the existing Vault server"
  default     = "http://ec2-34-238-38-129.compute-1.amazonaws.com:8200"
}

variable "vault_token" {
  description = "Vault token, if not using platform authentication"
  default     = "root"
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
