# Documentación técnica — Control de ingesta de datos de planta nacional

## Activos y fuentes observadas

| Elemento | Valor |
|---|---|
| ID proporcionado | `3529d12a-f9f4-4fb9-b5bf-3d2b372abcb8` |
| Dashboard | `Tablero de control planta nacional` |
| Análisis informado | `Monitoreo ingesta llamadas de emergencia` |
| Hojas | Monitoreo de archivos recibidos; Monitoreo carga de datos IAPOL |
| Conjuntos de datos expuestos por el dashboard | `v_control_files`, `v_qs_refresh_monitor`, `v_monitoreo_final_clean` |

El análisis informado no apareció en el catálogo accesible. Los conjuntos se confirmaron mediante la vista de datos del dashboard publicado; su asignación a cada visual es provisional mientras no se abra el análisis.

## Hoja Monitoreo de archivos recibidos

### Controles

| Control | Valor visible inicial | Comportamiento esperado |
|---|---|---|
| Estado | Todo | Filtrar por estado de recepción o procesamiento; campo exacto pendiente. |
| Días a visualizar | 20 | Limitar la ventana móvil de fechas; campo de fecha y extremos pendientes. |

La documentación de la fórmula debe precisar si los 20 días incluyen el día actual, si se basan en `Fecha reporte` o `Fecha de carga` y qué zona horaria se utiliza.

### Tabla Registry

Encabezados confirmados:

| Campo visible | Significado funcional |
|---|---|
| Nombre archivo | Archivo recibido. No se deben copiar nombres reales a evidencias públicas si revelan rutas o periodos internos. |
| Fecha reporte | Periodo al que corresponde el contenido. |
| Fecha de carga | Fecha de recepción o registro. |
| Hora de carga | Hora de recepción o registro. |
| Estado | Resultado o condición del archivo. |
| Cantidad archivos | Medida agregada de archivos. |
| Tamaño archivo (Mb) | Tamaño expresado en MB según la presentación. |

### Visuales y lógica disponible

| Visual | Lógica técnica | Estado |
|---|---|---|
| Cantidad reportes duplicados recibidos | Conteo de reportes considerados duplicados. La llave y fórmula exactas no están disponibles. | Observado |
| Reportes recibidos semana actual | Indicador tipo gauge. Numerador, meta y definición de semana pendientes. | Observado |
| Frecuencia diaria | Eje `Fecha reporte llamadas`, valor `Cantidad archivos` y color/leyenda `Estado`. | Confirmado en el visual |
| Registry | Detalle con los siete campos anteriores. | Confirmado |

No debe asumirse que un duplicado es sólo un nombre repetido: podría depender de fecha de reporte, contenido, checksum, origen o una regla del proceso.

## Hoja Monitoreo carga de datos IAPOL

### Visuales de resumen

| Visual | Configuración o interpretación |
|---|---|
| Archivos procesados semana actual | KPI de archivos procesados; agregación y definición de semana pendientes. |
| Avance semanal | Gauge; numerador, denominador/meta y límite temporal pendientes. |
| Estado actual refresh | Tabla de una columna cuyo campo confirmado es `estado_refresh_global`. |
| Ultimo refresh exitoso | KPI temporal; se debe confirmar el filtro de éxito y si usa fecha inicial o final. |

### Dashboard de control archivos procesados (ETL)

Encabezados confirmados:

1. `Nombre archivo`
2. `Fecha reporte`
3. `Fecha de ingesta`
4. `Hora de ingesta`
5. `Estado procesado`
6. `Fecha procesado`
7. `Hora procesado`

Esta tabla permite separar recepción de procesamiento. La latencia ETL debe calcularse con marcas de tiempo completas y una misma zona horaria; restar por separado fecha y hora puede producir errores al cruzar medianoche.

### Dashboard de control carga de datos en IAPOL

Encabezados confirmados:

1. `Estado refresh`
2. `Fecha inicio`
3. `Fecha final`
4. `Duración refresh`
5. `Progreso`

La duración debe conciliar con `Fecha final - Fecha inicio`, considerando ejecuciones en curso y final fallido o nulo. `Progreso` debe documentar escala, redondeo y si 100 % implica éxito técnico o sólo fin del proceso.

### Otros visuales

- `Estado procesado top 5`: gráfico apilado al 100 %. Se requiere confirmar dimensión, orden del Top 5 y población excluida.
- `Visual crecimiento dataset`: gráfico de barras apiladas. Se requiere extraer medida, unidad, periodo y regla de crecimiento.

## Linaje provisional

| Conjunto de datos | Uso probable | Confianza |
|---|---|---|
| `v_control_files` | Recepción, registro y procesamiento de archivos. | Alta por nombre y campos visibles, pendiente de relación de visual. |
| `v_qs_refresh_monitor` | Estado, ejecución y duración de refrescos de Quick. | Alta por nombre y campos visibles. |
| `v_monitoreo_final_clean` | Resultado consolidado o crecimiento del conjunto final. | Media; debe confirmarse. |

El cuadro anterior no reemplaza el linaje del análisis. Se debe capturar para cada visual el conjunto, campo, agregación y filtro exactos.

## Pruebas técnicas mínimas

1. Congelar un periodo y contar archivos distintos por la llave oficial, estado y fecha de reporte.
2. Verificar la llave de duplicado con casos de mismo nombre/diferente contenido y diferente nombre/mismo contenido.
3. Comparar fecha de reporte, ingesta, procesamiento y refresco sin intercambiarlas.
4. Conciliar totales diarios y semanales; documentar inicio de semana y zona horaria.
5. Validar estados desconocidos, nulos, ejecuciones en curso y ejecuciones fallidas.
6. Verificar que el Top 5 no se presente como total del universo.
7. Confirmar que el gauge muestre la meta correcta incluso en semanas incompletas.
8. Revisar que `Duración refresh` no sea negativa y coincida con los timestamps.

## Asuntos pendientes

- Localizar el análisis informado o confirmar su nombre vigente.
- Fórmulas exactas de los dos gauges, KPI de duplicados, archivos procesados y último refresh exitoso.
- Campos y operadores de `Estado` y `Días a visualizar`.
- Relación exacta entre visuales y los tres conjuntos de datos.
- Fuentes físicas, programación de ingesta y refresco de SPICE.
- Definiciones de éxito, duplicado, meta semanal y crecimiento.

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)
