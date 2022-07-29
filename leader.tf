# Create Leader
resource "hcloud_server" "leader" {
  name        = format("leader-%s.%s.%s", count.index+1, var.cluster_tag, var.cluster_domain)
  count       = 1
  image       = "centos-7"
  server_type = var.leader_instance_type
  ssh_keys    = [hcloud_ssh_key.root_openssh_public_key.id]
  user_data   = "${file("${path.module}/files/user-data/leader.tftpl")}"
   
  datacenter  = var.hcloud_location

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
      "echo 'Completed cloud-init, starting cluster pre-flight checks/init...'",
      "kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p /root/.kube",
      "cp -i /etc/kubernetes/admin.conf /root/.kube/config",
      "chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml",
      "kubectl -n kube-system create secret generic hcloud --from-literal=token=${var.hcloud_token}",
      "kubectl apply -f  https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/latest/download/ccm.yaml",
      "kubectl -n kube-system create secret generic hcloud-csi --from-literal=token=${var.hcloud_token}",
      "kubectl apply -f https://raw.githubusercontent.com/hetznercloud/csi-driver/v1.6.0/deploy/kubernetes/hcloud-csi.yml"
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = tls_private_key.global_key.private_key_pem
    }
  }


  labels = merge(local.labels, {
    "Role" : "Leader"
  })

  depends_on = [
    hcloud_network_subnet.sdn_cidr_subnet
  ]
  
}

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

resource "ssh_resource" "leader_join_command" {
  host        = hcloud_server.leader[0].ipv4_address
  user        = "root"
  private_key = tls_private_key.global_key.private_key_pem

  commands = [
    "kubeadm token create --print-join-command"
  ]

  depends_on = [
    hcloud_server.leader
  ]
}