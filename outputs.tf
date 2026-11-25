output "d1_bases" {
  description = "Nombre e ID de la base D1 de cada ambiente (los IDs van en pizzeria-api/wrangler.jsonc)"
  value = {
    for ambiente, base in cloudflare_d1_database.pizzeria : ambiente => {
      nombre = base.name
      id     = base.id
    }
  }
}

output "pages_urls" {
  description = "URL pública del frontend en cada ambiente"
  value = {
    for ambiente, proyecto in cloudflare_pages_project.pizzeria_web : ambiente => "https://${proyecto.subdomain}"
  }
}
