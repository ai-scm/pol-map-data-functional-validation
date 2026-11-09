# Filtros — Capas de anticipación

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Filtros — Capas de anticipación |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Agrupa los controles de visibilidad de la anticipación, la permanencia policial, las zonas de atención y los recursos de apoyo. El texto del acceso en el código publicado es **Capas de anticipación**.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere unidad seleccionada. Varios controles solo aparecen cuando existen datos para esa unidad, fecha y turno; su ausencia no equivale automáticamente a una falla.

1. Seleccionar sigla y unidad; elegir fecha y turno cuando corresponda.
2. Abrir Capas de anticipación, identificado por el interruptor.
3. Activar el control requerido y revisar su efecto sobre el mapa.
4. Consultar las fichas individuales antes de comparar cantidades.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Anticipación | [Ficha funcional](01-anticipacion/README.md). |
| Porcentaje permanencia | [Ficha funcional](02-porcentaje-permanencia/README.md). |
| Zonas de atención actuales | [Ficha funcional](03-zonas-de-atencion-actuales/README.md). |
| Zonas de atención por Fusión | [Ficha funcional](04-zonas-de-atencion-por-fusion/README.md). |
| Patrullas | [Ficha funcional](05-patrullas/README.md). |
| Sugerencia Personal de Apoyo | [Ficha funcional](06-sugerencia-personal-de-apoyo/README.md). |
| Planes Preventivos | [Ficha funcional](07-planes-preventivos/README.md). |
| Delitos materializados | [Ficha funcional](08-delitos-materializados/README.md). |

## 5. Comportamiento y reglas

- Los controles alternan capas o etiquetas ya cargadas y no comparten una única fuente de datos.
- Porcentaje permanencia ofrece Total, Comandantes, Patrullas de vigilancia y Otros; también permite ver tiempo hh:mm.
- El código incluye además controles condicionales de Hechos reales, Instituciones, Microterritorios, Alertas Iris P1 y Demanda - Zonas por Fusión.
- Delitos materializados abre una ventana de consulta; no es un interruptor de visibilidad simple.
- El panel Capas / Filtro por Fechas es otro acceso y cuenta con su propio formulario temporal.

## 6. Datos y servicios

Cada ficha identifica sus solicitudes o datos de entrada. La selección territorial procede del árbol de unidades y sus polígonos. No se asigna a este conjunto una tabla de Athena única.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:11178` — nombre y propiedades del panel.
- `src/components/ToggleOptions/ToggleOptions.js` — controles y condiciones de visibilidad.
- `src/components/ToggleOptions/ToggleOption.js:4` — un control no se representa si visible es falso.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Revisar los ocho controles con una unidad y turno con datos conocidos.
- [ ] Cambiar de unidad o turno y comprobar que no quedan capas del contexto anterior.
- [ ] Distinguir un control sin datos de un error de carga.
- [ ] Verificar que activar una capa no altera indebidamente las demás.

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

- [Capas y filtro de fechas](../06-capas/README.md).
- [Anticipación por demanda](../10-anticipacion-por-demanda/README.md).

[Volver al índice del mapa](../README.md).
