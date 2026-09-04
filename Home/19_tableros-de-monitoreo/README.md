# 19. Tableros de Monitoreo

## Propósito

Centraliza dashboards para observar calidad y oportunidad de datos, adopción de la plataforma, salud de componentes, pedidos SECAD y procesos de ingesta.

## Navegación funcional

`Home > Tableros de Monitoreo`

No se versionan identificadores técnicos del dashboard ni URL internas. La ruta funcional visible es la referencia estable.

## Submódulos inventariados

| Submódulo | Tipo | Hojas visibles | Documentación |
|---|---|---:|---|
| Datos Sin Limpiar (SECAD) | Dashboard con hojas | 7 | [`datos-sin-limpiar-secad`](datos-sin-limpiar-secad/README.md) |
| Métricas de Uso de la Plataforma | Dashboard con hojas | 2 | [`metricas-de-uso-de-la-plataforma`](metricas-de-uso-de-la-plataforma/README.md) |
| Monitoreo Componentes | Vista única con contenido personalizado | 1 vista | [`monitoreo-componentes`](monitoreo-componentes/README.md) |
| Tablero Monitoreo Pedidos SECAD v3.0 | Vista única | 1 vista | [`tablero-monitoreo-pedidos-secad-v3-0`](tablero-monitoreo-pedidos-secad-v3-0/README.md) |
| Última actualización de datos migrados | Dashboard con hojas | 5 | [`ultima-actualizacion-de-datos-migrados`](ultima-actualizacion-de-datos-migrados/README.md) |
| Tablero de control ingesta datos planta nacional | Dashboard con hojas | 2 | [`tablero-de-control-ingesta-datos-planta-nacional`](tablero-de-control-ingesta-datos-planta-nacional/README.md) |

## Documentos comunes

- [`validaciones.md`](validaciones.md): procedimiento funcional, de datos y criterios de aceptación.
- [`registro-resultados.md`](registro-resultados.md): plantilla para cada ejecución.

## Estado del inventario

| Elemento | Estado observado el 2026-09-04 | Alcance |
|---|---|---|
| Navegación al módulo y seis submódulos | Disponible | Verificación visual de acceso y carga del contenedor. |
| Hojas de QuickSight | Inventariadas | 16 hojas visibles en cuatro dashboards. |
| Monitoreo Componentes | Bloqueado parcialmente | El contenido personalizado solicita autenticación de Google. |
| Validación Policía vs. Athena | Pendiente | Requiere consultas autorizadas con el mismo corte y reglas de negocio. |
| Validación de filtros y cifras | Pendiente | Debe ejecutarse y registrarse por periodo de prueba. |

## Convenciones aplicadas

- Directorios y archivos en minúsculas, sin tildes ni caracteres especiales.
- Guiones medios para separar palabras.
- Nombre funcional visible como base del directorio.
- Prefijo `19_` para el módulo, correspondiente a su posición observada en el menú principal.
- Un `README.md` por submódulo y por hoja visible.
