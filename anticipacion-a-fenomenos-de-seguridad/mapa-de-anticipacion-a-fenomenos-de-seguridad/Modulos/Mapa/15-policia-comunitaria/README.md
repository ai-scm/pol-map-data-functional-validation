# Policía Comunitaria

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Policía Comunitaria |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Consulta zonas de trabajo comunitario y permite visualizarlas por tipo territorial, con detalle de la información y programación entregadas por el servicio.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere unidad seleccionada. El panel ofrece Consultar zonas, interruptores por etiqueta y Limpiar capa.

1. Seleccionar una unidad y abrir Policía Comunitaria.
2. Pulsar Consultar zonas.
3. Activar o desactivar los tipos presentes en la respuesta.
4. Abrir una zona y revisar su detalle.
5. Usar Limpiar capa para retirar el resultado.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Consultar zonas | Solicita sigla, id_unidad y anio_mes. |
| Tipos de zona | Interruptores por etiqueta con cantidad y color. |
| Limpiar capa | Retira geometrías y estado de la consulta. |

## 5. Comportamiento y reglas

- anio_mes se construye con el mes calendario anterior a la fecha del navegador; no se toma del turno seleccionado.
- La solicitud incluye la propia unidad y sus descendientes. Para una sigla con más de 60 descendientes solicita la propia unidad y sus hijos directos.
- Tipos configurados: Espacio Público, Vida Nocturna, Educación, Transporte, Institucional, Comercial, Residencial, Residencial y Comercial, Rural, Vía Pública y Otros.
- Solo se dibujan los tipos que existen en la respuesta; los interruptores modifican su visibilidad.
- El detalle puede incluir programación sugerida y contexto delictivo según los atributos recibidos.

## 6. Datos y servicios

`POST /policia-comunitaria` con `sigla`, `id_unidad` como lista y `anio_mes`; se lee `response.data.geojson`. AWS confirma funciones llamadas `planes-comunitarios-orquestador` y `planes-comunitarios-procesador`; la relación completa entre esas funciones, el modelo y la ruta de consulta está **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:4652` — construcción territorial y mes de consulta.
- `src/services/api/policiaComunitariaApi.js:7` — solicitud.
- `src/pages/MapPagePopups/PoliciaComunitariaPopup.js:1` — tipos y representación.
- `src/pages/MapPage.js:12198` — panel.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Validar el mes enviado, especialmente en enero y al cambiar de mes.
- [ ] Revisar una sigla con muchos descendientes y una unidad subordinada.
- [ ] Comparar cantidades por etiqueta con el GeoJSON recibido.
- [ ] Comprobar que Limpiar capa retira todas las zonas.
- [ ] Validar programación y contexto antes de usar las recomendaciones operativamente.

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
