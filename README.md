# Hashicorp Vault for Cloud Security

This is the code for the webinar on using hashicorp Vault for Cloud Security

## Folders

### Vault
Contains a demo deployment of a Vault server in AWS. Not for production use!

### Demo1
Contains the code showing Vault AWS authentication
#### Vault
Configures Vault to use in the demo. You can use an existing Vault, it is not necessary for it to live in AWS
#### Client
Deploys an EC2 instance and authenticates with Vault. A ssh key is also registered if desired

### Demo2
Contains the code showing Vault Dynamic Secrets (AWS)
#### Vault
Configures Vault to be able to create a dynamic AWS credential, and also creates an S3 bucket and IAM policy to test use