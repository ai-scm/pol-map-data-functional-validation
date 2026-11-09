# Porcentaje permanencia

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Porcentaje permanencia |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Representa etiquetas de ocupación o permanencia asociadas a los polígonos de anticipación, con selección del grupo de personal y formato porcentual o de tiempo.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación; requiere predicciones con elementos. La opción de formato aparece al activar las etiquetas.

1. Cargar anticipación para la unidad y turno.
2. Elegir Total, Comandantes, Patrullas de vigilancia u Otros.
3. Alternar entre porcentaje y tiempo hh:mm.
4. Desactivar las etiquetas para retirarlas del mapa.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Total / Comandantes / Patrullas de vigilancia / Otros | Selecciona un único tipo de ocupación mostrado. |
| Mostrar como tiempo (hh:mm) | Alterna entre los campos de tiempo y porcentaje. |
| Interruptor del grupo activo | Activa o desactiva las etiquetas. |

## 5. Comportamiento y reglas

- El tipo activo se guarda en tipoOcupacionSeleccionado; los grupos son alternativas para una misma capa de etiquetas.
- El texto toma las propiedades ocupacion total, ocupacion comandantes, ocupacion vigilantes u ocupacion otros, y sus variantes terminadas en tiempo.
- El frontend selecciona las propiedades de la respuesta; la fórmula de cálculo en origen y su denominador están Pendiente por confirmar.

## 6. Datos y servicios

Las etiquetas leen propiedades del GeoJSON de anticipación. No se encontró una consulta independiente al activar estos controles.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/components/ToggleOptions/ToggleOptions.js:62` — grupos y formato.
- `src/pages/MapPage.js:2656` — cambio de grupo; línea 10250 — selección de propiedades del texto.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar cada etiqueta con la propiedad correspondiente de la respuesta.
- [ ] Comprobar que cambiar de grupo no acumula varias etiquetas.
- [ ] Confirmar en el servicio la unidad, el denominador y la ventana de cálculo antes de validar porcentajes.

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
