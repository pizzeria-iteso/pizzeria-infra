# Recursos de Cloudflare que administra Terraform: una base D1 y un proyecto de Pages por ambiente.
#
# Qué NO administra Terraform (lo publica el pipeline de cada repo):
#   - El código de la API (Workers pizzeria-api-dev / pizzeria-api-prod): pizzeria-api/.github/workflows/api.yml
#   - Las tablas y el menú de las bases (migraciones de Wrangler): pizzeria-api/migrations
#   - Las páginas publicadas en Pages: pizzeria-web/.github/workflows/web.yml

# ---------- Bases de datos D1 ----------

resource "cloudflare_d1_database" "pizzeria" {
  for_each = var.ambientes

  account_id = var.account_id
  name       = "pizzeria-db-${each.key}"

  # Igual al valor que ya tiene Cloudflare: así el plan no ve diferencias
  read_replication = {
    mode = "disabled"
  }

  # Candado: si un cambio implicara borrar o reemplazar la base, Terraform se detiene con error.
  # Reemplazar una base D1 borra todos sus datos (pedidos y menú).
  lifecycle {
    prevent_destroy = true
  }
}

# ---------- Proyectos de Cloudflare Pages ----------

resource "cloudflare_pages_project" "pizzeria_web" {
  for_each = var.ambientes

  account_id        = var.account_id
  name              = "pizzeria-web-${each.key}"
  production_branch = "main"

  lifecycle {
    prevent_destroy = true
  }
}
