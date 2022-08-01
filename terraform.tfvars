# Cloudflare Functionality
cloudflare_enabled = true

# Cluster Domain
cluster_domain = "cloud.umai.lol"

# Cluster Unique Identifier
cluster_tag = "hks01"

# Hetzner location used for all resources
hcloud_location = "fsn1-dc14"
hcloud_lb_location = "fsn1"

# Type of instance to be used for the leader instance
leader_instance_type = "cpx31"

# Type of instance to be used for worker instances
worker_instance_type = "cpx31"

# Count of how many worker instances to create
worker_instance_count = "3"

# Zone to create the network in
network_zone = "eu-central"

# Network to create for private communication
network_cidr = "10.0.0.0/8"

# Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`.
network_ip_range = "10.0.1.0/24"