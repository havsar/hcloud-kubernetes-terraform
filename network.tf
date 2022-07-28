resource "hcloud_network" "sdn_cidr" {
  name     = "${var.cluster_tag}-sdn"
  ip_range = var.network_cidr
}

resource "hcloud_network_subnet" "sdn_cidr_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.sdn_cidr.id
  network_zone = var.network_zone
  ip_range     = var.network_ip_range
}