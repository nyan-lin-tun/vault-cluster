disable_mlock = true

storage "raft" {
  path = "/vault/file"
  node_id = "node1"

  retry_join {
    leader_api_addr = "http://sg-vault-dev-server2:8200"
  }

  retry_join {
    leader_api_addr = "http://sg-vault-dev-server3:8200"
  }
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = true
}

api_addr = "http://vault-server1:8200"
cluster_addr = "http://vault-server1:8201"
cluster_name = "sg-vault-cluster"

ui = true
log_level = "debug"