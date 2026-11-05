# Planes Gescov

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Planes Gescov |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Visualiza planes programados y planes en ejecución como puntos operativos, con detalle y conteo sobre el área visible del mapa.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

El acceso exige unidad seleccionada. El cliente intenta recortar los puntos con los polígonos de esa unidad.

1. Seleccionar una unidad y abrir Planes Gescov.
2. Activar Planes Programados o Planes en ejecución.
3. Consultar un punto y observar su detalle.
4. Mover el mapa para revisar los conteos visibles y desactivar la capa al terminar.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Planes Programados | Carga /planes-programados. |
| Planes en ejecución | Carga /puntos-gescov. |
| Área visible | Modifica puntos y cantidades representados en pantalla. |

## 5. Comportamiento y reglas

- Cada capa inicia una carga inmediata y una actualización automática cada 10 minutos.
- Al desactivarse se retiran fuentes, capas y manejadores asociados y se detiene su temporizador.
- El recorte territorial utiliza geojsonReal; si todavía no hay polígonos, filterPointsByGeojsonReal devuelve los elementos sin ese recorte.
- Los conteos de pantalla se calculan después del filtro por viewport.
- Planes Gescov, el histórico de planes en Capas y la capa Gescov de Fuentes Internas son flujos diferentes.

## 6. Datos y servicios

`GET /planes-programados` y `GET /puntos-gescov` mediante `gescovApi`. El cliente lee datos de la respuesta y propiedades como idplan, plandesc, tipoplan, cuadrante, fechainicio y fechafin. La base física de estas rutas y el criterio exacto de vigencia están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/gescovApi.js:7` — solicitudes.
- `src/pages/MapPage.js:4332` — carga y recorte; línea 4811 — temporizadores.
- `src/pages/MapPage.js:11835` — panel.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Contrastar cada categoría con su respuesta y sus fechas.
- [ ] Comprobar recorte territorial con y sin polígonos cargados.
- [ ] Explicar diferencias entre total recibido y puntos del área visible.
- [ ] Comprobar actualización y cancelación del temporizador.

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

- [Gescov en Fuentes Internas](../13-fuentes-internas/Gescov/README.md).
- [Capas históricas por fecha](../06-capas/README.md).

[Volver al índice del mapa](../README.md).
