variable "account_id" {
  description = "ID de la cuenta de Cloudflare del proyecto (no es secreto)"
  type        = string
  default     = "52b4bb678526e2618b5b021c16b87b74"
}

variable "ambientes" {
  description = "Ambientes del proyecto. Por cada uno hay una base D1 y un proyecto de Pages."
  type        = set(string)
  default     = ["dev", "prod"]
}

# IDs de las bases D1 que ya existían antes de Terraform (se crearon con Wrangler).
# Solo se usan para importarlas; Terraform no las vuelve a crear.
variable "d1_ids_existentes" {
  description = "ID de la base D1 existente de cada ambiente"
  type        = map(string)
  default = {
    dev  = "8e3f886c-ec17-4215-bfa2-a4d04deb1de2"
    prod = "7d7a4a10-2d64-4f70-92a7-d6f7b8e287c4"
  }
}
