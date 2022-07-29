terraform {
    backend "remote" {
        organization = "nicholaspearson"

        workspaces {
            name = "nicholaspearson"
        }
    }
}