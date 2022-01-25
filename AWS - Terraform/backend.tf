terraform {
  backend "remote" {
    organization = "groupefyb"

    workspaces {
      name = "groupefyb"
    }
  }
}