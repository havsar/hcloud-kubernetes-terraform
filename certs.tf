resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.module}/files/certs/id_rsa"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/files/certs/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Temporary key pair used for SSH accesss
resource "hcloud_ssh_key" "root_openssh_public_key" {
  name       = "${var.cluster_tag}-instance-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}
