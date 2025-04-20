#!/bin/sh

vault server -config=/vault/config/config.hcl &

sleep 10

# raft join vault-server1
vault operator raft join http://vault-server1:8200

echo "Raft joined successfully"

# unseal vault
for i in $(seq 1 3); do
    vault operator unseal $(grep "Unseal Key $i:" /unseal-script/unseal-output.txt | awk '{print $4}')
    sleep 1
done

vault login $(grep "Initial Root Token:" /unseal-script/unseal-output.txt | awk '{print $4}')

echo "Unseal successfully."

vault status
vault operator raft list-peers