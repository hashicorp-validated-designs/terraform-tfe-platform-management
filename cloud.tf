terraform {
  cloud {
    organization = "mullen-hashi" # update to your organization name

    workspaces {
      name = "hcptf-top-level-mgmt"
    }
  }
}