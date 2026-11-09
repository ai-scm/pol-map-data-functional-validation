# Anticipación por demanda

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Anticipación por demanda |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Permite seleccionar una anticipación disponible para una combinación de delitos en la unidad y fecha del turno. La selección se usa para cargar los archivos de predicción y la optimización correspondiente.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

El botón exige unidad y un turno con id_turno. Esta ficha describe el panel dentro del mapa; no redefine el submódulo homónimo del menú principal.

1. Seleccionar unidad, fecha y turno.
2. Abrir Anticipación por demanda.
3. Elegir una opción Anticipación seguida de los delitos disponibles.
4. Revisar la predicción y, si procede, Demanda - Zonas por Fusión.
5. Usar Restablecer selección para retirar la opción elegida.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Unidad / Sigla | Se envían como unidad y cad al catálogo. |
| Fecha del turno | Se convierte a YYYYMMDD como dia_inicial; cantidad_dias=1. |
| Selector de anticipación | Presenta las combinaciones de delitos recibidas. |
| Restablecer selección | Devuelve una selección nula al mapa. |

## 5. Comportamiento y reglas

- El catálogo se actualiza cuando cambian unidad, turno o fecha.
- Si no hay opciones muestra No hay anticipación por demanda disponible para la fecha seleccionada.
- La opción seleccionada aporta ruta, date_params, unidad_base y fecha para localizar los GeoJSON del turno.
- La fusión por demanda utiliza el path de predicción y la cantidad de patrullas.
- La precedencia del mensaje sin opciones sobre el estado Cargando requiere revisión visual para distinguir una espera de una ausencia real de datos.

## 6. Datos y servicios

`GET /info/unidad_fecha_multiple` lista opciones. `POST /geo/disponibles_unidad_fecha` localiza archivos y `GET /geo/one_path` lee el elegido. La optimización usa `POST /optimizacion/obtener_optimizacion_by_path` y `/optimizacion/obtener_base_by_path`. No se verificó hoy la existencia de artefactos para todas las combinaciones posibles.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/components/specific/anticipacionPorDemanda/AnticipacionPorDemanda.js:49` — catálogo y parámetros.
- `src/components/specific/prediccionDemandaLayer/PrediccionDemandaLayer.js:36` — localización de archivos; línea 66 — lectura.
- `src/components/specific/fusionDemanda/FusionDemanda.js` — optimización por path.
- `src/pages/MapPage.js:11906` — condición de disponibilidad del acceso.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Validar las opciones contra el catálogo del mismo día y unidad.
- [ ] Comprobar que cada opción carga un archivo correspondiente al turno elegido.
- [ ] Cambiar de fecha o unidad y verificar que no queda una opción anterior.
- [ ] Distinguir catálogo vacío, carga en curso y error del servicio.
- [ ] Comprobar Restablecer selección y la variante de fusión.

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
