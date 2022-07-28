# Create Leader
resource "hcloud_server" "leader" {
  name        = format("leader.%s.%s", var.cluster_tag, var.cluster_domain)
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
      "echo 'Completed cloud-init!'",
      "kubeadm init --pod-network-cidr=10.244.0.0/16",
      "mkdir -p /root/.kube",
      "cp -i /etc/kubernetes/admin.conf /root/.kube/config",
      "chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      private_key = tls_private_key.global_key.private_key_pem
    }
  }


  labels = local.labels

  depends_on = [
    hcloud_network_subnet.sdn_cidr_subnet
  ]
  
}

resource "ssh_resource" "leader_join_command" {
  host        = hcloud_server.leader.ipv4_address
  user        = "root"
  private_key = tls_private_key.global_key.private_key_pem

  commands = [
    "kubeadm token create --print-join-command"
  ]

  depends_on = [
    hcloud_server.leader
  ]
}