# Patrullas

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Patrullas |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Controla la visualización de las patrullas operativas y los elementos asociados al mapa de atención.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Dentro de Capas de anticipación. La condición del control exige unidad seleccionada y más de un elemento en patrullasData.

1. Seleccionar unidad y esperar la carga de patrullas.
2. Abrir Capas de anticipación y activar Patrullas.
3. Consultar un marcador y observar una actualización.
4. Desactivar la visualización.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad | Permite obtener el hash de consulta del mapa. |
| Patrullas | Modifica capaPatrullasVisible. |

## 5. Comportamiento y reglas

- El mapa obtiene un hash para la sigla y unidad antes de consultar las patrullas.
- El proceso de actualización del mapa de patrullas usa un intervalo de 15 segundos.
- Este control de visibilidad y el panel Tipos de Minuta son accesos diferentes.
- Con una sola patrulla recibida el control no aparece según la condición length > 1; se registra para validar si corresponde a la regla funcional esperada.

## 6. Datos y servicios

Solicitudes de lectura mediante `POST /RO/maparutaoptima_cad` y `POST /RO/obtener_cuadrantes_hash`. La fuente operativa y la antigüedad de cada posición están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/components/ToggleOptions/ToggleOptions.js:309` — condición y control.
- `src/services/api/mapaPatrullaApi.js:7` — consultas por hash.
- `src/pages/MapPage.js:6411` — temporizador de actualización.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Probar unidades con cero, una y varias patrullas.
- [ ] Comparar las posiciones con la respuesta del mismo instante.
- [ ] Comprobar una actualización sin duplicados y la ocultación de marcadores.

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
