# Botón de Pánico

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Botón de Pánico |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Visualiza las alertas de pánico de APPPOL como marcadores y permite consultar su detalle. El control del mapa activa la visualización; no se encontró en este panel una acción para emitir una alerta nueva.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

El botón está definido sin exigir una unidad seleccionada.

1. Abrir Botón de Pánico.
2. Activar APPPOL.
3. Abrir un marcador para consultar su detalle.
4. Desactivar APPPOL para retirar los puntos y detener la actualización.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| APPPOL | Activa o desactiva la carga y los marcadores. |
| Marcador | Abre el detalle de la alerta y su fecha de creación. |

## 5. Comportamiento y reglas

- Al activarse realiza una consulta inmediata y luego repite la consulta cada 20 segundos mientras permanece activo.
- Cada respuesta sustituye los marcadores anteriores; se excluyen latitud o longitud no numéricas.
- La propiedad vigente determina la presentación de la sirena como vigente o inactiva.
- Al desactivar el control se eliminan los marcadores y se cancela el temporizador.

## 6. Datos y servicios

Consulta `GET /boton-panico` mediante `gescovApi`; lee `response.data.datos`. El cliente utiliza propiedades como `latitud`, `longitud`, `vigente`, `fecha_creacion` y `fecha_deshabilita`. La fuente física y su latencia están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/gescovApi.js:13` — consulta de alertas.
- `src/pages/MapPage.js:7258` — carga; línea 7271 — activación y actualización periódica.
- `src/pages/MapPagePopups/BotonPanicoPopup.js` — detalle del marcador.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comprobar representación de una alerta vigente y una inactiva con datos de prueba.
- [ ] Observar una actualización sin duplicación de marcadores.
- [ ] Comprobar que desactivar APPPOL detiene las consultas y retira los puntos.
- [ ] Contrastar la fecha y vigencia de una alerta con el servicio de origen.

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
