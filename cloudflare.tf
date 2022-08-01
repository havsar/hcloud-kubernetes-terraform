resource "cloudflare_record" "leader_dns_record" {
  count   = 1
  zone_id = var.cloudflare_zone_id
  name    = hcloud_server.leader[count.index].name
  value   = hcloud_server.leader[count.index].ipv4_address
  type    = "A"
  ttl     = 60

  depends_on = [
    hcloud_server.leader
  ]
}

resource "cloudflare_record" "worker_dns_record" {
  count   = var.worker_instance_count
  zone_id = var.cloudflare_zone_id
  name    = hcloud_server.workers[count.index].name
  value   = hcloud_server.workers[count.index].ipv4_address
  type    = "A"
  ttl     = 60

  depends_on = [
    hcloud_server.workers
  ]
}