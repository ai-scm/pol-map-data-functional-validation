# Documentación técnica — Gestión para la planeación y seguimiento al comité de vigilancia

## Activos y fuente lógica

| Elemento | Valor verificado |
|---|---|
| Dashboard y análisis de producción | `pon-prod-gpscv-gestion-planeacion-seguimiento` |
| Versión publicada en producción | 30, publicada el 2026-04-14 |
| Copia de trabajo (sandbox) | `[SANDBOX] pon-prod-gpscv-gestion-planeacion-seguimiento` (análisis y dashboard), sin acceso desde IAPOL |
| Tema | Producción: `Policia`. Sandbox: `[SANDBOX] Policia Institucional` |
| Conjunto de datos principal | `usr_disec.v_gescov_ddhh` (SPICE, recarga completa diaria a la 01:00) |
| Conjunto de datos de delitos | `vw_delitos_corregido_schema_temporal` (SPICE, recarga diaria a las 04:00). Solo en el sandbox; dentro del análisis se identifica como `siedco_delitos` |
| Conjuntos conectados sin uso | `rawvm_planes_preventivos` (su recarga falla) y `gescov` (archivo CSV de 2024). Ver hallazgos |
| Acceso en IAPOL | Registro del menú de tipo `dashboardQS`, enlazado al dashboard de producción |

No se versionan identificadores técnicos del dashboard ni URL internas; la ruta funcional es la referencia estable.

## Cadena de datos

| Paso | Hora (Colombia) | Componente | Qué hace |
|---|---|---|---|
| 1 | — | Oracle DISEC, vista `USR_DISEC.V_GESCOV_DDHH` | Une planes, puntos, actividades, unidades y evaluación de cumplimiento de GESCOV. |
| 2 | 22:30, cada dos días | Trigger `pon-prod-raw-disec-dashboard-scheduler` (`cron(30 3 */2 * ? *)` UTC) | Lanza el orquestador de cargas de DISEC. |
| 3 | 22:32 a ~01:25 | Job de Glue `pon-prod-raw-disec-dashboard-full-load-job` (`--table_name USR_DISEC.V_GESCOV_DDHH`) | Carga completa a Parquet en `s3://pon-prod-raw-disec/USR_DISEC.V_GESCOV_DDHH/` y actualiza la tabla `pon-prod-raw-disec.usr_disec.v_gescov_ddhh`. Dura cerca de tres horas. |
| 4 | 01:00 diario | Conjunto de datos `usr_disec.v_gescov_ddhh` (SPICE) | Importa la tabla de Athena (≈19,9 M filas, 25 GB). |
| 5 | En línea | Análisis y dashboard | Aplican filtros, parámetros y campos calculados. |

**Desfase:** la recarga de SPICE de la 01:00 empieza antes de que termine la carga de Glue (≈01:25), así que copia la versión anterior. Los datos nuevos aparecen en la recarga del día siguiente: el tablero puede ir hasta unos 2,5 días atrás de Oracle. El 2026-10-21 Athena tenía 19.894.268 filas y SPICE 19.880.914.

Para delitos, la cadena es la documentada en [`02. Comparativo Delictivo (Datos crudos)`](../../informacion-estadistica-delictiva/comparativo-delictivo-datos-crudos/documentacion-tecnica.md#cadena-de-datos): Oracle SIEDCO → carga de la 01:00 → vista de Athena → SPICE a las 04:00.

## Grano y campos principales

El grano de `usr_disec.v_gescov_ddhh` es **una actividad (punto) de un plan preventivo**. Un plan tiene varias actividades: el 2026-10-21 había 19,9 M filas y 2,8 M planes distintos (`plan_id`). Los indicadores cuentan filas; el reporte semanal llama “planes” a esas actividades.

| Grupo | Campos observados |
|---|---|
| Plan | `plan_id`, `id_tipo_plan`, `tipo_plan` (semanal, extraordinaria), `id_plan` y `plan_descripcion` (catálogo de 74 tipos de plan, con su duración, por ejemplo `Plan Motos (30 min)`), `id_estado` y `estado` |
| Actividad | `puntos_id`, `actividad`, `delito`, `riesgo`, `fecha_inicio_act`, `fecha_fin_act`, `total_minutos` |
| Cumplimiento | `id_estado_punto`, `estado_cumplimiento` (`Cumple`, `No cumple` o vacío si aún no se evalúa) |
| Territorio | `sigla_unidad` (53 unidades), `unidad` (estación), `cosec_distrito`, `cai` (CAI, subestación o la propia estación), `cuadrante` (código de cuadrante o patrulla), `zona` |
| Ubicación | `sitio`, `municipio`, `barrio`, `direccion`, `radio_accion`, `latitud`, `longitud` |
| Calculado en el conjunto de datos | `CUMPLE_DB` |

`id_plan` no identifica un plan: tiene 74 valores, uno por cada `plan_descripcion`. `fecha_inicio_plan` existe en Athena pero se excluyó del conjunto de datos.

## Reglas del reporte semanal

Reproducidas en Athena con la semana 7 de 2026 (ver “Validaciones ejecutadas”):

| Regla | Definición |
|---|---|
| Unidad de conteo | Una fila (actividad). |
| Planes que cuentan | `estado` en `Aprobacion Distrito`, `Aprobacion Estacion` o `Aprobado Extraordinario`. Los `Elaborado` (sin aprobar) se informan aparte; los rechazos se excluyen. |
| Fecha | `fecha_inicio_act`. |
| Semana | De domingo a sábado. La semana 1 es la que contiene el 1 de enero; por eso la semana 1 de 2026 incluye del 2025-12-28 al 2025-12-31. |
| Cumplimiento | `Cumple ÷ (Cumple + No cumple)`. |
| Metropolitanas y departamentos | `sigla_unidad` que empieza por `ME` (19) o por `DE` (34). |
| N° de estaciones | Valores distintos de `unidad`. |
| N° de patrullas | Valores distintos de `cuadrante`. |
| Subestaciones y CAI | Valores de `cai` que empiezan por `SUBESTACION` o por `CAI `. |
| Top 5 al 100 % | Mayor porcentaje de cumplimiento y, a igual porcentaje, mayor cantidad de actividades planeadas. |
| Plan más implementado | Mayor cantidad de actividades cumplidas por `plan_descripcion`. |
| Semaforización | Superior 90–100 %, Medio alto 70–89 %, Medio 50–69 %, Bajo 0–49 %. |
| Consolidado de planes especiales | Año calendario, del 1 de enero al cierre de la semana. Difiere del histórico semanal, que arranca en la semana 1. |
| Delitos de impacto | Registros de SIEDCO del 1 de enero a la fecha de corte frente al mismo periodo del año anterior. |

## Parámetros y filtros (sandbox)

| Alcance | Regla | Estado |
|---|---|---|
| Hojas nuevas (excepto Delitos de impacto) | Parámetro `FECHASEMANA` (por defecto, hace 7 días). El campo `EN_SEMANA_SEL = 1` deja la semana de domingo a sábado que contiene esa fecha. | Confirmado |
| Histórico semanal | `EN_ANIO_HASTA_SEL = 1`: semanas del año de la semana elegida, hasta esa semana inclusive. | Confirmado |
| Hojas nuevas | Filtro fijo `estado` en los tres estados aprobados; los visuales de “Elaborados” usan `estado = 'Elaborado'`. | Confirmado |
| Control y disuasión, Microgerencia territorio | `FECHAINICIAL` (inicio del año) y `FECHAFINAL` (fin del día actual) sobre `fecha_inicio_act`; ya no aplican a las hojas nuevas. | Confirmado |
| Todas las hojas con control `UNIDAD` | Parámetro `UNIDAD` (múltiple) sobre `sigla_unidad`. | Confirmado |
| Análisis | `ESTACION` sobre `unidad` y `TIPOACTIVIDAD` sobre `plan_descripcion`, en todas las hojas. | Confirmado |
| Delitos de impacto | `FECHACORTEDELITOS` (por defecto, hace 2 días) y `DELITOSMETDEPTO` sobre `juris.metropolitana / depto`. | Confirmado |
| Rankings | Filtros Top/Bottom por visual, con desempate por cantidad de actividades. | Confirmado |

## Campos calculados

### Corregidos en el sandbox

| Campo | Antes | Ahora |
|---|---|---|
| `DIA` | Tomaba `extract('WD')` = 1 como LUNES, pero en Quick 1 es domingo: todos los días quedaban desplazados. | 1 = DOMINGO … 7 = SÁBADO. |
| `SEMANA` | Sumaba 2 y dependía del inicio de semana del análisis (estaba en lunes): la semana 7 salía como 8. | Semana de domingo a sábado calculada de forma explícita; el inicio de semana del análisis pasó a domingo. |
| `MES_PER` | Meses según la fecha de cada actividad. | Mes o meses que abarca la semana (por ejemplo `DIC/ENE`). |
| `NO_CUMPLE` | Contaba también las actividades sin evaluar. | Solo `estado_cumplimiento = 'No cumple'`. |
| `cumplimiento`, `NO_CUMPLIMIENTO` | Dividían por todas las actividades. | Dividen por las evaluadas (`CUMPLE + NO_CUMPLE`). |

### Nuevos

| Campo | Definición |
|---|---|
| `INICIO_SEMANA`, `FIN_SEMANA`, `ANIO_SEMANA` | Domingo y sábado de la semana de la actividad, y año al que pertenece la semana. |
| `EN_SEMANA_SEL`, `EN_ANIO_HASTA_SEL` | Pertenencia a la semana elegida o al año hasta esa semana. |
| `PENDIENTE_EVALUAR` | Actividades sin evaluación (semana en curso o días aún no cerrados). |
| `NIVEL_SEMAFORO`, `NIVEL_SEMANA` | Nivel de cumplimiento según los cortes del manual. |
| `TIPO_UNIDAD` | `METROPOLITANA` o `DEPARTAMENTO`. |
| `REGION` | Una de las ocho regiones de Policía, con el mapeo del reporte semanal. `REMSA` (sigla de DESAB hasta el 2026-01-19) se asigna a la Región 1. |
| `TIPO_DEPENDENCIA` | `CAI`, `SUBESTACIÓN`, `ESTACIÓN` o `SIN DEPENDENCIA`, según `cai`. |
| `PLAN_TOP_UNIDAD` | Plan con más actividades cumplidas en cada unidad. Se calcula fila a fila con ventanas `PRE_AGG` para poder usarse como columna de agrupación. |
| `PCT_CUMPLE_PLAN` | Participación de un plan en las actividades cumplidas del periodo (ventana `PRE_AGG`, no la altera un filtro Top). |
| `RANK_CUMPLIMIENTO`, `RANK_PLAN` | Numeración de las tablas. |
| `CUADRANTES_UNIDAD`, `PLAN_MINIMO_SEMANA`, `PCT_PLAN_MINIMO` | Plan mínimo de la guía GESCOV: `techo(cuadrantes ÷ 2) × 6 actividades × 7 días`, y total planeado sobre ese mínimo. |
| `PERIODO_DELITOS`, `CASOS_ANTERIOR`, `CASOS_ACTUAL`, `DIF_CASOS`, `VAR_CASOS` | Comparativo de delitos por fecha de corte. |
| `DELITO_IMPACTO`, `GRUPO_DELITO`, `ORDEN_DELITO`, `ES_FEMINICIDIO` | Agrupación de `tematica` en los renglones del reporte; feminicidio se identifica en `conductas_especiales` o `descripcion_conducta`. |

`FECHA_ACTUALIZACION` sigue igual en ambas versiones: no lee los datos, calcula ciclos de dos días desde el 2024-11-16. Ver hallazgos.

## Lógica por hoja

Cada hoja tiene su documento con controles, componentes y pruebas. Resumen de las reglas que no son evidentes:

| Hoja | Regla |
|---|---|
| Contexto semanal | La unidad con mayor y con menor cumplimiento desempata por volumen, como el reporte (DECAS antes que METUN y DEGUN, todas al 100 %). |
| Cumplimiento por unidades | La tabla muestra solo unidades con actividades en la semana. El plan mínimo usa los cuadrantes con planeación, no un catálogo oficial de cuadrantes. |
| Histórico semanal | El total es el consolidado del año hasta la semana de corte; “bajo cumplimiento” es menor al 90 %. |
| Metropolitanas, departamentos y regiones | Ocho tablas de región con filtro fijo por `REGION`; DEVAU no aparece si no tiene actividades. |
| Reconocimiento Top 5 | Estaciones: `unidad` empieza por `ESTACION`. Patrullas: `cuadrante`. |
| Planes implementados | Solo planes con al menos una actividad cumplida. |
| Delitos de impacto | Aumento de casos en navy (alerta), disminución en lima. Cada registro de SIEDCO es un caso. |

## Cambios realizados (octubre de 2026)

### Origen

Se pidió validar la lógica y las fuentes del tablero, alinearlo con los colores institucionales y llevar a tablero el reporte semanal “Contexto GESCOV – Planes preventivos, Control y Disuasión” que hoy se arma a mano.

### Sandbox (2026-10-21)

1. Se copió el análisis de producción a un análisis y un dashboard nuevos, con los mismos conjuntos de datos y acceso solo para el desarrollador.
2. La hoja `Hoja 2` no se copió: tiene seis visuales que usan `fecha_inicio_plan`, columna retirada del conjunto de datos (`COLUMN_NOT_FOUND`), y nunca se publicó.
3. Todo el trabajo se hizo en el sandbox; producción no cambió.

### Presentación

| Uso | Color |
|---|---|
| Texto, encabezados de tabla, barras de sección, nivel Bajo, “no cumple” | `#002349` |
| Sub-barras, filas de total, nivel Medio, año anterior | `#0051A3` |
| Nivel Superior, “cumple”, recuadros destacados | `#BEEA01` |
| Fondo de hoja y de visuales, nivel Medio alto | `#DFF0FC` |

- Tema nuevo para el sandbox; el tema `Policia` no se modificó porque lo usa producción.
- Se retiró el blanco; solo se usan los cuatro colores.
- El banner dejó de cargarse desde una dirección externa: es una imagen almacenada en Quick, leída de `s3://pon-prod-public/quicksight/gpscv/` (bucket privado). La imagen anterior sigue en uso por producción.
- Se corrigieron solapamientos y se alinearon márgenes (96 px) y columnas (700 px) en las hojas originales.

### Lógica

- Correcciones de la sección “Campos calculados”.
- Filtro de estado: se retiró `Elaborado` de los planes que cuentan.
- Semáforo de las tablas: de seis colores (cortes 90/75/60/50/40) a los cuatro niveles del manual (90/70/50).
- Filtro de día de la gráfica por hora: de `1 - LUNES` (que era domingo) a `2 - LUNES`.

### Hojas nuevas

Contexto semanal, Cumplimiento por unidades, Histórico semanal, Metropolitanas, departamentos y regiones, Reconocimiento Top 5, Planes implementados y Delitos de impacto. Se construyó también una hoja de planes especiales (UNIPOL, Entornos Carcelarios e intervención policial) y se retiró a solicitud del usuario.

## Validaciones ejecutadas

Todas sobre Athena el 2026-10-21, con las reglas del reporte semanal, frente al reporte de la semana 7 de 2026 (extraído el 2026-02-20). Las consultas están en [`sql/athena.sql`](sql/athena.sql).

### Contexto semanal (semana 7)

| Cifra | Reporte | Athena |
|---|---:|---:|
| Total planeado | 68.307 | 68.265 |
| Cumplidos / no cumplidos | 66.015 / 2.292 | 66.096 / 2.169 |
| Elaborados sin aprobar | 79 | 79 |
| Zona rural | 1.565 | 1.565 |
| Planeación semanal / extraordinaria | 61.029 / 7.278 | 60.990 / 7.275 |
| Cumplidos domingo / lunes | 9.574 / 9.796 | 9.594 / 9.810 |
| Plan Motos | 14.108 (21 %) | 14.105 (21,3 %) |

Los elaborados por unidad coinciden: DECAU 33, DETOL 26, MEPER 12, DEBOY 3, DECAQ 2, DENOR 2 y DEGUA 1.

### Unidades y agrupaciones (semana 7)

| Grupo | Reporte (estaciones / patrullas / cumplidos / no / total) | Athena |
|---|---|---|
| MEBOG | 19 / 543 / 4.824 / 204 / 5.028 | Idéntico |
| Metropolitanas | 192 / 2.141 / 26.755 / 753 / 27.508 | 192 / 2.141 / 26.747 / 749 / 27.496 |
| Departamentos | 948 / 1.673 / 39.260 / 1.539 / 40.799 | 947 / 1.693 / 39.349 / 1.420 / 40.769 |
| Región 1 | 245 / 889 / 13.316 / 443 / 13.759 | 258 / 911 / 13.444 / 453 / 13.897 |
| Regiones 5, 6 y 7 | — | Idénticas |

La diferencia de la Región 1 y de Departamentos es DESAB: en el reporte figuraba con 0 patrullas y 0 % de cumplimiento; hoy tiene 22 cuadrantes y 88 % de cumplimiento.

### Reconocimiento Top 5 (semana 7)

Coinciden en orden las cinco listas: distritos (Yopal, Combita, Támesis, Salamina, Santa Rosa), estaciones (Riohacha, La Candelaria, Ciénaga, Yopal, San José), subestaciones (Pasacaballos, San Cristóbal, Cotoprix, Camarones, Matitas), CAI (Alto del Medio, El Poblado, Catama y Gobernación empatados, Guatiquía) y patrullas. Se confirma la regla de desempate por volumen.

### Planes implementados (semana 7)

59 planes con actividades cumplidas, igual que el reporte. Los cinco primeros y los cuatro últimos coinciden.

### Histórico semanal (2026)

| Semana | Reporte (cumplidos / no / total) | Athena |
|---|---|---|
| 1 | 65.164 / 4.646 / 69.810 | 65.179 / 4.634 / 69.813 |
| 2 | 63.723 / 4.160 / 67.883 | 63.700 / 4.132 / 67.832 |
| 3 | 62.961 / 2.869 / 65.830 | 62.971 / 2.856 / 65.827 |
| 4 | 66.835 / 3.465 / 70.300 | 66.848 / 3.445 / 70.293 |
| 5 | 69.118 / 4.633 / 73.751 | 69.137 / 4.493 / 73.630 |
| 6 | 70.243 / 4.992 / 75.235 | 70.225 / 2.129 / 72.354 |
| 7 | 66.015 / 2.292 / 68.307 | 66.096 / 2.169 / 68.265 |

### Delitos de impacto (corte 2026-02-18)

| Delito | 2025 reporte | 2025 Athena | 2026 reporte | 2026 Athena |
|---|---:|---:|---:|---:|
| Homicidios en accidente de tránsito | 903 | 903 | 965 | 1.004 |
| Abigeato | 160 | 160 | 57 | 140 |
| Secuestro extorsivo / simple | 30 / 7 | 30 / 7 | 27 / 12 | 52 / 29 |
| Feminicidios | 26 | 26 | 14 | 18 |
| Hurto a personas | 38.194 | 38.179 | 35.410 | 41.761 |
| Violencia intrafamiliar | 17.452 | 17.144 | 14.550 | 21.663 |
| Hurto general (total) | 65.365 | 65.570 | 56.095 | 70.446 |

## Hallazgos

| Código | Hallazgo | Efecto |
|---|---|---|
| H01 | La semana 6 de 2026 del reporte tiene cerca de 2.900 actividades “no cumple” que hoy no existen en GESCOV con ningún estado. | La semana 6 pasa de 93 % a 97 % y deja de ser la de mayor incumplimiento. Debe confirmarse con GUVIP si se corrigieron en la fuente. |
| H02 | Los delitos de 2026 del reporte se extrajeron dos días después del corte; SIEDCO sigue registrando hechos después. | El reporte mostró una baja de 14 % en hurtos; con los datos completos hay un aumento de 7 %. Comparar con un corte más antiguo o advertir el subregistro. |
| H03 | Plan mínimo de la guía: solo 22 de 53 unidades lo alcanzaron en la semana 7 (MEBOG 44 %, MEVAL 39 %, DESAB 23 %). | Indicador nuevo; usa cuadrantes con planeación, por lo que el mínimo real puede ser mayor. |
| H04 | La recarga de SPICE (01:00) empieza antes de que termine la carga de Glue (≈01:25). | Hasta 2,5 días de atraso frente a Oracle; además, riesgo de leer archivos a medio escribir. |
| H05 | `rawvm_planes_preventivos` falló en todas las recargas registradas (`TABLE_NOT_FOUND`). | Sin efecto visible: solo lo usan filtros aplicados a la imagen del banner (retirados en el sandbox). |
| H06 | `gescov` es un CSV cargado a mano en 2024 y ningún visual lo usa. | Conjunto huérfano. |
| H07 | `FECHA_ACTUALIZACION` es una fecha calculada en ciclos de dos días, no la fecha real de los datos. | Puede mostrar una fecha posterior a la de los datos o seguir avanzando si la carga falla. Requiere agregar `fecha_actualiza_vm` al conjunto de datos. |
| H08 | Turno con mayor cumplimiento: ningún corte de ocho horas reproduce la cifra del reporte (24.891). | El visual no se construyó. |
| H09 | `total_minutos` no corresponde a la duración del plan (mediana cercana a 120 minutos para planes de 30). | No se usa para horas de servicio. |
| H10 | 5.396 `puntos_id` repetidos y fechas inválidas (años 0002 y 0024). | Efecto menor; SPICE descarta una fila en cada recarga. |
| H11 | El cumplimiento anual pasa de 52–64 % (2021–2024) a 92–97 % (2025–2026). | Posible cambio de regla de evaluación; confirmar antes de comparar años. |

## Diferencias entre producción y sandbox

| Aspecto | Producción | Sandbox |
|---|---|---|
| Hojas publicadas | 2 | 9 |
| Planes que cuentan | Incluye `Elaborado` | Solo aprobados |
| No cumple | Incluye actividades sin evaluar | Solo evaluadas como “No cumple” |
| Días de la semana | Desplazados un día | Correctos |
| Número de semana | Semana real + 1 | Semana del reporte |
| Semáforo | Seis colores, cortes propios | Cuatro niveles del manual |
| Colores y banner | Verdes, banner externo | Institucionales, banner almacenado en Quick |
| Delitos de impacto | No existe | Hoja con SIEDCO |

## Asuntos pendientes

- Definición de horarios de los turnos para el indicador “Turno con mayor cumplimiento”.
- Fuente de los resultados operativos de UNIPOL y Entornos Carcelarios (registros, comparendos, capturas, ERON, personal DIJIN/MSOPT); no están en GESCOV cargado.
- Catálogo oficial de cuadrantes por unidad para el plan mínimo y catálogo de unidades con nombre completo (hoy solo sigla).
- Confirmación con GUVIP de la semana 6 (H01) y del criterio de corte para delitos (H02).
- Fecha real de actualización (H07) y orden entre la carga de Glue y la recarga de SPICE (H04).
- Permiso formal del equipo dueño del conjunto `vw_delitos_corregido_schema_temporal` antes de publicar.
- Para publicar: duplicar el conjunto de datos de GESCOV si se cambian columnas, actualizar el análisis de producción con la definición validada, publicar una versión nueva y retirar `rawvm_planes_preventivos` y `gescov`.
- Revisión visual y prueba con usuario lector del sandbox.

## Notas técnicas de mantenimiento

- Las definiciones del sandbox se generan por API. La lectura de la definición (`describe-analysis-definition`) puede devolver visuales con filtros Top/Bottom con referencias internas que la API no acepta de vuelta; actualizar siempre desde la última definición validada y no desde la lectura.
- Justo después de actualizar, la lectura puede devolver una definición incompleta durante unos segundos: verificar la cantidad de filtros antes de publicar.
- Los nombres de parámetros solo admiten letras y números (`FECHASEMANA`, no `FECHA_SEMANA`).
- Las expresiones de formato condicional solo aceptan rangos `(x >= a) AND (x <= b)`.

## Consultas Athena orientativas

Usan campos y reglas confirmados. El archivo completo, con la semana 7 de 2026 como ejemplo, es [`sql/athena.sql`](sql/athena.sql).

### Totales de una semana

```sql
-- Semana de domingo a sábado; solo planes aprobados; una fila = una actividad.
SELECT
    COUNT(*)                                                         AS total_planeado,
    SUM(CASE WHEN estado_cumplimiento = 'Cumple'    THEN 1 ELSE 0 END) AS cumplidos,
    SUM(CASE WHEN estado_cumplimiento = 'No cumple' THEN 1 ELSE 0 END) AS no_cumplidos
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '<domingo> 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '<domingo_siguiente> 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario');
```

### Cumplimiento por unidad

```sql
SELECT
    sigla_unidad,
    COUNT(DISTINCT unidad)    AS estaciones,
    COUNT(DISTINCT cuadrante) AS patrullas,
    SUM(CASE WHEN estado_cumplimiento = 'Cumple'    THEN 1 ELSE 0 END) AS cumplidos,
    SUM(CASE WHEN estado_cumplimiento = 'No cumple' THEN 1 ELSE 0 END) AS no_cumplidos,
    COUNT(*)                  AS total_planeado
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '<domingo> 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '<domingo_siguiente> 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
GROUP BY sigla_unidad
ORDER BY total_planeado DESC;
```

> Pendiente antes de usar estas consultas como contrato: validación de la vista en Oracle DISEC con la misma fecha de corte y confirmación de los asuntos H01 y H02.

[Volver al submódulo](README.md)
