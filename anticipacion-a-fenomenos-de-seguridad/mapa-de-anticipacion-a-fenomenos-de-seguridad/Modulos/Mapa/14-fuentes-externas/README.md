# Fuentes Externas

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Fuentes Externas |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Permite superponer información territorial de contexto, como colegios, bancos, parques, transporte y establecimientos. El catálogo global consultado en AWS contiene 60 entradas externas.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere unidad seleccionada. La lista concreta se obtiene del servicio de categorías para esa unidad.

1. Seleccionar unidad y abrir Fuentes Externas.
2. Activar la capa de contexto requerida.
3. Consultar la geometría y su detalle.
4. Usar Cámaras o Establecimientos Comerciales cuando se requieran sus consultas específicas.
5. Desactivar las capas al terminar.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Capas dinámicas | Lista recibida de CategoryList para la unidad. |
| Cámaras | Control adicional del frontend con consulta específica. |
| Establecimientos Comerciales | Control adicional del frontend con consulta específica. |

## 5. Comportamiento y reglas

- Los 60 registros del catálogo no equivalen a 60 capas comprobadas visualmente.
- El frontend añade Cámaras y Establecimientos Comerciales al panel externo; no se suman al conteo de registros DynamoDB.
- La lectura de una capa usa su identificador y unidad; el cliente representa la respuesta y aplica sus filtros espaciales.
- No se confirmó una frecuencia única de actualización ni una fuente de publicación común para todas las capas externas.

## 6. Datos y servicios

Catálogo: `pon_prod_external_layers`, asociado a la categoría Fuentes Externas de `pon_prod_category`. Consulta del catálogo y geometrías mediante `/externalLayers/CategoryList` y `/externalLayers/get/{id}`. Las cámaras se consultan por estaciones en el cliente; sus fuentes físicas, así como las de establecimientos, están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:5993` — catálogo por unidad.
- `src/pages/MapPage.js:5197` — archivo por identificador.
- `src/pages/MapPage.js:12160` — controles de Cámaras y Establecimientos Comerciales.
- AWS: 60 entradas externas leídas el 2026-11-03.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Comparar el catálogo global y las capas habilitadas para una unidad.
- [ ] Verificar coordenadas, recorte, símbolos y atributos de una muestra de capas.
- [ ] Confirmar proveedor y fecha de corte de cada fuente antes de validar vigencia.
- [ ] Comprobar cámaras y establecimientos mediante sus solicitudes específicas.

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

- [Catálogo de nombres y archivos consultado en AWS](catalogo-2026-11-03.md).

[Volver al índice del mapa](../README.md).
