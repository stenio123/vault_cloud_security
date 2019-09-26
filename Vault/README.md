# Webinar: Cloud Security With Vault

## Vault Server Demo

This terraform code will deploy a very basic, demo Vault server used for the webinar.

This code is not recommended for production.

### Required variables
Environment variables:
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION

Terraform variables:
aws_key_name - an existing aws_key for ssh. Make sure it exists in the region selected