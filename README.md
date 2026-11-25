# 🍕 Pizzería — Infraestructura

Infraestructura como código del proyecto final de **Infraestructura para el Desarrollo Continuo** (ITESO), con **Terraform** y el provider de **Cloudflare**.

## Qué administra Terraform

| Recurso | dev | prod |
|---|---|---|
| Base de datos D1 (`cloudflare_d1_database`) | `pizzeria-db-dev` | `pizzeria-db-prod` |
| Proyecto de Pages (`cloudflare_pages_project`) | `pizzeria-web-dev` | `pizzeria-web-prod` |

Los 4 recursos se crearon primero con Wrangler y después se **importaron** a Terraform (`imports.tf`), sin recrearlos.

**Terraform crea los recursos; el pipeline publica el código.** Terraform no administra:

- El código de la API (Workers `pizzeria-api-dev` y `pizzeria-api-prod`): lo publica el pipeline de [pizzeria-api](https://github.com/pizzeria-iteso/pizzeria-api).
- Las tablas y el menú de las bases: los crean las migraciones de Wrangler en el mismo pipeline.
- Las páginas del frontend: las publica el pipeline de [pizzeria-web](https://github.com/pizzeria-iteso/pizzeria-web).

## Protecciones

- `prevent_destroy` en los 4 recursos: si un cambio implicara borrar o reemplazar uno, Terraform se detiene con error. Reemplazar una base D1 borra todos sus datos.
- Antes de cada `apply` se revisa el `plan`: si dice `destroy` o `must be replaced`, **no se aplica**.
- Nunca se usa `terraform destroy`.

## Archivos

| Archivo | Contenido |
|---|---|
| `versions.tf` | Versión de Terraform y del provider de Cloudflare |
| `variables.tf` | Cuenta, ambientes e IDs de las bases existentes |
| `main.tf` | Los recursos: bases D1 y proyectos de Pages |
| `imports.tf` | Importación de los recursos que ya existían |
| `outputs.tf` | IDs de las bases y URLs de Pages |

## Variables

| Variable | Descripción | Valor por defecto |
|---|---|---|
| `account_id` | ID de la cuenta de Cloudflare | cuenta del proyecto |
| `ambientes` | Ambientes que se crean | `["dev", "prod"]` |
| `d1_ids_existentes` | IDs de las bases D1 que se importan | IDs de dev y prod |

## Credenciales

El token **no** está en el repositorio. Terraform lo lee de la variable de entorno `CLOUDFLARE_API_TOKEN`.
Token personalizado con permisos mínimos: **D1 (Edit)** y **Cloudflare Pages (Edit)**, solo para la cuenta del proyecto.

En Git Bash (el token no se muestra ni queda en el historial):

```bash
read -s -p "Token de Cloudflare: " CLOUDFLARE_API_TOKEN && export CLOUDFLARE_API_TOKEN && echo
```

## Uso

```bash
terraform init       # descarga el provider de Cloudflare
terraform validate   # revisa que la configuración sea válida
terraform plan       # muestra qué haría, SIN cambiar nada
terraform apply      # aplica los cambios (pide confirmación con "yes")
terraform output     # muestra los IDs de las bases y las URLs
```

## State

El state (`terraform.tfstate`) es **local** y **no se sube al repositorio** (está en `.gitignore`): guarda IDs y detalles de la cuenta.
Se conserva en la computadora de quien administra la infraestructura. Si se pierde, se recupera volviendo a importar los recursos con `terraform plan` y `terraform apply` (los bloques de `imports.tf`).

## Proyecto

- API: [pizzeria-api](https://github.com/pizzeria-iteso/pizzeria-api)
- Frontend: [pizzeria-web](https://github.com/pizzeria-iteso/pizzeria-web)
- Tablero: [Pizzería](https://github.com/orgs/pizzeria-iteso/projects/1)
- Wiki: [pizzeria-infra/wiki](https://github.com/pizzeria-iteso/pizzeria-infra/wiki)
