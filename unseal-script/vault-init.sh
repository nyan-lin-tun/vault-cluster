#!/bin/sh

# initialize vault
if [ ! -s /unseal-script/unseal-output.txt ]; then
    vault server -config=/vault/config/config.hcl & sleep 0.5
    vault operator init > /unseal-script/unseal-output.txt
else
    echo "Vault is already initialized. Skipping initialization."
    echo "Cleaning up files in /vault/file/*..."
    rm -rf /vault/file/*
    vault server -config=/vault/config/config.hcl & sleep 0.5
fi

# unseal vault
for i in $(seq 1 3); do
    vault operator unseal $(grep "Unseal Key $i:" /unseal-script/unseal-output.txt | awk '{print $4}')
done

vault login $(grep "Initial Root Token:" /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Unseal successfully."

vault status

vault operator raft list-peers