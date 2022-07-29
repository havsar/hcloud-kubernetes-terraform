# Create Leader
resource "hcloud_server" "workers" {
  name        = format("worker-%s.%s.%s", count.index + 1, var.cluster_tag, var.cluster_domain)
  count       = var.worker_instance_count
  image       = "centos-7"
  server_type = var.worker_instance_type
  ssh_keys    = [hcloud_ssh_key.root_openssh_public_key.id]
  user_data   = file("${path.module}/files/user-data/worker.tftpl")

  datacenter = var.hcloud_location

  network {
    network_id = hcloud_network.sdn_cidr.id
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      ssh_resource.leader_join_command.result
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = tls_private_key.global_key.private_key_pem
    }
  }


  labels = merge(local.labels, {
    "Role" : "Worker"
  })

  depends_on = [
    hcloud_server.leader,
    ssh_resource.leader_join_command
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