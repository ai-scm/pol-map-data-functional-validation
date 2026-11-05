# Sugerencia Personal de Apoyo

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Sugerencia Personal de Apoyo |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Representa puntos sugeridos de apoyo derivados de la intensidad de anticipación o de la cantidad de apoyos informada por el servicio.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación; exige unidad, turno y puntosApoyoPolygon.

1. Seleccionar unidad y turno con datos de apoyo.
2. Activar Sugerencia Personal de Apoyo.
3. Revisar los puntos y su ubicación respecto de los polígonos de referencia.
4. Desactivar el control.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad / Turno / Hora | Delimitan la consulta de apoyo. |
| Sugerencia Personal de Apoyo | Muestra u oculta los puntos devueltos y filtrados. |

## 5. Comportamiento y reglas

- Se consulta /puntos_apoyo con id_turno, id_unidad, sigla y hora.
- El cliente convierte intensity_val desde la escala 0–255 a porcentaje y conserva intensidad >= 80 %.
- Cuando no hay intensidad definida conserva apoyos entre 1 y 2.
- Los puntos se construyen con centroid_x y centroid_y y se recortan a los polígonos de referencia proporcionados al componente.

## 6. Datos y servicios

`POST /puntos_apoyo`. Estas reglas describen la selección del cliente; la metodología para calcular intensidad o asignar personal en el servicio está **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/components/specific/puntosDeApoyoLayer/PuntosApoyoLayer.js:30` — consulta; línea 75 — umbral de intensidad.
- `src/components/ToggleOptions/ToggleOptions.js:338` — disponibilidad del control.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comprobar casos por debajo y en el umbral del 80 %.
- [ ] Comprobar la alternativa por apoyos cuando falta intensidad.
- [ ] Confirmar centroides y exclusión de puntos fuera de los polígonos de referencia.

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
