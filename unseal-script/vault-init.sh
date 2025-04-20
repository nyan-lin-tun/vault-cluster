#!/bin/sh

vault server -config=/vault/config/config.hcl &

sleep 0.5

# initialize vault
if [ ! -s /unseal-script/unseal-output.txt ]; then
    vault operator init > /unseal-script/unseal-output.txt
else
    echo "Vault is already initialized. Skipping initialization."
fi

# unseal vault
for i in $(seq 1 3); do
    vault operator unseal $(grep "Unseal Key $i:" /unseal-script/unseal-output.txt | awk '{print $4}')
done

vault login $(grep "Initial Root Token:" /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Unseal successfully."

vault status

vault operator raft list-peers