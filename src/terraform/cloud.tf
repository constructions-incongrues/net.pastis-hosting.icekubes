terraform {
  cloud {
    organization = "pastis-hosting"
    workspaces {
      tags = ["ph"]
    }
  }
}