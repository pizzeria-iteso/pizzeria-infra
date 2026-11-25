# Versiones de Terraform y del provider de Cloudflare
terraform {
  required_version = ">= 1.7"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.29"
    }
  }
}

# El token NO va aquí: se lee de la variable de entorno CLOUDFLARE_API_TOKEN
provider "cloudflare" {}
