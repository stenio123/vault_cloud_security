#!/bin/bash

sudo apt-get install unzip
wget https://releases.hashicorp.com/vault/1.2.3/vault_1.2.3_linux_amd64.zip
unzip vault_1.2.3_linux_amd64.zip
./vault server -dev -dev-listen-address "0.0.0.0:8200" -dev-root-token-id "root" &