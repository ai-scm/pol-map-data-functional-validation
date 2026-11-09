# Zonas de atención actuales

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Zonas de atención actuales |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Visualiza la delimitación actual de las zonas de atención de la unidad seleccionada.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación; exige unidad y un GeoJSON de zonas actuales con elementos.

1. Seleccionar una unidad con geometría disponible.
2. Activar Zonas de atención actuales.
3. Comparar los límites y nombres con la respuesta del servicio.
4. Desactivar la capa.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad | Envía id_unidad al servicio. |
| Zonas de atención actuales | Muestra u oculta los polígonos actuales. |

## 5. Comportamiento y reglas

- La consulta se realiza con la unidad seleccionada.
- Los polígonos se cargan en cuadrantesActualesGeojsonData y se dibujan sus nombres.
- La delimitación actual y las zonas calculadas por fusión son resultados distintos.

## 6. Datos y servicios

`POST /optimizacion/poligonos_actuales` con `id_unidad`. Fuente geográfica y fecha de vigencia: **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:6660` — updateCuadrantesActuales.
- `src/components/ToggleOptions/ToggleOptions.js:264` — control y condición de datos.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar geometría y número de zonas con la respuesta para la misma unidad.
- [ ] Verificar cambios de unidad y retirada de polígonos anteriores.
- [ ] Confirmar con el responsable la fecha de vigencia de los límites.

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
