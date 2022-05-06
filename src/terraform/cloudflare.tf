variable "cloudflare_api_token" {
  description = "cloudflare api token"
}
variable "cloudflare_zone_id" {
  description = "cloudflare zone"
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
