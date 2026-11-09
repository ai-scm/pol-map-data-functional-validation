# Servicios Extraordinarios

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Servicios Extraordinarios |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Representa personal o patrullas asociados a servicios extraordinarios y permite seleccionar una descripción de servicio.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere unidad seleccionada. La lista de servicios se construye a partir de la respuesta para esa unidad.

1. Seleccionar unidad y abrir Servicios Extraordinarios.
2. Esperar la carga de las descripciones disponibles.
3. Activar Ver Todos o una descripción concreta.
4. Consultar un punto y revisar el conteo visible.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Ver Todos | Representa todos los servicios recibidos. |
| Descripción del servicio | Filtra por descripcion. |
| Unidad | Se envía mediante id_unidad y sigla. |

## 5. Comportamiento y reglas

- El cliente forma una lista de descripciones únicas desde data.patrullas.
- Activar una descripción desactiva las otras; Ver Todos es una alternativa.
- La representación y el contador se ajustan al área visible del mapa.
- Los puntos usan iconos asociados a la descripción del servicio.

## 6. Datos y servicios

`POST /dboper/minuta-serv-ext` con `id_unidad` y `sigla`; se lee `patrullas` de la respuesta. La tabla física y las condiciones de vigencia están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/mapaPatrullaApi.js` — getServiciosExtraordinarios.
- `src/pages/MapPage.js:1507` — lista dinámica; línea 1529 — selección exclusiva.
- `src/pages/MapPage.js:1129` — carga y representación; línea 12028 — panel.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar descripciones disponibles con los valores distintos del servicio.
- [ ] Verificar selección exclusiva entre Ver Todos y un tipo.
- [ ] Comparar los puntos del viewport y sus contadores.
- [ ] Probar una unidad sin servicios y otra con varios tipos.

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

[Volver al índice del mapa](../README.md).
