# Vault Platform Authentication - Client

This configures an client to authenticate to Vault using AWS, and the authentication logic is done by a sequence of curl commands ("manual")

## Required variables
Environment variables:
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION

Terraform variables:
aws_key_name: an existing aws_key for ssh. Make sure it exists in the region selected
vault_addr: address to Vault server, in the format http://VAULT_ADDR:8200