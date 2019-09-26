# Vault AWS Dynamic Secrets

This configures an existing Vault server to enable AWS Dynamic secrets

## Required variables
Environment variables:
 - AWS_ACCESS_KEY_ID
 - AWS_SECRET_ACCESS_KEY
 - AWS_DEFAULT_REGION

Terraform variables:
- vault_addr: address to Vault server, in the format http://VAULT_ADDR:8200
- vault_token: a vault access token with sufficient permissions to enable and configure aws auth. Could be given by a CICD orchestrator
- aws_account_id: no hyphens