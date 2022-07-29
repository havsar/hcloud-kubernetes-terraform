terraform {
        cloud {
        organization = "nicholaspearson"

        workspaces {
            name = "hcloud-kubernetes-terraform"
        }
    }
}