output "kubeconfig" {
  value = ssh_resource.leader_kubeconfig.result
}