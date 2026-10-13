# Documentación técnica — Medidas de Protección Violencia Intrafamiliar (Gerencial)

## Evidencia y límites

Inspección documental realizada el 2026-10-13 sobre los dos JSON entregados. Su contenido se trató como evidencia de configuración. No se consultó AWS, el tablero en pantalla ni registros de producción. La fecha de exportación y la versión publicada exacta no aparecen en los archivos.

La referencia de dataset del dashboard coincide exactamente con el ARN del dataset recibido. La correspondencia se verificó localmente; no se versionan esos ARN ni los identificadores de AWS.

| Archivo de entrada | SHA-256 |
|---|---|
| `dashboard-definition2.json` | `31e432bda4b96e4f50f99df882ff7bbf251e6ccd461f81b0cb6e8130b3d4094e` |
| `dataset-definition.json` | `f6d3dc222a829be5bdc68db82d92a88c3c54b729269698992ca935701b5b27be` |

## Activos y fuente

| Propiedad | Valor confirmado |
|---|---|
| Dashboard | `pon-prod-mpvg-medidas-proteccion-violencia-genero` |
| Alias lógico usado por el dashboard | `usr_disec.v_simep_medidas` |
| Nombre actual del dataset | `medidas_autos_s3` |
| Modo del dataset | `SPICE` |
| Catálogo de la tabla declarada | `AwsDataCatalog` |
| Esquema | `pon-prod-raw-disec` |
| Tabla declarada | `medidas_autos_s3` |
| Estructura | Una tabla física y una tabla lógica; sin uniones ni SQL personalizado en esta definición |
| Hojas / visuales | 4 / 34 |
| Campos calculados / parámetros | 12 / 17 |
| Grupos de filtros | 46: 41 habilitados y 5 deshabilitados |
| Estado del recurso exportado | `CREATION_SUCCESSFUL`, con dos entradas en `Errors` |

El alias `usr_disec.v_simep_medidas` no demuestra que se consulte actualmente una vista con ese nombre: el dataset recibido declara `medidas_autos_s3` como tabla física. La definición contiene una referencia a un data source; no se recibió su descripción para confirmar el tipo de conexión. El catálogo y esquema son una referencia para localizar la fuente en Athena, pendiente de verificar contra el data source.

## Comparación con el tablero operacional

Se compararon `dashboard-definition2.json` (gerencial) y `dashboard-definition.json` (operacional). Las fórmulas de los 12 campos calculados, las declaraciones de los 17 parámetros y las opciones de publicación coinciden. Los 46 filtros conservan sus reglas, estados y alcance equivalente al mapear las hojas y visuales; F23 sólo cambia el orden de sus tres textos de categoría. Ambos archivos reportan los mismos dos errores.

El dataset anterior fue reutilizado porque su ARN coincide con la referencia de este dashboard y con la del operacional. No es una nueva exportación del dataset ni demuestra que su configuración siga siendo la misma después de ese archivo.

| Aspecto | Operacional | Gerencial |
|---|---|---|
| Hojas y visuales | Cuatro hojas, 34 visuales | Cuatro hojas, 34 visuales |
| H2-V11: MEDIDAS DE PROTECCIÓN | `DISTINCT_COUNT(medida_id)` | `COUNT(medida_id)` |
| Región en H1 y H2 | Sin control de parámetro declarado | Control `Region` con opciones de `desc_regional` |
| Unidad en H1 | Sin control de parámetro declarado | Control `Unidad` |
| Unidad en H2 | Opciones sin cascada | Opciones dependen de región |
| Cuadrante en H2 | Opciones sin cascada | Opciones dependen de región y unidad |
| Unidad en hojas de documentos | Sin control de parámetro declarado | Control `Unidad` en ambas hojas |
| Estación en hojas de documentos | Opciones sin cascada | Opciones dependen de unidad |
| Presentación | Diseño exportado propio | Cambios de posición, tamaños y estilos; ventana inicial del mapa y rango visible de profesión distintos |

La diferencia de COUNT puede incrementar el valor cuando una medida tiene varias filas para el mismo literal. Confirmar si el indicador gerencial pretende contar registros o medidas únicas; no tratar ambas cifras como equivalentes. Los cambios de ventana de mapa o rango del eje no constituyen filtros de filas.

Los controles en cascada restringen las opciones disponibles. Su configuración no amplía por sí sola el alcance de los filtros; las reglas efectivas están en el inventario de filtros.

La documentación del [operacional](../medidas-de-proteccion-violencia-intrafamiliar-operacional/README.md) sirve como referencia del tablero hermano. Las pruebas deben ejecutarse para cada dashboard con su perfil de acceso.

## Transformaciones del dataset

1. Convertir `latitud` de STRING a DECIMAL, subtipo FIXED.
2. Convertir `longitud` de STRING a DECIMAL, subtipo FIXED.
3. Etiquetar ambas columnas como LATITUDE y LONGITUDE.
4. Proyectar las 47 columnas de salida que se listan al final.

No aparecen filtros de filas, campos calculados de dataset ni operaciones de unión en `LogicalTableMap`. Las fórmulas documentadas pertenecen al dashboard. El grano y la lógica previa de construcción de la tabla no están disponibles.

## Actualización y trazabilidad pendientes

`LastUpdatedTime` del dataset es `2026-10-13T07:00:59.622000+00:00` (02:00:59 en Colombia). Es un metadato del dataset; no demuestra una ingesta de SPICE exitosa ni una programación diaria.

| Información faltante | Evidencia necesaria |
|---|---|
| Motor y configuración de la conexión | Descripción del data source referenciado |
| Frecuencia de actualización de SPICE | Programaciones de refresco del dataset |
| Última ingesta exitosa y filas cargadas | Historial de ingestas de SPICE |
| Origen de `counting`, grano y deduplicación | Definición de tabla/vista y proceso que genera `medidas_autos_s3` |
| Fuente Policía, extracción y sincronización | Metadatos del proceso de ingesta y responsable de la fuente |
| Ubicación física en S3 | Metadatos del catálogo; no está en estos JSON |
| Zona horaria del tablero | Configuración efectiva; `Options` sólo declara inicio de semana SUNDAY |
| Seguridad por filas y permisos efectivos | Revisión de permisos y alcance por perfil; ausencia de configuración en este archivo no demuestra acceso irrestricto |

## KPI y agregaciones

- `TOTAL MEDIDAS` (H1-V04): `DISTINCT_COUNT(medida_id)`.
- `TOTAL AUTOS` (H1-V12) y `AUTOS POR UNIDAD` (H2-V06): `DISTINCT_COUNT(auto_id)`.
- `MEDIDAS DE PROTECCIÓN` (H2-V11): `COUNT(medida_id)` por `descripcion_id_literal`. Cuenta ocurrencias no nulas de la columna, no medidas distintas.
- Gráficos de actores: `DISTINCT_COUNT(interviniente_id)` por su dimensión.
- `ACTIVIDADES POR CUADRANTE`, `ACTIVIDADES POR ESTACIONES`, detalle de intervinientes y `ACTIVIDADES POR UNIDAD`: `SUM(ACTIVIDADES)`.
- Los pivotes de detalle usan `MAX(identificacion_interviniente)` como medida. Es una presentación agregada de una identificación, no un conteo de personas. Comprobar si agrupa a varias personas bajo la misma combinación de dimensiones.

Los conteos distintos por categoría pueden solaparse; no se presume que su suma equivalga al total. Los campos `MEDIDAS` y `MEDIDAS.` tienen fórmulas diferentes. Los KPI usan directamente las columnas indicadas, no esas fórmulas por su nombre.

## Campos calculados del dashboard

### `ACTIVIDAD`

```text
ifelse(max(counting,[{medida_id}])<1, "Sin actividades", "Con actividades")
```

### `ACTIVIDADES`

```text
max(counting,[{medida_id}])
```

### `AUTOS`

```text
distinctCountIf({auto_id}, NOT isNull({auto_id}) AND {auto_id} <> "")
```

### `Apellidos Policia`

```text
{apellidos_policia}
```

### `EDAD`

```text
ifelse({descripcion_id_r_edad}="Primera Infancia (0 a 5 años)",0, {descripcion_id_r_edad}="Adolescencia (12 a 17 años)",1, {descripcion_id_r_edad}="Juventud (18 a 28 años)",2,{descripcion_id_r_edad}="Adultez (29 a 59 años)", 3, {descripcion_id_r_edad}="Adulto Mayor (más de 60 años)",4, {descripcion_id_r_edad}="No reporta",5, NULL)
```

### `Grado Policia`

```text
{grado_policia}
```

### `Identificación`

```text
{identificacion_interviniente}
```

### `MEDIDAS`

```text
distinct_count({auto_id})
```

### `MEDIDAS.`

```text
distinct_count({medida_id})
```

### `Nombres Policia`

```text
{nombres_policia}
```

### `REGION`

```text
ifelse({sigla_fisica}="MEBOG","REGION DE POLICIA LA SABANA",{desc_regional})
```

### `ruta_null`

```text
ifelse(
    ruta='',0
    ,1
)
```

`AUTOS` excluye identificadores de auto nulos y vacíos. El KPI `TOTAL AUTOS` no usa este campo: sus filtros de exclusión de cadena vacía están deshabilitados. Se debe medir la diferencia si hay cadenas vacías.

`ACTIVIDADES` toma el máximo de `counting` por `medida_id`. Confirmar que sumar ese resultado en cada visual no duplica actividades por las múltiples filas de una medida. No se presume una evaluación anterior a los filtros porque la expresión no declara `PRE_FILTER` o `PRE_AGG`.

`ruta_null` compara únicamente con cadena vacía. No verifica la existencia o accesibilidad de un documento, ni trata explícitamente NULL o espacios en blanco. Sus efectos sobre esos casos están pendientes de probar.

`EDAD` no incluye una rama para infancia de 6 a 11 años y usa el texto “más de 60 años”. Comprobar el catálogo real de categorías y el caso de 60 años; los textos sin correspondencia devuelven NULL en esta fórmula.

## Parámetros

| Nombre | Tipo | Cardinalidad | Valor inicial declarado |
| --- | --- | --- | --- |
| identificacion | Decimal | SINGLE_VALUED | Sin valores estáticos explícitos |
| Actividades | Decimal | MULTI_VALUED | Sin valores estáticos explícitos |
| Unidad | String | MULTI_VALUED | Sin valores estáticos explícitos |
| Region | String | MULTI_VALUED | Sin valores estáticos explícitos |
| Delito | String | MULTI_VALUED | Sin valores estáticos explícitos |
| conducta | String | MULTI_VALUED | Sin valores estáticos explícitos |
| poblacion | String | MULTI_VALUED | Sin valores estáticos explícitos |
| Zona | String | MULTI_VALUED | Sin valores estáticos explícitos |
| EDAD | String | MULTI_VALUED | Sin valores estáticos explícitos |
| genero | String | MULTI_VALUED | Sin valores estáticos explícitos |
| Profesion | String | MULTI_VALUED | Sin valores estáticos explícitos |
| estaciones | String | MULTI_VALUED | Sin valores estáticos explícitos |
| cuadrante | String | MULTI_VALUED | Sin valores estáticos explícitos |
| expediente | String | SINGLE_VALUED | Sin valores estáticos explícitos |
| victima | String | MULTI_VALUED | Sin valores estáticos explícitos |
| Fechainicio | DateTime | Fecha/hora | addDateTime(-21, 'YYYY', truncDate('YYYY', now())) |
| Fechafin | DateTime | Fecha/hora | addDateTime(-1, 'SS', addDateTime(1, 'DD', truncDate('DD', now()))) |

`Fechainicio` corresponde al inicio del año de hace 21 años; `Fechafin`, al último segundo del día actual. El filtro global utiliza `fecha_medida`, granularidad DAY y ambos extremos incluidos, excluyendo nulos. Confirmar su evaluación efectiva y zona horaria. No sustituir este intervalo por “año actual”.

Los parámetros `expediente` y `victima` no aparecen referenciados por los filtros o controles de estas hojas. `Region` alimenta el filtro global F27 sobre el calculado `REGION` y tiene controles en H1 y H2, cuyas opciones provienen de `desc_regional`. Como la fórmula reasigna MEBOG a “REGION DE POLICIA LA SABANA”, se debe comprobar la correspondencia entre opciones y valores filtrados. `Delito` tiene controles en H1 y H2; su filtro por parámetro sólo alcanza H1. `EDAD` y `genero` sólo filtran sus respectivos gráficos de H1.

## Inventario de filtros y alcance

Las referencias H1–H4 corresponden al orden de las hojas del README. V01, V02, etc. corresponden al orden del array `Visuals`, no a su posición en pantalla. F01–F46 son referencias documentales al orden de `FilterGroups`, no identificadores de AWS. Todos los grupos contienen un filtro.

`NON_NULLS_ONLY` excluye valores nulos; `ALL_VALUES` los incluye según la configuración declarada. “Todos los valores” no equivale a ausencia de filtro cuando se excluyen nulos. Se preservan los operadores tal como están en el JSON, sin convertir `CONTAINS` en igualdad.

| Referencia | Estado | Alcance | Campo | Regla |
| --- | --- | --- | --- | --- |
| F01 | ENABLED | H1: todos los visuales | sigla_fisica | EQUALS parámetro `Unidad`; NON_NULLS_ONLY |
| F02 | ENABLED | H1: todos los visuales | desc_regional | CONTAINS todos los valores; NON_NULLS_ONLY |
| F03 | ENABLED | H1: todos los visuales | delito_descripcion | EQUALS parámetro `Delito`; NON_NULLS_ONLY |
| F04 | ENABLED | H1: todos los visuales | tipo_conducta_descripcion | CONTAINS todos los valores; NON_NULLS_ONLY |
| F05 | ENABLED | Todas las hojas | delito_descripcion | CONTAINS todos los valores; NON_NULLS_ONLY |
| F06 | ENABLED | Todas las hojas | descripcion_id_poblacion | EQUALS parámetro `poblacion`; NON_NULLS_ONLY |
| F07 | ENABLED | Todas las hojas | zona_descripcion | EQUALS parámetro `Zona`; NON_NULLS_ONLY |
| F08 | ENABLED | Todas las hojas | sigla_fisica | EQUALS parámetro `Unidad`; NON_NULLS_ONLY |
| F09 | ENABLED | Todas las hojas | tipo_conducta_descripcion | EQUALS parámetro `conducta`; NON_NULLS_ONLY |
| F10 | DISABLED | H2: H2-V05 | fecha_medida | Hasta fin del día actual; extremos incluidos; DAY; NON_NULLS_ONLY |
| F11 | DISABLED | H2: H2-V05 | fecha_medida | Entre `Fechainicio` y `Fechafin`, extremos incluidos; DAY; NON_NULLS_ONLY |
| F12 | DISABLED | H2: H2-V05 | counting | EQUALS parámetro eliminado (error reportado); NON_NULLS_ONLY |
| F13 | ENABLED | H2: H2-V05 | sigla_fisica | EQUALS parámetro `Unidad`; NON_NULLS_ONLY |
| F14 | ENABLED | H2: H2-V05 | desc_regional | CONTAINS todos los valores; NON_NULLS_ONLY |
| F15 | ENABLED | H2: H2-V05 | delito_descripcion | CONTAINS todos los valores; NON_NULLS_ONLY |
| F16 | ENABLED | H2: H2-V05 | tipo_conducta_descripcion | CONTAINS todos los valores; NON_NULLS_ONLY |
| F17 | ENABLED | Todas las hojas | fecha_medida | Entre `Fechainicio` y `Fechafin`, extremos incluidos; DAY; NON_NULLS_ONLY |
| F18 | ENABLED | H1: H1-V07 | descripcion_id_r_edad | EQUALS parámetro `EDAD`; NON_NULLS_ONLY |
| F19 | ENABLED | H1: H1-V08 | descripcion_sexo | EQUALS parámetro `genero`; NON_NULLS_ONLY |
| F20 | ENABLED | Todas las hojas | descripcion_profesion | EQUALS parámetro `Profesion`; NON_NULLS_ONLY |
| F21 | ENABLED | Todas las hojas | descripcion_dependencia | EQUALS parámetro `estaciones`; NON_NULLS_ONLY |
| F22 | ENABLED | Todas las hojas | cuadrante | EQUALS parámetro `cuadrante`; NON_NULLS_ONLY |
| F23 | ENABLED | H2: H2-V11 | descripcion_articulo | CONTAINS `Artículo 5: Medidas de protección en casos de violencia intrafamiliar.`; `Articulo 5: Medidas de protección en casos de violencia intrafamiliar. `; `Articulo 5: Medidas de proteccion en casos de violencia intrafamiliar.`; NON_NULLS_ONLY |
| F24 | ENABLED | H2: H2-V04 | descripcion_articulo | CONTAINS `Medidas Opcionales`; ALL_VALUES |
| F25 | ENABLED | Todas las hojas | tipo_conducta_descripcion | EQUALS parámetro `conducta`; NON_NULLS_ONLY |
| F26 | ENABLED | H2: H2-V07 | counting | CONTAINS todos los valores; NON_NULLS_ONLY |
| F27 | ENABLED | Todas las hojas | REGION | EQUALS parámetro `Region`; NON_NULLS_ONLY |
| F28 | ENABLED | H2: H2-V03 | ACTIVIDAD | CONTAINS todos los valores; NON_NULLS_ONLY |
| F29 | ENABLED | H2: H2-V03 | cuadrante | EQUALS parámetro `cuadrante`; NON_NULLS_ONLY |
| F30 | ENABLED | H2: H2-V03 | descripcion_dependencia | EQUALS parámetro `estaciones`; NON_NULLS_ONLY |
| F31 | ENABLED | H2: todos los visuales | identificacion_interviniente | EQUALS parámetro `identificacion`; NON_NULLS_ONLY |
| F32 | ENABLED | Todas las hojas | identificacion_interviniente | EQUALS parámetro `identificacion`; NON_NULLS_ONLY |
| F33 | ENABLED | H2: H2-V03 | descripcion_tipo | CONTAINS todos los valores; NON_NULLS_ONLY |
| F34 | ENABLED | Todas las hojas | identificacion | EQUALS parámetro `identificacion`; NON_NULLS_ONLY |
| F35 | ENABLED | H3: todos los visuales; H4: todos los visuales | identificacion_interviniente | EQUALS parámetro `identificacion`; NON_NULLS_ONLY |
| F36 | DISABLED | H1: H1-V12 | auto_id | DOES_NOT_EQUAL cadena vacía; NON_NULLS_ONLY |
| F37 | DISABLED | H2: H2-V06 | auto_id | DOES_NOT_EQUAL cadena vacía; NON_NULLS_ONLY |
| F38 | ENABLED | H2: H2-V01 | ACTIVIDADES | EQUALS parámetro `Actividades`; NON_NULLS_ONLY |
| F39 | ENABLED | H2: H2-V03 | ACTIVIDADES | EQUALS parámetro `Actividades`; NON_NULLS_ONLY |
| F40 | ENABLED | H4: H4-V01 | ruta_null | EQUALS 0.0; ALL_VALUES |
| F41 | ENABLED | H3: H3-V01 | ruta_null | EQUALS 1.0; ALL_VALUES |
| F42 | ENABLED | H1: H1-V12 | estado_medida | CONTAINS todos los valores; NON_NULLS_ONLY |
| F43 | ENABLED | Todas las hojas | estado_medida | CONTAINS todos los valores; NON_NULLS_ONLY |
| F44 | ENABLED | Todas las hojas | estado_auto | CONTAINS todos los valores; NON_NULLS_ONLY |
| F45 | ENABLED | Todas las hojas | tipo_medida | CONTAINS todos los valores; ALL_VALUES |
| F46 | ENABLED | H1: H1-V01 | nombres_policia | DOES_NOT_CONTAIN `NO REPORTADA`; `SIN`; `DIJIN`; `- DIJIN`; ALL_VALUES |

F13 declara alcance entre datasets `ALL_DATASETS`; los demás grupos declaran `SINGLE_DATASET`. El dashboard recibido declara un solo dataset.

## Publicación e interacciones

- Exportación CSV habilitada; exportación con campos ocultos deshabilitada.
- Filtros ad hoc deshabilitados y controles de hoja inicialmente colapsados.
- Menú de visual, maximización, ordenamiento de ejes, drill y tooltips habilitados.
- H1 contiene 14 acciones habilitadas de filtrado al hacer clic sobre un punto, hacia todos los visuales de la misma hoja.
- H2 contiene una acción equivalente en `DETALLE ACTIVIDADES` (H2-V07).
- Las cinco imágenes de contenido personalizado están configuradas con URL; no se descargaron ni se comprobaron en pantalla.

## Hallazgos para revisión

| Hallazgo | Evidencia | Implicación y validación pendiente |
|---|---|---|
| Parámetro eliminado | `FILTER_SOURCE_PARAMETER_NOT_FOUND` corresponde a F12, deshabilitado, sobre `counting` en H2-V05 | Configuración residual; no afirmar que afecta las cifras mientras está deshabilitado. Revisar en el análisis. |
| Columna inexistente | `COLUMN_NOT_FOUND` corresponde a F34, habilitado y global, sobre `identificacion` | No figura en los 47 campos ni en los 12 calculados. El campo existente es `identificacion_interviniente`; el calculado `Identificación` también tiene otro nombre. Confirmar corrección e impacto en pantalla. |
| Control con etiqueta discordante | `NÚMERO EXPEDIENTE` en H2 referencia F26 sobre `counting`, limitado a H2-V07 | No filtra `numero_expediente` según la definición; comprobar etiqueta y campo esperado. |
| Control Delito en H2 sin filtro por parámetro en esa hoja | F03 sólo alcanza H1; F05 y F15 no usan `Delito` | Comprobar qué cambia al seleccionar el control de H2. |
| Filtros repetidos | F09/F25; F31/F32/F35 y filtros locales frente a globales | Documentar la combinación efectiva; no eliminar duplicados sin revisión del análisis. |
| Diferencia entre autos calculados y KPI | `AUTOS` excluye vacíos; F36/F37 están deshabilitados | Conciliar con identificadores vacíos. |
| Actividades potencialmente repetidas | Máximo por medida usado con SUM | Confirmar grano y validar con medidas que tengan varias filas o intervinientes. |
| Documento clasificado por una cadena | F40/F41 y fórmula `ruta_null` | Probar NULL, cadena vacía, espacios y enlaces inaccesibles. Tener ruta no acredita documento disponible. |
| Identificación de policía | H1-V01 usa `Identificación`, que referencia `identificacion_interviniente` | Confirmar si debe mostrar identificación del interviniente o `identificacion_policia`. |
| Universo VIF sin regla global explícita | F23 limita únicamente `MEDIDAS DE PROTECCIÓN` | No afirmar que todos los datos del tablero sean VIF sin revisar el origen y reglas de negocio. |

## Diccionario de campos de salida

Tipos tomados de `OutputColumns`; los nombres documentan el esquema y no contienen valores de personas.

| Campo | Tipo | Subtipo |
| --- | --- | --- |
| fecha_medida | DATETIME | — |
| auto_id | STRING | — |
| id_literal | DECIMAL | FIXED |
| id_articulo | DECIMAL | FIXED |
| medida_id | STRING | — |
| numero_expediente | STRING | — |
| ruta | STRING | — |
| latitud | DECIMAL | FIXED |
| longitud | DECIMAL | FIXED |
| interviniente_id | STRING | — |
| cuadrante | STRING | — |
| nombres | STRING | — |
| apellidos | STRING | — |
| vigenteentidad | DECIMAL | FIXED |
| nombre_comisaria | STRING | — |
| telefono_comisaria | STRING | — |
| direccion_comisaria | STRING | — |
| descripcion_dependencia | STRING | — |
| sigla_fisica | STRING | — |
| desc_regional | STRING | — |
| counting | INTEGER | — |
| es_policia | DECIMAL | FIXED |
| descripcion_profesion | STRING | — |
| identificacion_interviniente | DECIMAL | FIXED |
| telefono_interviniente | DECIMAL | FIXED |
| tipo_medida | STRING | — |
| estado_medida | STRING | — |
| estado_auto | STRING | — |
| descripcion_escolaridad | STRING | — |
| descripcion_id_poblacion | STRING | — |
| descripcion_id_r_edad | STRING | — |
| descripcion_tipo | STRING | — |
| descripcion_raza | STRING | — |
| descripcion_sexo | STRING | — |
| descripcion_tipo_identifica | STRING | — |
| zona_descripcion | STRING | — |
| tipo_conducta_descripcion | STRING | — |
| delito_descripcion | STRING | — |
| descripcion_id_literal | STRING | — |
| descripcion_articulo | STRING | — |
| identificacion_policia | STRING | — |
| nombres_policia | STRING | — |
| apellidos_policia | STRING | — |
| descripcion_policia | STRING | — |
| estado_policia | STRING | — |
| grado_policia | STRING | — |
| verificacion_policia | STRING | — |

## Procedimiento de validación de datos

1. Confirmar tabla, origen, grano, llave de medida y significado de `counting`.
2. Registrar corte de fuente y última ingesta exitosa de SPICE, con zona horaria.
3. Restablecer las selecciones y reproducir los filtros globales y de cada visual, incluidos nulos y filtros deshabilitados.
4. Comparar conteos distintos de `medida_id`, `auto_id` e `interviniente_id` por periodo y unidad.
5. Validar `ACTIVIDADES` con una muestra autorizada de medidas con varias filas; comparar máximo por medida y suma del visual.
6. Comprobar los dos errores de exportación y el alcance de los controles discordantes en pantalla.
7. Registrar resultados agregados, diferencia, justificación, responsable y fecha. No guardar registros personales ni rutas reales de documentos.

No se adjuntan consultas de conciliación ejecutables porque faltan el grano, el origen Policía y las reglas completas previas a SPICE.
