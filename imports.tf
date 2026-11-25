# Los 4 recursos ya existían (se crearon a mano en los bloques 2 y 4).
# Estos bloques le dicen a Terraform que los ADOPTE en lugar de crearlos de nuevo.
# En el primer "terraform plan" aparecen como "will be imported".

import {
  for_each = var.ambientes
  to       = cloudflare_d1_database.pizzeria[each.key]
  id       = "${var.account_id}/${var.d1_ids_existentes[each.key]}"
}

import {
  for_each = var.ambientes
  to       = cloudflare_pages_project.pizzeria_web[each.key]
  id       = "${var.account_id}/pizzeria-web-${each.key}"
}
