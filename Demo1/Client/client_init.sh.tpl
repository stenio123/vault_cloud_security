#!/bin/bash

cd /home/ubuntu
sudo apt-get install unzip jq -y
wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
unzip vault_1.2.3_linux_amd64.zip

##--------------------------------------------------------------------
## Manual process
##--------------------------------------------------------------------
VAULT_ADDR=${vault_addr}
PKCS7=$(curl http://169.254.169.254/latest/dynamic/instance-identity/pkcs7)

echo "{
        \"role\": \"read_role\",
        \"pkcs7\": \"$PKCS7\",
        \"nonce\": \"1234\" 
}" > payload.json


VAULT_TOKEN=$(curl \
    --request POST \
    --data @payload.json \
    $VAULT_ADDR/v1/auth/aws/login | jq -r .auth.client_token)

echo $VAULT_TOKEN > "/home/ubuntu/.vault-token"

SECRET=$(curl \
    --header "X-Vault-Token: $VAULT_TOKEN" \
    $VAULT_ADDR/v1/kv1/aws | jq -r .data)

echo "Secret retrieved from Vault: $SECRET" > /home/ubuntu/vault_secret.txt