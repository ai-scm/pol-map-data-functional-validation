# 19. Tableros de Monitoreo

## Propósito

Centraliza dashboards para observar calidad y oportunidad de datos, adopción de la plataforma, salud de componentes, pedidos SECAD y procesos de ingesta.

## Navegación funcional

`Home > Tableros de Monitoreo`

No se versionan identificadores técnicos del dashboard ni URL internas. La ruta funcional visible es la referencia estable.

## Submódulos inventariados

| Submódulo | Tipo | Hojas detectadas en análisis | Hojas publicadas | Documentación |
|---|---|---:|---:|---|
| Métricas de Uso de la Plataforma | Dashboard con hojas | 5 | 2 | [`metricas-de-uso-de-la-plataforma`](metricas-de-uso-de-la-plataforma/README.md) |
| Tablero Monitoreo Pedidos SECAD v3.0 | Vista única | 1 | 1 | [`tablero-monitoreo-pedidos-secad-v3-0`](tablero-monitoreo-pedidos-secad-v3-0/README.md) |
| Última actualización de datos migrados | Dashboard con hojas | 6 | 5 | [`ultima-actualizacion-de-datos-migrados`](ultima-actualizacion-de-datos-migrados/README.md) |
| Tablero de control ingesta datos planta nacional | Dashboard con hojas | 2 | 2 | [`tablero-de-control-ingesta-datos-planta-nacional`](tablero-de-control-ingesta-datos-planta-nacional/README.md) |

> Los submódulos «Datos Sin Limpiar (SECAD)» y «Monitoreo Componentes» se retiraron de este módulo tras la revisión del `Inventario_Dashboards_IAPOL.xlsx`: correspondían a dashboards ya documentados en otros submódulos. El submódulo de certificaciones se documenta en [`certificacion-iapol`](certificacion-iapol/documentacion-tecnica.md), con el nombre funcional «Certificación IAPOL» tal como aparece en IAPOL.

## Documentos comunes

- [`documentacion-tecnica.md`](documentacion-tecnica.md): activos, fuentes, filtros, fórmulas y asuntos pendientes.
- [`validaciones.md`](validaciones.md): procedimiento funcional, de datos y criterios de aceptación.
- [`ejecucion-validaciones-2026-09-04.md`](ejecucion-validaciones-2026-09-04.md): resultados funcionales, bloqueos y hallazgos de la ejecución realizada.

## Estado del inventario

| Elemento | Estado observado el 2026-09-04 | Alcance |
|---|---|---|
| Navegación al módulo y submódulos vigentes | Disponible | Verificación visual de acceso y carga del contenedor. |
| Hojas publicadas | Inventariadas | Hojas visibles en los dashboards de Quick de los submódulos vigentes. |
| Hojas internas de análisis | Inventariadas parcialmente | Métricas contiene tres hojas no publicadas. |
| Validación Policía vs. Athena | Pendiente | Requiere consultas autorizadas con el mismo corte y reglas de negocio. |

## Convenciones aplicadas

- Directorios y archivos en minúsculas, sin tildes ni caracteres especiales.
- Guiones medios para separar palabras.
- Nombre funcional visible como base del directorio.
- Un `README.md` por submódulo y por hoja visible.
