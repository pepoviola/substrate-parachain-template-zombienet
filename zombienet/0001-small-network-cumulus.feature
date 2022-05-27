Description: Small Network test
Network: ./0001-small-network-cumulus.toml
Creds: config

# to run this file: ./zombienet-linux -p kubernetes test zombienet/z04-small-network.feature

# well know functions
alice: is up
bob: is up
alice: parachain 2000 is registered within 225 seconds

# logs
bob: log line matches glob "*rted #1*" within 10 seconds
bob: log line matches "Imported #[0-9]+" within 10 seconds
bob: log line matches "Imported new block." within 10 seconds

alice: parachain 2000 block height is at least 6 within 250 seconds

# metrics
alice: reports node_roles is 4
alice: reports sub_libp2p_is_major_syncing is 0