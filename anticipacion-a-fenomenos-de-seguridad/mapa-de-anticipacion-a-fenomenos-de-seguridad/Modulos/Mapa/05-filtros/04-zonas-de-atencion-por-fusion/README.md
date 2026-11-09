# Zonas de atención por Fusión

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Zonas de atención por Fusión |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Muestra las zonas resultantes de agrupar polígonos de atención de acuerdo con la unidad, turno y cantidad de patrullas seleccionados.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación. El control aparece cuando cuadrantesPolygon tiene elementos.

1. Seleccionar unidad y turno con datos de optimización.
2. Seleccionar la cantidad de patrullas cuando el mapa lo permita.
3. Activar Zonas de atención por Fusión y revisar las áreas.
4. Cambiar el contexto y comprobar la actualización.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad / Turno / Hora | Delimitan la optimización. |
| Número de patrullas | Se envía como numero_cuadrantes para la unidad. |
| Zonas de atención por Fusión | Alterna la visibilidad del resultado. |

## 5. Comportamiento y reglas

- La solicitud incluye unidades con id_unidad y numero_cuadrantes, además de id_turno y hora.
- Las colecciones recibidas se consolidan y se descartan elementos nulos.
- El control Demanda - Zonas por Fusión usa las rutas de una anticipación por demanda seleccionada y debe probarse por separado.

## 6. Datos y servicios

`POST /optimizacion/poligonos_cuadrantes_fusion_v2`. La variante por demanda utiliza `/optimizacion/obtener_optimizacion_by_path` y `/optimizacion/obtener_base_by_path`. Versiones de insumos y ejecución del cálculo: **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:6844` — updateCuadrantes y cuerpo de optimización.
- `src/components/ToggleOptions/ToggleOptions.js:212` — control activo, fuera del bloque histórico comentado.
- `src/components/specific/fusionDemanda/FusionDemanda.js` — variante por demanda.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comprobar el número de patrullas enviado y las geometrías recibidas.
- [ ] Contrastar la variante normal y la variante por demanda sin confundir sus insumos.
- [ ] Verificar que el control cambia realmente la visibilidad.

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

- Se pasa disabled=true a ToggleOption, pero ese componente no recibe ni aplica disabled. Por ello, ese atributo no demuestra que el interruptor esté deshabilitado; requiere prueba en navegador.

[Volver al índice del mapa](../../README.md).
