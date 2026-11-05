# Planes Preventivos

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Planes Preventivos |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Muestra las recomendaciones de planes preventivos para la unidad y turno. Puede abrir el mensaje de información de planes del mapa.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación, condicionado por showTogglePlanes, la unidad y la disponibilidad de planesRecomendacionesPoints.

1. Seleccionar unidad y turno con recomendaciones.
2. Activar Planes Preventivos.
3. Revisar los puntos y el mensaje informativo.
4. Desactivar la capa y comprobar su retirada.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad / Turno | Se envían como codigo, cad e id_turno. |
| Planes Preventivos | Controla visibilidad y abre el mensaje cuando se activa. |
| Información planes preventivos | Acceso adicional al mensaje, condicionado por unidad, turno y estado del mapa. |

## 5. Comportamiento y reglas

- La carga usa /optimizacion/geojson_retorno.
- El cliente normaliza NaN en respuestas de texto antes de procesar el GeoJSON.
- El componente aplica filtros por hora cuando existe una hora seleccionada.
- La recomendación preventiva es una funcionalidad distinta de Planes Gescov programados o en ejecución.

## 6. Datos y servicios

`POST /optimizacion/geojson_retorno` con `id_turno`, `codigo` y `cad`. Origen físico y reglas de recomendación del servicio: **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/components/specific/planesRecomendacionesLayer/PlanesRecomendacionesLayer.js:195` — carga.
- `src/components/ToggleOptions/ToggleOptions.js:386` — activación.
- `src/pages/MapPage.js:10999` — mensaje informativo de planes preventivos.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Contrastar recomendaciones, fecha, turno y hora con la respuesta del servicio.
- [ ] Comprobar que activar el control abre el mensaje correspondiente.
- [ ] Distinguir recomendaciones de planes operativos GESCOV.

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

[Volver al índice del mapa](../../README.md).
