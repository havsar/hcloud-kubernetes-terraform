terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.35.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = "2.1.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "hcloud" {
  token = var.hcloud_token
}


