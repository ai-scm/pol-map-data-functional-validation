# Delitos materializados

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Delitos materializados |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Abre una ventana de análisis de delitos registrados y actividad operativa por fecha, turno y niveles de riesgo, con tablas, indicadores y análisis disponibles en la respuesta.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación; requiere unidad. El control abre un modal mediante una flecha, no un interruptor.

1. Seleccionar unidad y abrir Capas de anticipación.
2. Pulsar el botón de Delitos materializados.
3. Elegir fecha y turno y revisar los resultados.
4. Consultar las condiciones, limitaciones y detalle antes de interpretar los indicadores.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Fecha | Se descompone en year, month y day. |
| Turno 1 / 2 / 3 | Número de turno enviado al servicio. |
| Unidad | Aporta sigla, unidades_hijas y nivel_agregacion. |
| Mostrar análisis | Permite consultar el análisis presentado por el modal. |

## 5. Comportamiento y reglas

- Las unidades hoja del árbol se recolectan para construir unidades_hijas.
- El tipo numérico 5 genera nivel_agregacion=sigla; los demás casos usan unidades.
- La interfaz distingue zonas crítica, alta, media y baja.
- Las condiciones de materialización se presentan como hipótesis que requieren validación; no constituyen una demostración causal.

## 6. Datos y servicios

`POST /consultar` mediante `Delitos_Materializados_API_URL`. Cuerpo: `year`, `month`, `day`, `sigla`, `turno`, `unidades_hijas`, `nivel_agregacion`. Se confirmó en el inventario de Lambda la existencia de `delitos-materializados-orquestador` y `delitos-materializados-procesador`; su relación exacta con la ruta de consulta no se comprobó.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/delitosMaterilaizadosApi.js:16` — construcción de la consulta.
- `src/components/DelitosMaterilaizados/DelitosMaterilaizadosModal.js` — filtros, indicadores y limitaciones.
- `src/components/ToggleOptions/ToggleOptions.js:411` — acceso al modal.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar totales, categorías y detalle para una fecha y turno conocidos.
- [ ] Verificar agregación de una sigla frente a sus unidades hoja.
- [ ] Revisar tratamiento de días vacíos y errores sin reutilizar datos anteriores.
- [ ] Confirmar las fuentes físicas y fecha de corte antes de aprobar igualdad de cifras.

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
