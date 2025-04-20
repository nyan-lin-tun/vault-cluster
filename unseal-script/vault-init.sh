#!/bin/sh

# initialize vault
echo "Script is running from: $(pwd)"
if [ ! -f /unseal-script/unseal-output.txt ]; then # File not found
    echo "Vault is not initialized. Initializing now..."
    vault server -config=/vault/config/config.hcl & sleep 0.5
    vault operator init > /unseal-script/unseal-output.txt
else
    echo "Vault is already initialized. Skipping initialization."
    echo "Cleaning up files in /vault/file/*..."
    rm -rf /vault/file/*
    vault server -config=/vault/config/config.hcl & sleep 0.5
    echo "Raft joined successfully"
fi

# unseal vault
for i in $(seq 1 3); do
    echo "Unsealing Vault with Unseal Key $i"
    vault operator unseal $(grep "Unseal Key $i:" /unseal-script/unseal-output.txt | awk '{print $4}')
done

vault login $(grep "Initial Root Token:" /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Unseal successfully."

vault status

vault operator raft list-peers

wait