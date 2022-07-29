# hcloud-kubernetes-terraform
Standup a Kubernetes Cluster (Single Leader) with Terraform

### Deployment
Export the following variables:
```
export TF_VAR_hcloud_token=""
export TF_VAR_cloudflare_token=""
export TF_VAR_cloudflare_zone_id=""
```

Run Terraform Plan:
`terraform plan`

Run Terraform Apply
`terraform apply`