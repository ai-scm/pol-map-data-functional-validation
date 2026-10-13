# Documentación técnica — 02. Comparativo Delictivo (Datos crudos)

## Activos y fuente lógica

| Elemento | Valor verificado |
|---|---|
| Dashboard y análisis | `pon-prod-ied-comparativo-delictivo` |
| Versión publicada | 43, publicada el 2026-10-07 (la anterior, 42, era del 2026-04-08) |
| Tema | `IAPOL · azul y lima` (antes `CLASSIC`) |
| Conjunto de datos principal | `vw_delitos_corregido_schema_temporal`; dentro del análisis se identifica como `delitos_agrupaciones` |
| Conjunto de datos secundario | `Datos_poblacionales_ciudad` (archivo CSV cargado manualmente; solo aporta población) |
| Modo | SPICE, recarga completa diaria a las 04:00 a. m. |
| Hojas publicadas | Comparativo Delictivo (Datos crudos) y Mapa por delito |

No se versionan identificadores técnicos del dashboard ni URL internas; la ruta funcional es la referencia estable.

## Cadena de datos

| Paso | Hora | Componente | Qué hace |
|---|---|---|---|
| 1 | — | Oracle SIEDCO, `USR_ESTA.MOTIVOSPOLICIA` | Tabla de origen en la Policía. |
| 2 | 01:00 a. m. | Job de Glue `pon-prod-full-siedco-motivospolicia-temporal` | Carga completa: lee toda la tabla, convierte las columnas a texto y sobrescribe `raw_data_siedco_full_delitos` en S3. Desde el 2026-10-09 valida el volumen antes de escribir. |
| 3 | — | Vista de Athena `pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal` | Convierte tipos y agrega columnas derivadas. No hace cruces con otras tablas. |
| 4 | 04:00 a. m. | Conjunto de datos de Quick (SPICE) | Importa la vista y agrega las columnas calculadas `tipo_unidad` y `cai`. |
| 5 | En línea | Dashboard `pon-prod-ied-comparativo-delictivo` | Aplica filtros, parámetros y medidas. |

La misma vista alimenta las capas SIEDCO del mapa (job de las 04:30 a. m.). Ver [`SIEDCO`](../../anticipacion-a-fenomenos-de-seguridad/mapa-de-anticipacion-a-fenomenos-de-seguridad/Modulos/Mapa/FuentesInternas/SIEDCO/README.md).

## Grano y campos principales

El grano es **una persona asociada a un hecho**: un hecho con varias víctimas o capturados ocupa varias filas con el mismo `hechos_id`. Los indicadores cuentan filas, no hechos distintos.

| Grupo | Campos observados |
|---|---|
| Identificación | `hechos_id`, `tematica`, `tipo_lista_conducta` (`DE` delitos, `SP` servicio de policía, `OT` otros), `descripcion_conducta`, `delito_asociado` |
| Tiempo | `fecha_hecho`, `anio`, `hora_hecho`, `hora_24`, `dia_semana`, `nosemana`, `turno`, y los derivados `semana_anio`, `turno_clasificado`, `periodo_3sem` |
| Jurisdicción | `juris.región`, `juris.metropolitana / depto`, `juris.distrito / seccional`, `juris.estación / área`, `juris.cai`, `juris.dependencia` |
| Unidad que conoce o captura | `perte.región`, `perte.metropolitana / depto`, `perte.estación / área`, `perte.cai`, `perte.dependencia`, `sigla_undepertenece`, `sigla_undeconoce` |
| Lugar | `depto_hecho`, `municipio_hecho`, `barrios_hecho`, `zona`, `clase_sitio`, `agrupacion_clase_sitio`, `latitud`, `longitud`, `codigo_dane` |
| Hecho | `modalidad`, `armas_medios`, `causas_lesion_muerte_persona`, `conductas_especiales`, `movil_agresor`, `movil_victima` |
| Persona | `genero`, `edad`, `estado_civil_persona`, `grado_instruccion_persona`, `pais_persona`, `agrupa_clase_empleado` |
| Operativo | `circunstancia_captura`, `situacion_juridica`, `clase_bien`, `tipo_bien`, `cantidad`, `unidad_medida`, `valor`, `permiso_arma`, `marca`, `descripcion_lineamarca` |
| Calculados en el conjunto de datos | `tipo_unidad`, `cai`, `orden-Estadistica-calculada` |

En Oracle las 58 columnas son `VARCHAR2`; `FECHA_HECHO` es texto con formato `DD/MM/YYYY`.

## Parámetros y filtros

| Hoja | Alcance | Regla observada | Estado |
|---|---|---|---|
| Ambas | Análisis | `FechaInicio` (por defecto, inicio del año en curso) y `FechaFin`; controles `Desde` y `Hasta`. | Confirmado |
| Ambas | Análisis | `Región`, `Estación` y `Cuadrante` filtran por parámetro sobre `juris.región`, `juris.estación / área` y `juris.dependencia`. | Confirmado |
| Ambas | Análisis | `Unidad`, `Ciudad-Municipio` y `Género` filtran por lista sobre `juris.metropolitana / depto`, `municipio_hecho` y `genero`. | Confirmado |
| Ambas | Análisis | `Zona` filtra por parámetro sobre `zona`. | Confirmado |
| Ambas | Por hoja | `Delito de análisis` filtra `tematica` mediante el parámetro `Delito` (un filtro por hoja). No aplica a capturas ni incautaciones. | Confirmado |
| Comparativo Delictivo | Visuales de delitos | `tipo_lista_conducta = 'DE'`, fijo. Su control está oculto y solo sirve para que las listas muestren valores de delitos. | Confirmado |
| Comparativo Delictivo | Visuales de capturas | `tematica = 'CAPTURAS'`. | Confirmado |
| Comparativo Delictivo | Visuales de incautaciones | `tematica` igual a `INCAUTACION DROGA`, `INCAUTACION ARMAS DE FUEGO` o `MERCANCIA INCAUTADA`, según el visual. | Confirmado |
| Comparativo Delictivo | Tres gráficas de homicidio | `tematica = 'HOMICIDIO DOLOSO O INTENCIONAL'`, fijo, con control propio de año. | Confirmado |
| Ambas | Todas | `Modalidad`, `Arma`, `Sitio`, `Causas`, `Día de la semana`, `Hora`, `Mes`, `Turno`, `Día` y `Nacionalidad` aplican en ambas hojas. | Confirmado |
| Mapa por delito | Hoja | `CAI` (columna `cai`), `Cuadrante` y `Tipo de unidad` (columna `tipo_unidad`). | Confirmado |
| Mapa por delito | Visual del mapa | `latitud` distinta de cero. | Confirmado |

Un filtro de Quick que cubre varias hojas debe aplicar a todos los visuales de cada hoja. Por eso los filtros que no deben alcanzar a capturas e incautaciones (`Delito de análisis` y el filtro de solo delitos) están definidos por hoja y sobre visuales seleccionados.

Los controles que comparten hoja con sus visuales pero están lejos en el desplazamiento (por ejemplo `Modalidad` o `Hora`) cambian los indicadores superiores sin que el control quede a la vista. Quick no ofrece un indicador de filtros activos.

## Lógica por hoja

### Comparativo Delictivo (Datos crudos)

Medidas base, todas sobre el conteo de filas:

| Medida | Definición |
|---|---|
| `FECHA_ACTUAL` | 1 si `fecha_hecho` está entre `FechaInicio` y `FechaFin`; 0 en otro caso. |
| `FECHA_ANIO_ANTERIOR` | 1 si `fecha_hecho` está en el mismo rango desplazado un año atrás. |
| `TOTAL_FECHA_ACTUAL`, `TOTAL_FECHA_ANIO_ANTERIOR` | Suma de las anteriores. |
| `DIFERENCIA`, `DIFERENCIA PORCENTUAL` | Actual menos anterior, y su proporción sobre el anterior. |
| `TotalAñoAnterior` | Año calendario anterior completo, sin importar el rango `Desde`/`Hasta`. Alimenta el indicador `TOTAL AÑO ANTERIOR`. |
| `PROMEDIO_DIARIO` | Registros del rango dividido por los días del rango. |
| `forecast` (`PRONÓSTICO ANUAL`) | Promedio diario proyectado a los días que faltan del año, más lo acumulado. Es una proyección lineal. |

El indicador `TOTAL AÑO ANTERIOR` no debe coincidir con la columna “año anterior” de los comparativos: el primero es el año calendario completo y la segunda es el mismo rango un año atrás.

Medidas de capturas (`CAPTURAS_ACTUAL`, `CAPTURAS_ANTERIOR`, `CAPTURAS_DIF`, `CAPTURAS_VAR`, `CAPTURAS_FLAGRANCIA`, `CAPTURAS_ORDEN`, `CAPTURAS_HOMBRES`, `CAPTURAS_MUJERES`, `CAPTURAS_PCT_TOTAL`): usan el mismo rango de fechas y `circunstancia_captura` para separar flagrancia de orden judicial.

Medidas de incautaciones (`INC_REG_*`, `INC_CANT_*`, `INC_KG_*`, `INC_VALOR_MILLONES`): registros, cantidad (`cantidad`) y valor (`valor`). La droga se muestra en kilogramos: SIEDCO la registra en gramos y la medida divide entre 1.000.

### Mapa por delito

Los puntos usan `latitud` y `longitud` de los hechos del rango actual y del mismo rango del año anterior. Antes de comparar cantidades con la hoja principal se debe descontar lo que el mapa excluye: registros con latitud en cero.

## Cambios realizados (octubre de 2026)

### Origen

En una sesión de verificación con la supervisión del contrato se reportó que las cifras del tablero no coincidían con la información de la Policía y que los filtros no se aplicaban de forma coherente: al elegir una unidad aparecían municipios de otras, en el mapa `Unidad` mezclaba departamentos y metropolitanas, y `CAI` listaba estaciones.

### Filtros (2026-10-06 y 2026-10-07)

| Cambio | Antes | Después |
|---|---|---|
| Filtros duplicados | Región, Unidad, Municipio, Estación, Cuadrante y Género tenían dos filtros independientes cada uno: el de la fila superior y otro dentro de una sección. Ambos se aplicaban a la vez. | Un solo filtro por columna; se conservan los de la fila superior. |
| Cascada en `Mapa por delito` | Ningún control restringía a los demás; con `Unidad = M. BOGOTÁ` se podía elegir una estación de Boyacá. | Cada control muestra solo valores relevantes. |
| Control `CAI` | Filtraba por `juris.dependencia`, que contiene cuadrantes. | Filtra por la columna `cai`. El control de cuadrantes sigue disponible con el título `Cuadrante`. |
| Valores vacíos de CAI | Aparecían como `NULL`. | Aparecen como `SIN CAI` y se pueden seleccionar. |
| Tipo de unidad | No existía. | Control `Tipo de unidad` (Metropolitana o Departamento) que restringe la lista de `Unidad`. |
| Control de `tipo_lista_conducta` | Visible y editable al final de la hoja. | Oculto; el filtro queda fijo en delitos. |
| `Delito de análisis` | Filtro de lista sobre todas las hojas. | Filtro por el parámetro `Delito`, para que no deje vacías las secciones de capturas e incautaciones. Se usa igual y mantiene la selección entre hojas. |
| Tabla `RANGO DE EDAD VÍCTIMAS` | Tenía un campo de fila que apuntaba a una columna inexistente (error `COLUMN_NOT_FOUND`). | Se retiró el campo; el dashboard quedó sin errores de definición. |

Columnas calculadas agregadas al conjunto de datos (cambio aditivo; no afecta otros análisis):

| Columna | Expresión | Motivo |
|---|---|---|
| `tipo_unidad` | `METROPOLITANA` si `juris.metropolitana / depto` empieza por `M. `; en otro caso `DEPARTAMENTO`. | Un campo calculado del análisis no puede restringir la lista de otro control; debe ser una columna del conjunto de datos. |
| `cai` | `juris.cai`, o `SIN CAI` si viene vacío. | Quick muestra `NULL` en la lista mientras la columna tenga vacíos. |

### Secciones nuevas en la hoja Comparativo Delictivo (2026-10-07)

- **Capturas:** cuatro indicadores, capturas por mes, por rango de edad, por región o dirección que captura, por unidad que captura, por unidad con jurisdicción (flagrancia y orden judicial), por estación y por dependencia que captura.
- **Caracterización de las capturas:** por delito (`delito_asociado`, con el artículo en columna aparte), por género, por zona y por situación jurídica.
- **Detalle de las incautaciones:** panel de droga con imagen (cocaína, marihuana, base de coca, basuco y heroína), droga por mes, droga por unidad, armas de fuego por tipo de arma y permiso, incautaciones por tipo de bien y detalle por clase de bien.

Las tablas nuevas muestran diferencia con flecha, porcentaje de variación, barra de magnitud en el año actual y fila de total.

Columnas usadas, verificadas contra la referencia de la Policía:

| Tabla | Columna | Nota |
|---|---|---|
| Capturas por estación | `juris.estación / área`, junto con la unidad | En el país hay estaciones con el mismo nombre en varias unidades; la unidad evita sumarlas en una fila. |
| Capturas por dependencia que captura | `perte.dependencia` | Unidad a la que pertenece quien captura. |
| Capturas por región y por unidad | `perte.región` y `sigla_undepertenece` | Región y unidad de quien captura, no del lugar del hecho. |
| Rango de edad | Hasta 12, 13 a 17, 18 a 28, 29 a 59, 60 o más, sin edad | Los dos primeros cortes son los de la referencia de la Policía. |
| Droga | `tematica = 'INCAUTACION DROGA'` y `clase_bien` | SIEDCO repite la droga dentro de `MERCANCIA INCAUTADA`; las tablas de “todos los bienes” la incluyen de nuevo para mostrar el inventario completo. |

El panel de droga es una imagen de fondo (encabezados e íconos) con una tabla de una sola fila por droga encima. Cada fila mide 128 px: Quick no dibuja tablas en contenedores de menor altura.

No se incluyen recuperaciones (`MERCANCIA RECUPERADA`, `MOTOCICLETAS RECUPERADAS`, `AUTOMOTORES RECUPERADOS`), que sí aparecen en las capas del mapa.

### Presentación (2026-10-07)

- Paleta azul oscuro y verde lima en todo el tablero mediante el tema `IAPOL · azul y lima` y el reemplazo de los colores fijos.

| Uso | Color |
|---|---|
| Encabezados, cifras e inicio de la paleta de gráficas | `#0A1F6B` |
| Títulos y acentos | `#1639A8` |
| Barras de magnitud, rellenos y segunda serie | `#C8F000` |
| Flechas y porcentajes en positivo | `#6E9A00` |
| Baja o alerta | `#E5484D` |
| Sin variación y fondos suaves | `#DCE3F7` |

- Se reemplazaron las imágenes del encabezado y del panel del comparativo por las versiones en la nueva paleta, ajustadas a la proporción de las originales para conservar la alineación de los indicadores. La franja de íconos de zona y género se recoloreó.
- El encabezado dejó de cargarse desde una dirección externa: ahora es una imagen almacenada en Quick, en ambas hojas.

### Despliegue (2026-10-07)

1. Los cambios se construyeron y validaron en una copia del análisis, sin tocar producción.
2. Se actualizó el análisis de producción con la definición validada.
3. Se creó la versión 43 del dashboard y se publicó. Los permisos no cambiaron.
4. Antes de publicar se restablecieron a `Todo` las selecciones guardadas durante las pruebas.

Volver a la versión 42 es inmediato desde el historial de versiones del dashboard.

Durante el trabajo se evaluó eliminar o fusionar visuales (gráficas de homicidio, comportamiento diario, turno de servicio, nacionalidad y las cuatro tablas por unidad, ciudad, estación y CAI). Se retiraron en la copia de trabajo y luego **se restauraron en su posición original**: la versión publicada conserva todos los visuales anteriores.

## Validaciones ejecutadas

### Policía frente a Athena (2026-10-07)

| Corte | Oracle | Athena |
|---|---:|---:|
| 2025, delitos (`DE`) | 818.809 | 818.809 |
| 2026, delitos (`DE`) | 631.692 | 631.692 |
| 2025, servicio de policía (`SP`) | 535.122 | 535.122 |
| 2026, servicio de policía (`SP`) | 456.724 | 456.724 |

También coinciden las 19 temáticas de delitos de `M. BOGOTÁ` entre el 2026-01-01 y el 2026-09-30.

### Indicadores del tablero frente a la fuente (2026-10-07)

| Caso | Filtros | Año anterior | Año actual |
|---|---|---:|---:|
| 1 | Unidad `M. BOGOTÁ`, delito `HOMICIDIO DOLOSO O INTENCIONAL`, 2026-01-01 a 2026-09-30 | 883 | 818 |
| 2 | Lo anterior con estación `ESTACION E-03 SANTA FE`, género `FEMENINO` y delito `HURTO PERSONAS` | 2.290 | 2.263 |

En ambos casos la consulta en Oracle debe incluir `tipo_lista_conducta = 'DE'` y contar filas.

### Capturas e incautaciones frente a la referencia de la Policía (2026-10-07)

- Capturas de `ESTACION OCAÑA`: 470, con 349 en flagrancia y 121 por orden judicial, igual que la referencia.
- Capturas del país entre el 2026-01-01 y el 2026-09-30: 163.925 (163.254 en el mismo periodo de 2025).
- Cocaína incautada en el mismo periodo: 405.787 kg (380.191 kg en 2025).

### Conciliación con las capas SIEDCO del mapa (2026-10-09)

Delitos de `M. SOACHA` entre el 2026-04-15 y el 2026-10-07, cruzados registro por registro:

| Concepto | Registros |
|---|---:|
| Tablero (por jurisdicción) | 7.511 |
| Menos accidentes de tránsito, que el mapa no incluye | −324 |
| Menos registros sin coordenada | −17 |
| Menos registros con coordenada fuera del polígono de la unidad | −182 |
| Más registros de otra unidad con coordenada dentro del polígono | +85 |
| Mapa (tres capas, dentro del polígono) | 7.073 |

No quedó ninguna diferencia sin explicar. Descontando los accidentes de tránsito, la diferencia es del 1,6 % y se debe a registros cuya coordenada no corresponde a su jurisdicción.

## Diferencias conocidas frente al mapa

El tablero y las capas SIEDCO parten de la misma vista, pero no muestran las mismas cantidades:

| Aspecto | Tablero | Mapa |
|---|---|---|
| Periodo | 2025 y 2026 completos | Últimos 6 meses |
| A qué unidad pertenece un hecho | Columna de jurisdicción | Polígono dentro del cual cae la coordenada |
| Accidentes de tránsito | Incluidos como delitos | Excluidos |
| Registros sin coordenada | Incluidos | Excluidos |
| Capturas, incautaciones y recuperaciones | En secciones aparte; sin recuperaciones | Mezcladas en las mismas capas |
| Turno | `turno_clasificado`, cuatro franjas de seis horas | Tres turnos operativos (22–07, 07–14 y 14–22) |

## Novedades de calidad de datos en la fuente

Medidas el 2026-10-07 sobre `USR_ESTA.MOTIVOSPOLICIA` (2.442.444 registros). Las consultas están en [`sql/policia.sql`](sql/policia.sql), con el mismo código de novedad.

| Código | Novedad | Resultado | Efecto en el tablero |
|---|---|---|---|
| N01 | Edad vacía en delitos contra las personas | Violencia intrafamiliar 11,3 %; lesiones en accidente de tránsito 23,8 %; delitos sexuales 19,2 % | Rango de edad incompleto |
| N02 | Edades imposibles | 838 en cero, 56 mayores de 100, 27 negativas | Rangos distorsionados |
| N03 | Género vacío | Extorsión 11,4 %; violencia intrafamiliar 2.102 registros | Porcentajes por género no suman el total |
| N04 | País de la persona no reportado | 48,6 % de los delitos de 2025 | Nacionalidad poco útil |
| N05 | Coordenadas en cero o inválidas | 4.817 en cero, 25 casi nulas, 3 fuera del país | No aparecen en el mapa |
| N06 | Municipio que no corresponde a la unidad | 106 municipios, 427 registros | Municipios ajenos en la lista al filtrar una unidad |
| N07 | Cuadrante “pendiente por asignar” | 68.943 registros de delitos | Aparece como cuadrante |
| N08 | Cuadrante con valores que no son cuadrantes | 60.325 registros con nombre de estación | Estaciones en el filtro de cuadrantes |
| N09 | CAI vacío o con otros valores | 89.645 vacíos; 287.707 con código de cuadrante | El filtro `CAI` lista subestaciones y códigos fuera de Bogotá |
| N10 | Estación con valores que no son estaciones | 30.770 “pendiente por asignar”, más distritos especiales | Valores ajenos en el filtro `Estación` |
| N11 | Estaciones con el mismo nombre en varias unidades | 81 nombres, 401.761 registros | Una tabla por nombre suma ciudades distintas |
| N12 | Un mismo hecho en varios delitos | 2026: 69.015 hechos en dos o más temáticas | Con `Delito de análisis = Todo` se cuentan más de una vez |
| N13 | Varios registros por hecho | Violencia intrafamiliar: 14.853 registros más que hechos en 2026 | El tablero cuenta personas, no hechos |
| N14 | Posibles registros duplicados | 11.157 grupos de filas idénticas | Requiere revisión: pueden ser varias personas sin identificar |
| N15 | Causa vacía en homicidios y lesiones | Lesiones en accidente de tránsito 79,6 % | Tabla de causa incompleta |
| N16 | Nombres con y sin tilde | 1.081 estaciones `ESTACION` y 15 `ESTACIÓN` | Orden y búsqueda inconsistentes |
| N17 | Departamentos y metropolitanas en una columna | 35 departamentos y 19 metropolitanas | `Unidad` los muestra juntos |
| N18 | Capturas sin situación jurídica | 581 sin dato; 4.434 pendientes por más de 30 días | Situación jurídica incompleta |
| N19 | Verificaciones de formato | Sin novedad en fechas, año, hora e identificador | — |

N06 usa una regla propia: se toma como unidad correcta de cada municipio la que concentra la mayoría de sus registros. Con una tabla oficial de estructura territorial la cifra puede cambiar.

## Incidente del 2026-10-09

`USR_ESTA.MOTIVOSPOLICIA` amaneció con 228.000 registros, solo de delitos. La carga de la 01:00 a. m. los copió sobre los datos buenos, terminó como exitosa, y la recarga de SPICE de las 04:00 a. m. dejó el tablero publicado con esa versión incompleta: cifras muy por debajo de las reales y las secciones de capturas e incautaciones vacías.

- 09:42 a. m.: se relanzó la carga con la validación de volumen. La rechazó en sus cuatro intentos sin modificar los datos.
- 09:56 a. m.: se restauró `raw_data_siedco_full_delitos` desde la copia del pipeline incremental (2.410.854 registros, hechos hasta el 2026-10-07).
- Hacia las 10:00 a. m.: se recargó SPICE con 2.410.854 registros.

El detalle del incidente y del control agregado al job de carga está en la sección 12 de [`SIEDCO`](../../anticipacion-a-fenomenos-de-seguridad/mapa-de-anticipacion-a-fenomenos-de-seguridad/Modulos/Mapa/FuentesInternas/SIEDCO/README.md). Mientras la Policía no recargue la tabla en Oracle, el tablero no recibe datos nuevos.

## Reglas de conciliación recomendadas

1. Comparar `COUNT(*)` y `COUNT(DISTINCT hechos_id)`: el tablero usa el primero.
2. Incluir siempre `tipo_lista_conducta = 'DE'` al reproducir indicadores de delitos.
3. Usar el mismo rango de fechas y recordar que “año anterior” es el mismo rango desplazado un año, salvo en `TOTAL AÑO ANTERIOR`.
4. No sumar temáticas para obtener un total de hechos: un hecho puede estar en varias.
5. Al comparar con el mapa, aplicar primero la tabla de diferencias conocidas.
6. Registrar la fecha de la carga de la 01:00 a. m. y de la recarga de SPICE; el tablero muestra datos de la madrugada.

## Asuntos pendientes

- Regla oficial de conteo cuando `Delito de análisis = Todo` (hechos repetidos entre temáticas).
- Jerarquía oficial unidad–municipio. Corregir la lista de municipios requiere marcar los registros inconsistentes en la vista de Athena.
- Recarga de `USR_ESTA.MOTIVOSPOLICIA` por parte de la Policía tras el incidente del 2026-10-09.
- Prueba del tablero con un usuario lector y medición del tiempo de carga: la hoja principal tiene 62 visuales y cerca de 17.000 px de alto. Si resulta lenta, separar capturas e incautaciones en hojas propias.
- Ubicar en la fila superior los filtros que hoy actúan sin estar a la vista.
- Decidir si se agrega un bloque de recuperaciones.
- Alerta por correo cuando la carga diaria sea rechazada.
- El conjunto `Datos_poblacionales_ciudad` es un archivo cargado a mano y no se puede exportar ni respaldar junto con el tablero.

## Consultas Athena orientativas

Usan campos y reglas confirmados. Reemplazar los marcadores `<...>` antes de ejecutar.

### Indicadores 2025 / 2026 y diferencia

```sql
-- Reproduce el recuadro de año anterior y año actual para un rango y una unidad.
SELECT
    SUM(CASE WHEN fecha_hecho BETWEEN DATE '<inicio>' AND DATE '<fin>' THEN 1 ELSE 0 END) AS anio_actual,
    SUM(CASE WHEN fecha_hecho BETWEEN DATE '<inicio>' - INTERVAL '1' YEAR
                                  AND DATE '<fin>'    - INTERVAL '1' YEAR THEN 1 ELSE 0 END) AS anio_anterior
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tipo_lista_conducta = 'DE'
  AND "juris.metropolitana / depto" = '<unidad>'
  AND (<todos_los_delitos> OR tematica = '<delito>');
```

### Registros frente a hechos distintos

```sql
-- El tablero cuenta registros; comparar con hechos distintos por delito.
SELECT
    tematica,
    COUNT(*)                  AS registros,
    COUNT(DISTINCT hechos_id) AS hechos_distintos
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tipo_lista_conducta = 'DE'
  AND fecha_hecho BETWEEN DATE '<inicio>' AND DATE '<fin>'
GROUP BY tematica
ORDER BY registros DESC;
```

### Capturas por circunstancia

```sql
SELECT
    COUNT(*)                                                                      AS capturas,
    SUM(CASE WHEN circunstancia_captura LIKE 'FLAGRANCIA%' THEN 1 ELSE 0 END)     AS flagrancia,
    SUM(CASE WHEN circunstancia_captura LIKE 'ORDEN%'      THEN 1 ELSE 0 END)     AS orden_judicial
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tematica = 'CAPTURAS'
  AND fecha_hecho BETWEEN DATE '<inicio>' AND DATE '<fin>';
```

### Droga incautada en kilogramos

```sql
-- SIEDCO registra la cantidad en gramos.
SELECT
    clase_bien,
    COUNT(*)                AS incautaciones,
    SUM(cantidad) / 1000    AS kilogramos
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tematica = 'INCAUTACION DROGA'
  AND fecha_hecho BETWEEN DATE '<inicio>' AND DATE '<fin>'
GROUP BY clase_bien
ORDER BY kilogramos DESC;
```

> Pendiente antes de usar estas consultas como contrato: regla oficial de conteo para el total de delitos y jerarquía oficial unidad–municipio.

[Volver al submódulo](README.md)
