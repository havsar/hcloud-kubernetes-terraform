variable "hcloud_token" {
  sensitive = true
}

variable "cloudflare_token" {
  sensitive = true
}

variable "cloudflare_zone_id" {
  sensitive = true
  description = "Cloudflare website zone id"
}

variable "cluster_domain" {
  type        = string
  description = "Cluster Domain suffix e.g. cloud.domain.com"
}

variable "cluster_tag" {
  type        = string
  description = "Unique cluster identifier"
}

variable "hcloud_location" {
  type        = string
  description = "Hetzner location used for all resources"
  default     = "fsn1-dc14"
}

variable "leader_instance_type" {
  type        = string
  description = "Type of instance to be used for all instances"
  default     = "cx21"
}

variable "worker_instance_type" {
  type        = string
  description = "Type of instance to be used for all instances"
  default     = "cx21"
}

variable "worker_instance_count" {
  type        = number
  description = "How many workers to create."
  default     = "3"
}

variable "network_zone" {
  type        = string
  description = "Zone to create the network in"
  default     = "eu-central"
}

variable "network_cidr" {
  type        = string
  description = "Network to create for private communication"
  default     = "10.0.0.0/8"
}

variable "network_ip_range" {
  type        = string
  description = "Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`."
  default     = "10.0.1.0/24"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}