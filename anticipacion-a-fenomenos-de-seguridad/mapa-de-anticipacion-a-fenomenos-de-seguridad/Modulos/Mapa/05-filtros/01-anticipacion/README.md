# Anticipación

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Anticipación |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Muestra u oculta los polígonos de anticipación para la unidad y el turno seleccionados. Las propiedades de predicción se procesan para representar el nivel de riesgo mediante colores.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación. El control aparece cuando prediccionPolygon contiene elementos.

1. Seleccionar unidad, fecha y turno.
2. Abrir Capas de anticipación y activar Anticipación.
3. Revisar polígonos, colores y detalle; desactivar para ocultar la capa.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad / Turno / Hora | Delimitan la consulta de anticipación. |
| Anticipación | Controla la visibilidad de los polígonos. |

## 5. Comportamiento y reglas

- El cliente solicita la predicción usando id_unidad, id_turno y hora; la hora puede ser nula para consultar el turno.
- La respuesta se procesa con processPrediccionData.
- Se retiran polígonos de unidades padre cubiertos por sus descendientes mediante prediccionUnidades, evitando que oculten sus colores.

## 6. Datos y servicios

`POST /prediccion` entrega el GeoJSON al mapa. Los nombres de tablas, la versión del modelo y el archivo exacto utilizados en una consulta concreta están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:6709` — carga y tratamiento territorial.
- `src/components/ToggleOptions/ToggleOptions.js:41` — control Anticipación.
- `src/utils/processPrediccionData.js` y `src/utils/prediccionUnidades.js` — procesamiento.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Contrastar fecha y turno de los polígonos con la respuesta del servicio.
- [ ] Comprobar que una unidad padre no tapa los polígonos de sus dependientes.
- [ ] Verificar visibilidad y leyenda para los niveles devueltos por el servicio.

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
