# 19. Tableros de Monitoreo

## Propósito

Centraliza dashboards para observar calidad y oportunidad de datos, adopción de la plataforma, salud de componentes, pedidos SECAD y procesos de ingesta.

## Navegación funcional

`Home > Tableros de Monitoreo`

No se versionan identificadores técnicos del dashboard ni URL internas. La ruta funcional visible es la referencia estable.

## Submódulos inventariados

| Submódulo | Tipo | Hojas detectadas en análisis | Hojas publicadas | Documentación |
|---|---|---:|---:|---|
| Datos Sin Limpiar (SECAD) | Dashboard con hojas | 7 | 7 | [`datos-sin-limpiar-secad`](datos-sin-limpiar-secad/README.md) |
| Métricas de Uso de la Plataforma | Dashboard con hojas | 2 en la definición vigente | 2 | [`metricas-de-uso-de-la-plataforma`](metricas-de-uso-de-la-plataforma/README.md) |
| Monitoreo Componentes | Vista única con contenido personalizado | No verificable | 1 vista externa | [`monitoreo-componentes`](monitoreo-componentes/README.md) |
| Tablero Monitoreo Pedidos SECAD v3.0 | Vista única | 1 | 1 | [`tablero-monitoreo-pedidos-secad-v3-0`](tablero-monitoreo-pedidos-secad-v3-0/README.md) |
| Última actualización de datos migrados | Dashboard con hojas | 6 | 5 | [`ultima-actualizacion-de-datos-migrados`](ultima-actualizacion-de-datos-migrados/README.md) |
| Tablero de control ingesta datos planta nacional | Dashboard con hojas | 2 | 2 | [`tablero-de-control-ingesta-datos-planta-nacional`](tablero-de-control-ingesta-datos-planta-nacional/README.md) |

## Documentos comunes

- [`documentacion-tecnica.md`](documentacion-tecnica.md): activos, fuentes, filtros, fórmulas y asuntos pendientes.
- [`validaciones.md`](validaciones.md): procedimiento funcional, de datos y criterios de aceptación.
- [`ejecucion-validaciones-2026-09-04.md`](ejecucion-validaciones-2026-09-04.md): resultados funcionales, bloqueos y hallazgos de la ejecución realizada.

La ejecución del 2026-09-04 conserva valor histórico, pero sus resultados de Métricas de Uso corresponden al dashboard retirado. El dashboard vigente requiere una nueva ejecución.

## Estado del inventario

| Elemento | Estado observado el 2026-09-04 | Alcance |
|---|---|---|
| Navegación al módulo y seis submódulos | Revalidación parcial pendiente | Los cinco accesos restantes conservan la verificación del 2026-09-04; Métricas de Uso cambió de dashboard. |
| Hojas publicadas | Inventariadas | La definición vigente de Métricas contiene dos hojas y 16 visuales; su carga en la aplicación está pendiente de repetir. |
| Hojas internas de análisis | Inventariadas parcialmente | Las tres hojas internas documentadas anteriormente en Métricas pertenecían al dashboard retirado. No se recibió el análisis editable del dashboard vigente. |
| Monitoreo Componentes | Bloqueado parcialmente | El contenido personalizado solicita autenticación de Google. |
| Validación Policía vs. Athena | Pendiente | Requiere consultas autorizadas con el mismo corte y reglas de negocio. |

## Convenciones aplicadas

- Directorios y archivos en minúsculas, sin tildes ni caracteres especiales.
- Guiones medios para separar palabras.
- Nombre funcional visible como base del directorio.
- Un `README.md` por submódulo y por hoja visible.
