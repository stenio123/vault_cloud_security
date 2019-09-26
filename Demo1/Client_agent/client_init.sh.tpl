#!/bin/bash

cd /home/ubuntu
sudo apt-get install unzip jq -y
wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
unzip vault_1.2.3_linux_amd64.zip

#--------------------------------------------------------------------
## Option 2: Using Vault Agent to abstract the logic
##--------------------------------------------------------------------

cat << EOF > /home/ubuntu/vault-agent.hcl
pid_file = "./pidfile"
auto_auth {
   method "aws" {
       mount_path = "auth/aws"
       config = {
           type = "ec2"
           role = "read_role"
       }
   }
   sink "file" {
       config = {
           path = "/home/ubuntu/.vault-token"
       }
   }
}
vault {
   address = "${vault_addr}"
}
EOF

./vault agent -config=/home/ubuntu/vault-agent.hcl &
#export VAULT_TOKEN=$(cat /home/ubuntu/.vault-token)
export VAULT_ADDR=${vault_addr}
SECRET=$(./vault read kv1/aws)

#SECRET=$(curl \
#    --header "X-Vault-Token: $VAULT_TOKEN" \
#    $VAULT_ADDR/v1/kv1/aws | jq -r .data)

echo "Secret retrieved from Vault: $SECRET" > /home/ubuntu/vault_secret.txt
