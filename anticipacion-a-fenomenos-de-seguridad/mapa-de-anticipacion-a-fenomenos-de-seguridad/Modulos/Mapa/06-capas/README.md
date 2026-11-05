# Capas — Filtro por Fechas

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Capas — Filtro por Fechas |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Consulta capas territoriales de RNMC, antecedentes, SECAD, capturas y planes GESCOV históricos para uno o dos intervalos de tiempo. El acceso se llama **Filtro por Fechas** y el panel se titula **Capas**.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere una unidad seleccionada. Se abre desde el icono de calendario.

1. Seleccionar sigla y unidad.
2. Abrir Filtro por Fechas.
3. Elegir Día específico, Rango de fechas o Comparación de fechas y completar sus horas.
4. Aplicar el filtro y activar las capas requeridas.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Día específico | Fecha, hora inicial y hora final. |
| Rango de fechas | Inicio y fin con fecha y hora. |
| Comparación de fechas | Dos intervalos enviados en listas timestamp_inicio y timestamp_final. |
| Aplicar filtro | Guarda el contexto temporal y reinicia las capas antes de la nueva activación. |
| Interruptores de capa | Solicitan o retiran las capas configuradas. |

## 5. Comportamiento y reglas

- Las 16 capas estáticas configuradas se enumeran en la tabla siguiente.
- Para una sigla completa se envía sigla sin id_unidad; para una unidad subordinada se incluyen su identificador y los descendientes encontrados en el árbol.
- La ruta de cada capa se define en LAYER_CONFIGS; el cuerpo lleva sigla, timestamp_inicio y timestamp_final y, cuando corresponda, id_unidad.
- Los antecedentes con Solo positivos tienen rutas específicas terminadas en -positivo.
- El filtro temporal de Fuentes Internas/Externas mantiene otro estado y no debe confundirse con este panel.

## 6. Datos y servicios

El cliente hace `POST` a las rutas de `LAYER_CONFIGS` usando `Capas_API_URL`. Esta revisión no ejecutó las consultas ni acreditó la fuente física de cada ruta. Los validadores de datos existentes en el repositorio de monitoreo son antecedentes de trazabilidad, no pruebas funcionales ejecutadas hoy.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:341` — lista estática de capas; línea 5720 — buildLayerPayload; línea 11279 — acceso.
- `src/components/specific/capasLayer/layerConfigs.js` — rutas, símbolos y filtros.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Validar los tres modos temporales con los intervalos enviados al servicio.
- [ ] Comparar una sigla completa con una estación y sus descendientes.
- [ ] Contrastar el conteo de cada capa con la respuesta para idénticos filtros.
- [ ] Verificar ausencia de puntos de un intervalo anterior tras aplicar otro filtro.

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

## Catálogo estático confirmado

| Capa | Ruta POST relativa a Capas_API_URL |
|---|---|
| RNMC: Riñas | `/rnmc-rinas` |
| RNMC: Incautaciones | `/rnmc-incautaciones` |
| RNMC: Mediaciones in situ | `/rnmc-mediaciones-situ` |
| RNMC: Mediaciones en sala | `/rnmc-mediaciones-sala` |
| Comportamientos contrarios a la convivencia | `/comportamientos-contrarios-convivencia-materializados` |
| Planes Gescov Programados | `/planes-programados-historico` |
| Antecedentes: Personas | `/antecedentes-personas` |
| Antecedentes: Vehículos | `/antecedentes-vehiculos` |
| Antecedentes: IMEI | `/antecedentes-imei` |
| Antecedentes: Personas (Solo positivos) | `/antecedentes-personas-positivo` |
| Antecedentes: Vehículos (Solo positivos) | `/antecedentes-vehiculos-positivo` |
| Antecedentes: IMEI (Solo positivos) | `/antecedentes-imei-positivo` |
| SECAD: Riñas | `/secad-rinas` |
| SECAD: Hurto violento y homicidio | `/secad-hurtos-violento-y-homicidio` |
| SECAD: Hurto general | `/secad-hurtos-general` |
| Capturas por Delito | `/capturas-por-delito` |
