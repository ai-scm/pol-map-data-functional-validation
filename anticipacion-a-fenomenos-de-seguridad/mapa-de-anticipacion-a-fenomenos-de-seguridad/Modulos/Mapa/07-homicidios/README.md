# Homicidios

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Homicidios |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Permite consultar los homicidios del día y cargar un análisis por rango de fechas con puntos, áreas y recorridos de patrullas cuando el servicio los suministra.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

El acceso muestra el texto Homicidios del día y el panel se titula Homicidios. Puede consultar el listado nacional; el análisis territorial usa la unidad seleccionada cuando está disponible.

1. Abrir Homicidios del día desde el icono de calavera.
2. Usar Homicidios del Día para consultar el listado o su interruptor para representar puntos.
3. Para análisis, elegir fecha inicial y final y pulsar Cargar Análisis de Homicidios.
4. Consultar los detalles y recorridos disponibles y limpiar el análisis al terminar.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Homicidios del Día | Botón del listado y control de puntos. |
| Fecha inicial / Fecha final | Intervalo para el análisis, validado antes de habilitar la carga. |
| Cargar Análisis de Homicidios | Solicita el resultado del intervalo. |
| Detalle y recorridos | Permite consultar presencia y desplazamientos asociados cuando existen en la respuesta. |

## 5. Comportamiento y reglas

- La API de día dispone de consulta nacional y consulta por sigla/unidad.
- La API de análisis recibe fecha_inicio y fecha_fin; el recorte espacial a la unidad se realiza en el cliente.
- El código usa los polígonos reales de la unidad para el recorte del análisis.
- La representación de recorridos depende del contenido devuelto para el homicidio; no se garantiza para todos los eventos.

## 6. Datos y servicios

Consultas del cliente: `GET homicidios` y `POST homicidios/sigla` relativos a la base DBOPER; `GET /analisis-homicidios?fecha_inicio=…&fecha_fin=…` para el análisis. La documentación histórica identifica `USR_PMU.V_HOMICIDIO_2024` para el día; esta revisión no volvió a consultar Oracle ni confirmó que el servicio actual siga usando esa vista.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/homicidiosApi.js:5` — consultas de día y análisis.
- `src/pages/MapPage.js:3150` — intervalo de análisis; línea 11638 — panel.
- `src/pages/MapPagePopups/HomicidiosPopup.js` — detalles y áreas.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar el listado del día y sus puntos con el servicio.
- [ ] Validar el recorte territorial del análisis para una unidad con polígonos.
- [ ] Probar intervalo invertido, ausencia de eventos y errores de carga.
- [ ] Contrastar recorridos y horas con la fuente antes de interpretarlos.

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

- [Prueba histórica y capturas existentes](homicidios_del_dia.md).

[Volver al índice del mapa](../README.md).
