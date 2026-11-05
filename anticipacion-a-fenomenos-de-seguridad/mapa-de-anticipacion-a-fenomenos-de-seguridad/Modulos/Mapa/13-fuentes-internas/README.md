# Fuentes Internas

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Fuentes Internas |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Agrupa capas registradas en el catálogo dinámico de XCrime y permite activarlas sobre el territorio de la unidad seleccionada. AWS registra nueve entradas internas en la fecha de revisión.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere unidad seleccionada. El cliente pide las categorías disponibles para esa unidad; el catálogo global no garantiza que todas sus capas se muestren para todas las unidades.

1. Seleccionar sigla y unidad.
2. Abrir Fuentes Internas.
3. Completar el filtro temporal de las fuentes que lo usan y pulsar Aplicar filtro.
4. Activar una capa y, cuando corresponda, ajustar los filtros de SIEDCO o de estado IRIS P1.
5. Consultar el detalle y desactivar la capa al terminar.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Día / Rango / Comparación | Filtro compartido para SIEDCO, GESCOV, MTRS, SIRAP y SIMEP. |
| Quitar filtro de fechas | Permite recargar las capas afectadas sin el filtro temporal del cliente. |
| Interruptores | Activan cada capa de la categoría devuelta por el servicio. |
| Filtros SIEDCO | Selección de temáticas y tipos configurados. |
| Estado IRIS P1 | Filtro sobre la propiedad Estado de esa capa. |

## 5. Comportamiento y reglas

- Las categorías se solicitan mediante CategoryList?unidadID; los GeoJSON se leen por identificador de capa y unidad.
- El cliente aplica filtros de fecha y geometría; los contadores pueden representar el resultado filtrado o visible, no el total del archivo nacional.
- Las nueve entradas son Gescov, IRIS P1, MTRS, Microterritorios, SIEDCO I, SIEDCO II, SIEDCO III, SIMEP y SIRAP.
- El catálogo registra SIEDCO I/II/III con shift 1/2/3.
- La capa dinámica Microterritorios y la herramienta de gestión de microterritorios requieren contraste antes de considerarlas equivalentes.

## 6. Datos y servicios

Catálogo confirmado con lectura de `pon_prod_category` y `pon_prod_external_layers`. Solicitudes: `GET /externalLayers/CategoryList?unidadID=…` y `GET /externalLayers/get/{id}?unidadID=…`. Los registros internos apuntan a GeoJSON bajo `Fuentes_externas_geojson/`. El job `pon-prod-xcrime-update-fuentes-internas` terminó SUCCEEDED el 2026-11-03 a las 04:34:24, hora de Bogotá; esto acredita la ejecución, no la integridad de todas las capas.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:5993` — categorías; línea 5197 — lectura por identificador.
- `src/pages/MapPage.js:12065` — panel dinámico; línea 12112 — filtro temporal.
- `src/data/siedcoFiltrosConfig.js` y `src/utils/filtroSiedco.js` — filtros de SIEDCO.
- AWS: lecturas del catálogo y del estado del job el 2026-11-03; detalle en la evidencia común.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar las capas visibles con CategoryList para una unidad concreta.
- [ ] Verificar el filtro temporal sobre el campo de fecha de cada fuente.
- [ ] Contrastar cada GeoJSON con su fuente de Policía y Athena para un mismo corte.
- [ ] Verificar filtros de SIEDCO e IRIS P1 sin perder el filtro territorial.

## 9. Criterios de aceptación

La funcionalidad debe responder a los controles documentados, representar el ámbito territorial y temporal solicitado y retirar sus elementos al desactivarse o limpiarse. La aceptación exige ejecutar las comprobaciones anteriores y registrar fecha, unidad, filtros, cantidades y diferencias justificadas. Un resultado vacío y un error del servicio deben distinguirse durante la prueba.

## 10. Resultado y pendientes

| Comprobación | Resultado |
|---|---|
| Presencia y lógica en el código publicado | Confirmado por revisión estática |
| Navegación y representación en navegador | No ejecutado |
| Comparación de registros Policía / servicio / mapa | No ejecutado |
| Fuente física no indicada expresamente en esta ficha | Pendiente por confirmar |

La revisión del código describe el comportamiento implementado. No acredita por sí sola disponibilidad del servicio, permisos del usuario ni igualdad de registros.

## 11. Documentación relacionada

- [Gescov](Gescov/README.md).
- [MTRS](MTRS/README.md).
- [SIEDCO](SIEDCO/README.md).
- [SIMEP](SIMEP/README.md).
- [SIRAP](SIRAP/README.md).
- [IRIS P1](IRISP1/README.md).

[Volver al índice del mapa](../README.md).

## Registro interno consultado en AWS

| Capa | Clave relativa del archivo | Turno del catálogo |
|---|---|---|
| Gescov | `Fuentes_externas_geojson/Gescov/Gescov.geojson` | No indicado |
| IRIS P1 | `Fuentes_externas_geojson/General_iris/IrisP1.geojson` | No indicado |
| MTRS | `Fuentes_externas_geojson/Mtrs_riesgo_ubicacion/v_mtrs_riesgo_ubicacion.geojson` | No indicado |
| Microterritorios | `Fuentes_externas_geojson/Microterritorios/microterriorios.geojson` | No indicado |
| SIEDCO I | `Fuentes_externas_geojson/Disec/DisecDelitosTurno1.geojson` | 1 |
| SIEDCO II | `Fuentes_externas_geojson/Disec/DisecDelitosTurno2.geojson` | 2 |
| SIEDCO III | `Fuentes_externas_geojson/Disec/DisecDelitosTurno3.geojson` | 3 |
| SIMEP | `Fuentes_externas_geojson/Simep/Simep.geojson` | No indicado |
| SIRAP | `Fuentes_externas_geojson/Sirap/raw_geopol_usr_pmu_servicios_extra.geojson` | No indicado |
