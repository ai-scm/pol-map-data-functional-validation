# SIEDCO

## 1. Identificación

<p align="center">

| Campo | Valor |
|---|---|
| ID | POL-MAPA-001 |
| Módulo | Fuentes Internas |
| Capa | Capas SIEDCO I, SIEDCO II y SIEDCO III |
| Frecuencia de actualización | Diaria |
| Hora de carga del Data Lake | 01:00 a. m. (extracción desde Oracle) y 04:30 a. m. (generación de las capas) |
| Última actualización del caso | 2026-10-13 |

</p>

## 2. Descripción

Las capas SIEDCO muestran los registros georreferenciados del Sistema de Información Estadístico, Delincuencial, Contravencional y Operativo de los últimos 6 meses: delitos (hurtos, homicidios, lesiones, violencia intrafamiliar, etc.) y actividad operativa (capturas, incautaciones y recuperaciones).

Hay una capa por turno operativo de la aplicación, según la hora del hecho (`hora_24`):

| Capa | Turno de la aplicación | Horas del hecho | Archivo que la alimenta |
|---|---|---|---|
| SIEDCO I | Primer turno | 22:00 a 06:59 | `Fuentes_externas_geojson/Disec/DisecDelitosTurno1.geojson` |
| SIEDCO II | Segundo turno | 07:00 a 13:59 | `Fuentes_externas_geojson/Disec/DisecDelitosTurno2.geojson` |
| SIEDCO III | Tercer turno | 14:00 a 21:59 | `Fuentes_externas_geojson/Disec/DisecDelitosTurno3.geojson` |

Hasta el 2026-10-08 las capas se armaban con la columna `turno` de SIEDCO (`1 PRIMERO`, `2 SECUNDO`, `3 TERCERO`), que divide el día en cuatro franjas de seis horas. El turno `4 CUARTO` (18:00 a 23:59) no llegaba a ninguna capa. El cambio está en la sección 11.5.

Desde el 2026-10-06 cada registro sale clasificado por temática (`categoria`, `subcategoria` y `detalle`) y el servicio permite filtrar por ellas. El detalle está en la sección 11.

## 3. Ruta de acceso

1. Ingresar al aplicativo `IAPOL`.
2. Abrir el módulo `Anticipación a Fenómenos de Seguridad`.
3. Seleccionar el submódulo `Mapa de Anticipación a Fenómenos de Seguridad`.
4. Ingresar a `Mapa`.

- Ruta resumida:

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`

## 4. Activación de la capa

1. Seleccionar `Sigla y/o unidad hija`
2. Abrir el modulo de `fuentes internas`.
3. Activar la capa `SIEDCO I`, `SIEDCO II` o `SIEDCO III`.
4. Aplicar los filtros requeridos.

## 5. Parámetros y filtros de prueba

<p align="center">

| Parámetro | Valor utilizado | Obligatorio |
|---|---|---|
| Sigla | MESOA | Si |
| Unidades hijas | 64599 | No |
| Capa | SIEDCO III (tercer turno, hechos de 14:00 a 21:59) | Si |
| Categoría | Todas | No |
| Subcategoría | Todas | No |
| Detalle | Todos | No |
</p>

Los tres últimos son los filtros nuevos del servicio (sección 11.3). Aceptan varios valores separados por coma y no distinguen mayúsculas.

## 6. Fuente de datos

El dato recorre esta cadena:

| Paso | Hora | Componente | Qué hace |
|---|---|---|---|
| 1 | — | Oracle SIEDCO, `USR_ESTA.MOTIVOSPOLICIA` | Tabla de origen en la Policía. |
| 2 | 01:00 a. m. | Job de Glue `pon-prod-full-siedco-motivospolicia-temporal` | Copia la tabla completa a S3 (`raw_data_siedco_full_delitos`). |
| 3 | — | Vista de Athena `vw_delitos_corregido_schema_temporal` | Convierte tipos y agrega columnas calculadas. |
| 4 | 04:30 a. m. | Job de Glue `pon-prod-xcrime-update-fuentes-internas` | Consulta la vista por turno operativo (hora del hecho), clasifica por temática y genera los tres GeoJSON. |
| 5 | En línea | Servicio `XCrimeAppServicios`, `externalLayers/get/{id}` | Lee el GeoJSON completo, lo recorta al rectángulo que encierra el polígono de la unidad y aplica los filtros de temática. |
| 6 | En línea | Front `pon-XCrimeApp` | Recorta lo recibido con el polígono real de la unidad y aplica el filtro de fechas. |

La misma vista de Athena alimenta el tablero `02. Comparativo Delictivo (Datos crudos)`, documentado en [`informacion-estadistica-delictiva`](../../../../../../informacion-estadistica-delictiva/comparativo-delictivo-datos-crudos/README.md).

### Base de datos de la Policía

- Sistema o base de datos: SIEDCO (Oracle)
- Esquema: USR_ESTA
- Tabla o vista: MOTIVOSPOLICIA
- Conexión de Glue: `pon-prod-raw-siedco-connection`
- Consulta a DB Policia: [Oracle.sql](SQL/2.Oracle.sql)
- Query Oracle:

``` sql
SELECT tematica, COUNT(*) AS registros
FROM usr_esta.motivospolicia
GROUP BY tematica
ORDER BY registros DESC;
```

Características de la tabla (medidas el 2026-10-06):

- 2.434.659 filas y 58 columnas, todas `VARCHAR2`. Contiene solo 2025 y 2026.
- `FECHA_HECHO` es texto con formato `DD/MM/YYYY`; para filtrar por rango se convierte con `TO_DATE`.
- 29 temáticas (`TEMATICA`) y cuatro turnos (`TURNO`).
- No tiene índices: toda consulta recorre la tabla completa.
- El usuario de la conexión solo tiene permiso de lectura sobre esta tabla.

El query completo que clasifica por temática está en [Oracle.sql](SQL/2.Oracle.sql).

### Data Lake en Athena

- DataSource: AwsDataCatalog
- DataBase: pon_prod_raw_siedco_delitos_temporal
- Table: raw_data_siedco_full_delitos (copia cruda) y vw_delitos_corregido_schema_temporal (vista que usa el job)
- Ubicación en S3: `s3://pon-prod-raw-siedco-delitos-temporal/raw_data_siedco_full_delitos/`
- Consulta Athena: [athena.sql](SQL/1.Athena.sql)
- Query:

``` sql
SELECT *
FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal"
WHERE hora_24 BETWEEN 14 AND 21
AND fecha_hecho >= date '2026-04-06';
```

En la vista `fecha_hecho` ya es de tipo fecha, por lo que no necesita `TO_DATE`, y `hora_24` es numérica. Las condiciones por capa son `(hora_24 >= 22 OR hora_24 < 7)` para SIEDCO I, `hora_24 BETWEEN 7 AND 13` para SIEDCO II y `hora_24 BETWEEN 14 AND 21` para SIEDCO III. El query que ejecuta el job, con la clasificación por temática, está en [athena.sql](SQL/1.Athena.sql).

> Los archivos [athena.sql](SQL/1.Athena.sql) y [Oracle.sql](SQL/2.Oracle.sql) todavía filtran por `turno = '3 TERCERO'`; deben actualizarse a la condición por hora para reproducir las capas actuales.

### Servicio que consume el mapa

- Endpoint: `GET /XCrimeAppServicios/externalLayers/get/{id}?unidadID={unidad}`
- Catálogo de capas: tabla DynamoDB `pon_prod_external_layers` (el campo `key` es la ruta del GeoJSON en S3).
- ID de SIEDCO III: `616493ac-b3d2-4994-98d6-05423afa8414`.
- Repositorio: `pon-xcrime-appServices`, clase `ExternalLayersService`.
- Respuesta: `FeatureCollection` GeoJSON. Cada punto trae las columnas de la vista como propiedades; las que vienen nulas se omiten.

## 7. Validaciones funcionales

- [ ] La capa puede activarse y desactivarse.
- [ ] El detalle del punto muestra los campos definidos.
- [ ] El nombre y la descripción son correctos.
- [ ] Los filtros modifican la información mostrada.
- [ ] Los puntos aparecen en el área geográfica esperada.
- [ ] La leyenda y los colores corresponden a la capa.
- [ ] No se presentan errores al cargar la información.
- [x] La capa muestra delitos (hurtos, homicidios, violencia intrafamiliar) y no solo actividad operativa.
- [x] Cada punto trae las propiedades `categoria` y `subcategoria`.
- [ ] Los filtros `categoria`, `subcategoria` y `detalle` del servicio devuelven solo los registros esperados.
- [ ] El selector de temáticas está disponible en el mapa (front `pon-XCrimeApp`).

## 8. Validaciones de datos

- [ ] La fecha de actualización de Athena es la esperada.
- [x] Los filtros de negocio son equivalentes.
- [x] La cantidad total coincide.
- [ ] No existen identificadores duplicados.
- [ ] Una muestra de registros coincide entre ambas fuentes.
- [x] La cantidad mostrada en el mapa coincide con Athena. — Aprobado el 2026-10-09 para `M. SOACHA`, una vez aplicadas las reglas de la sección 13.

Resultado de la validación de la clasificación por temática (2026-10-06, turnos 1, 2 y 3, hechos desde el 2026-04-06): **494.735 registros en Athena y 494.735 en Oracle**, con las mismas 33 combinaciones de categoría, subcategoría y detalle y sin diferencias en ninguna.

| Categoría | Subcategoría | Registros |
|---|---|---|
| Capturas | Orden judicial | 12.861 |
| | Flagrancia | 68.979 |
| Vehículos recuperados | Automotores | 2.258 |
| | Motocicletas | 8.968 |
| Droga incautada | Cocaína | 5.226 |
| | Heroína | 156 |
| | Base de coca | 4.728 |
| | Bazuco | 5.997 |
| | Marihuana | 11.376 |
| Armas incautadas | Con permiso | 841 |
| | Sin permiso | 7.021 |
| Casos de mercancía | Recuperada | 11.146 |
| | Incautada (sin droga) | 65.038 |
| Delitos | 10 subcategorías | 290.160 |

Por turno: 196.509 (primero), 152.146 (segundo) y 146.080 (tercero).

Resultado después del cambio a turnos por hora (2026-10-08, hechos de los últimos 6 meses). Se contaron los registros de los tres GeoJSON generados y coinciden con la consulta equivalente en Athena:

| Capa | Antes (turno de SIEDCO) | Después (hora del hecho) | Horas presentes en el archivo |
|---|---:|---:|---|
| SIEDCO I | 198.156 | 180.732 | 22, 23 y 0 a 6 |
| SIEDCO II | 152.692 | 206.056 | 7 a 13 |
| SIEDCO III | 146.531 | 233.985 | 14 a 21 |
| Sin capa | 123.398 | 0 | — |
| Total | 620.777 | 620.773 | |

Los 4 registros de diferencia en el total no tienen coordenadas y el job los descarta.

Conciliación de las capas contra el tablero para una unidad (2026-10-09, delitos de `M. SOACHA`, unidad 64599, hechos del 2026-04-15 al 2026-10-07, cruce registro por registro):

| Concepto | Registros |
|---|---:|
| Athena, por jurisdicción (`juris.metropolitana / depto`) | 7.511 |
| Menos accidentes de tránsito, que las capas no incluyen | −324 |
| Menos registros sin coordenada | −17 |
| Menos registros con coordenada fuera del polígono de la unidad | −182 |
| Más registros de otra unidad con coordenada dentro del polígono | +85 |
| Mapa: tres capas, dentro del polígono | 7.073 |

No quedó ninguna diferencia sin explicar. La cantidad que muestra la aplicación en “Resumen de capas activas” se reprodujo exactamente para el periodo del 2026-10-01 al 2026-10-08: 57, 29 y 64 registros.

Notas para interpretar los conteos:

- Los conteos son filas, no hechos. Un hecho puede tener varias filas (varias personas o bienes), por lo que `hechos_id` se repite y no sirve como identificador único.
- SIEDCO registra los hechos con varios días de retraso. Los últimos 3 o 4 días siempre aparecen con menos registros y van subiendo con las cargas siguientes.

## 9. Criterios de aceptación

La prueba es exitosa cuando:

1. La capa carga sin errores.
2. La información corresponde al periodo seleccionado.
3. Athena y la fuente de Policía coinciden después de aplicar las reglas
   de transformación.
4. La cantidad del mapa coincide con el resultado esperado en Athena.
5. No existen diferencias sin justificación documentada.

## 10. Conclusión

La clasificación por temática que genera el job de Glue coincide exactamente con Oracle (494.735 registros en ambas fuentes el 2026-10-06). Las capas ya publican las propiedades `categoria`, `subcategoria` y `detalle`, y desde que se eliminó el top 10 del servicio el mapa muestra también los delitos.

Queda pendiente:

- Probar en producción los filtros `categoria`, `subcategoria` y `detalle` del servicio.
- Implementar el selector de temáticas en el front `pon-XCrimeApp`.
- Completar las capturas de pantalla de las secciones 4 y 6.
- La recarga de `USR_ESTA.MOTIVOSPOLICIA` por parte de la Policía (incidente del 2026-10-09, sección 12).
- Actualizar [athena.sql](SQL/1.Athena.sql) y [Oracle.sql](SQL/2.Oracle.sql) a la condición por hora del hecho (sección 11.5).
- Rediseño del servicio y del job (sección 11.6): archivos por mes y por unidad, con filtro de fechas en el servicio.

## 11. Cambios realizados (octubre de 2026)

### 11.1 Requerimiento

Implementar un filtro por temáticas en la capa "Fuentes Internas - SIEDCO" con estas categorías y subcategorías:

1. Capturas: orden judicial, flagrancia.
2. Vehículos recuperados: automotores, motocicletas.
3. Droga incautada: cocaína, heroína, base de coca, bazuco, marihuana.
4. Armas incautadas: con permiso, sin permiso.
5. Casos de mercancía: recuperada (sin vehículos), incautada (sin armas de fuego).
6. Delitos: homicidio, lesiones personales, hurto (personas, residencias, comercio, automotores, motocicletas, bancos, semovientes, celulares, bicicletas, cable), secuestro (simple, extorsivo), delitos sexuales, extorsión, piratería, terrorismo, violencia intrafamiliar, acciones subversivas.

### 11.2 Job de Glue `pon-prod-xcrime-update-fuentes-internas` (2026-10-06)

- Script: `s3://pon-prod-predicciones-auxiliar-script-bucket/pon_prod_update_fuentes_internas.py`.
- Respaldo de la versión anterior: `s3://pon-prod-predicciones-auxiliar-script-bucket/respaldo/pon_prod_update_fuentes_internas.2026-10-06.py`.
- La consulta de Athena agrega tres propiedades a cada registro: `categoria`, `subcategoria` y `detalle`.
- Solo salen los registros que caen en alguna subcategoría del requerimiento.
- No cambia la ventana de 6 meses, los tres archivos por turno ni las demás capas que genera el mismo job (IRIS P1, SIMEP, Gescov, MTRS y SIRAP).

Reglas de clasificación:

| Categoría | Subcategoría | Regla sobre las columnas de SIEDCO |
|---|---|---|
| CAPTURAS | ORDEN JUDICIAL | `tematica = 'CAPTURAS'` y `circunstancia_captura` empieza por `ORDEN JUDICIAL` (Ley 906 y Ley 600) |
| | FLAGRANCIA | `tematica = 'CAPTURAS'` y `circunstancia_captura` empieza por `FLAGRANCIA` |
| VEHICULOS RECUPERADOS | AUTOMOTORES | `tematica = 'AUTOMOTORES RECUPERADOS'` |
| | MOTOCICLETAS | `tematica = 'MOTOCICLETAS RECUPERADAS'` |
| DROGA INCAUTADA | COCAINA, HEROINA, BASE DE COCA, BAZUCO, MARIHUANA | `tematica = 'INCAUTACION DROGA'` y `clase_bien` igual a la droga (en SIEDCO bazuco está escrito `BASUCO`) |
| ARMAS INCAUTADAS | CON PERMISO, SIN PERMISO | `tematica = 'INCAUTACION ARMAS DE FUEGO'` y `permiso_arma` igual a `CON_PERMISO` o `SIN_PERMISO` |
| CASOS DE MERCANCIA | RECUPERADA | `tematica = 'MERCANCIA RECUPERADA'` y `tipo_bien` distinto de `VEHICULOS` |
| | INCAUTADA | `tematica = 'MERCANCIA INCAUTADA'`, `tipo_bien` distinto de `ARMAMENTO` y `clase_bien` distinto de las cinco drogas |
| DELITOS | HOMICIDIO | `tematica = 'HOMICIDIO DOLOSO O INTENCIONAL'` |
| | HURTO | Temáticas `HURTO ...`; el tipo queda en `detalle` (PERSONAS, RESIDENCIAS, COMERCIO, AUTOMOTORES, MOTOCICLETAS, BANCOS, SEMOVIENTES, CELULARES, BICICLETAS, CABLE) |
| | SECUESTRO | `SECUESTRO SIMPLE` y `SECUESTRO EXTORSIVO`; el tipo queda en `detalle` (SIMPLE, EXTORSIVO) |
| | PIRATERIA | `tematica = 'HURTO PIRATERIA'` |
| | Las demás | La subcategoría es la misma temática: LESIONES PERSONALES, DELITOS SEXUALES, EXTORSION, TERRORISMO, VIOLENCIA INTRAFAMILIAR, ACCIONES SUBVERSIVAS |

Decisiones de negocio tomadas:

- **Droga duplicada.** SIEDCO repite las incautaciones de droga en `INCAUTACION DROGA` y en `MERCANCIA INCAUTADA`, con los mismos conteos. Se excluyen de "Mercancía incautada" para que no aparezcan dos veces.
- **Accidentes de tránsito.** `HOMICIDIOS EN AT` y `LESIONES AT` no aplican y quedan por fuera de las capas.
- **Otras sustancias.** 2CB, éxtasis, anfetamina y hoja de coca no están en `INCAUTACION DROGA`; quedan en "Casos de mercancía → Incautada".
- **Exclusiones que no cambian el resultado.** `MERCANCIA RECUPERADA` no tiene registros de tipo `VEHICULOS` y `MERCANCIA INCAUTADA` no tiene registros de tipo `ARMAMENTO`: vehículos recuperados y armas ya van en sus propias temáticas.

### 11.3 Servicio `XCrimeAppServicios` (repositorio `pon-xcrime-appServices`)

Archivos: `ExternalLayersService.java` y `ExternalLayerREST.java`.

- **Se eliminó el top 10 de `delito_asociado`.** El servicio dejaba solo los 10 delitos asociados más frecuentes y descartaba los registros sin ese campo. Las temáticas de delitos lo traen vacío, por lo que ningún delito llegaba al mapa: solo se veía actividad operativa.
- **Filtros nuevos y opcionales** en `externalLayers/get/{id}`: `categoria`, `subcategoria` y `detalle`. Sin filtros, responde todos los registros de la unidad.

Ejemplos:

```
/externalLayers/get/{id}?unidadID=64599&categoria=DELITOS
/externalLayers/get/{id}?unidadID=64599&subcategoria=HURTO&detalle=CELULARES,PERSONAS
/externalLayers/get/{id}?unidadID=64599&categoria=DROGA INCAUTADA&subcategoria=MARIHUANA,BAZUCO
```

Efecto observado en SIEDCO III, unidad 64599:

| Fecha | Estado | Puntos | Temáticas |
|---|---|---|---|
| 2026-10-06 | Antes del cambio | 1.557 | 7, todas operativas |
| 2026-10-06 | Job de Glue actualizado, servicio anterior | 1.276 | 7, sin la droga duplicada |
| 2026-10-09 | Servicio sin top 10 | 5.761 | 20, incluidos delitos |

### 11.4 Front `pon-XCrimeApp`

En el popup de comparendos de la Consulta Integrada (`src/pages/MapPagePopups/GeneralPopup.js`) se fijó el orden de las propiedades y se agruparon en Hecho, Funcionario, Infractor y Testigos. Este cambio no es de SIEDCO; se documenta aquí porque se hizo en la misma jornada.

El selector de temáticas para las capas SIEDCO no está implementado.

### 11.5 Turnos por hora del hecho (2026-10-08)

**Problema.** SIEDCO divide el día en cuatro turnos de seis horas y la aplicación trabaja con tres turnos operativos, iguales en todo el país. El job copiaba los turnos 1, 2 y 3 de SIEDCO a las capas I, II y III sin convertir franjas:

| Turno en SIEDCO | Horas reales | Registros 2025–2026 | Capa que lo recibía |
|---|---|---:|---|
| `1 PRIMERO` | 00:00 a 05:59 | 732.798 | SIEDCO I |
| `2 SECUNDO` | 06:00 a 11:59 | 610.855 | SIEDCO II |
| `3 TERCERO` | 12:00 a 17:59 | 596.538 | SIEDCO III |
| `4 CUARTO` | 18:00 a 23:59 | 506.574 | Ninguna |

Consecuencias: los hechos de 18:00 a 23:59 (el 21 % del total) no llegaban al mapa, y los demás aparecían en un turno que no correspondía al de la aplicación. La fuente anterior (`disec-plano.delitos`) también traía cuatro turnos, por lo que el problema venía de origen.

**Cambio.** El job arma las tres capas por la hora del hecho, con los turnos de la aplicación:

| Capa | Condición en la consulta |
|---|---|
| SIEDCO I (primer turno) | `hora_24 >= 22 OR hora_24 < 7` |
| SIEDCO II (segundo turno) | `hora_24 BETWEEN 7 AND 13` |
| SIEDCO III (tercer turno) | `hora_24 BETWEEN 14 AND 21` |

- Script: `s3://pon-prod-predicciones-auxiliar-script-bucket/pon_prod_update_fuentes_internas.py`.
- Respaldo de la versión anterior: `s3://pon-prod-predicciones-auxiliar-script-bucket/respaldos/pon_prod_update_fuentes_internas.antes-turnos-por-hora-20261008.py`.
- No cambian los tres archivos, sus nombres, las columnas ni la clasificación por temática. No se modificó el servicio ni el front; el front no usa la propiedad `turno` de los registros.
- `hora_24` viene informada en todos los registros, por lo que ninguno queda sin capa.

**Resultado.** Las capas pasaron de 497.379 a 620.773 registros (sección 8). El archivo de SIEDCO III creció de 331 MB a 528 MB.

**Tiempo de respuesta.** Con los archivos nuevos, `externalLayers/get/{id}` respondió entre 15 y 22 segundos para la unidad 64599 (7 a 10,5 MB por capa). No se midió el tiempo antes del cambio, por lo que no se puede afirmar si varió. El servicio lee y recorre el archivo completo en cada consulta.

### 11.6 Revisión de diferencias frente al tablero (2026-10-08 y 2026-10-09)

Se revisaron una por una las diferencias entre las capas y el tablero `02. Comparativo Delictivo (Datos crudos)`:

| # | Diferencia | Decisión |
|---|---|---|
| 1 | Faltaba un turno completo | Corregida (sección 11.5). |
| 2 | Las capas solo traen los últimos 6 meses | Se mantiene. Ampliar la ventana agranda los archivos en proporción: con todo el histórico SIEDCO III pasaría de 0,5 GB a cerca de 1,9 GB. Queda para el rediseño. |
| 3 | Se excluyen accidentes de tránsito y la droga repetida | Se mantiene. |
| 4 | Las capas incluyen capturas, incautaciones y recuperaciones | Sin cambios. Todos los registros operativos quedan clasificados; solo sale la droga repetida. |
| 5 | El servicio recorta por el rectángulo de la unidad | Sin cambios. El servicio devuelve registros de unidades vecinas (para la unidad 64599, el 33 % eran de `M. BOGOTÁ`), pero el front los descarta con el polígono real y no se muestran. El efecto es tráfico desperdiciado, no datos erróneos. |
| 6 | Solo registros con coordenadas | Inherente al mapa. |
| 7 | “Turno” no significaba lo mismo | Resuelta para el mapa con la sección 11.5. |

**Rediseño pendiente.** Para ampliar el histórico y reducir el tiempo de respuesta sin cargar archivos de medio GB:

1. Que el job parta los archivos por mes y, de ser posible, por unidad usando la jurisdicción.
2. Que el servicio reciba `fechaDesde` y `fechaHasta` y lea solo los archivos necesarios. Los parámetros deben ser opcionales para no romper el front actual.
3. Que el front envíe las fechas y avise cuando se pide un rango sin datos: hoy permite elegir fechas anteriores a los 6 meses y el mapa sale vacío sin aviso.

Antes de filtrar por jurisdicción en lugar de geografía se debe confirmar con los usuarios si necesitan ver los hechos del borde con la unidad vecina.

## 12. Incidente del 2026-10-09: carga incompleta en Oracle

**Qué pasó.** `USR_ESTA.MOTIVOSPOLICIA` amaneció con 228.000 filas y 3 temáticas (`LESIONES PERSONALES`, `LESIONES AT`, `HOMICIDIOS EN AT`), frente a 2.434.659 filas y 29 temáticas del 2026-10-06. No quedó ningún registro de tipo `SP` y `LESIONES PERSONALES` llegaba solo hasta el 2026-07-06. Todo indica una recarga de la tabla del lado de Oracle que quedó a medias. La tabla la carga un proceso de la Policía.

**Efecto en AWS.**

1. 01:00 a. m.: la extracción copió la tabla incompleta sobre `raw_data_siedco_full_delitos`.
2. 04:00 y 04:30 a. m.: las capas del mapa y las tablas de Expertopol se generaron con esos datos.
3. 09:42 a. m.: se relanzó la extracción con un control nuevo, que la rechazó: "Carga de USR_ESTA.MOTIVOSPOLICIA rechazada tras 4 intentos; los datos existentes NO se modificaron".
4. 09:56 a. m.: se restauró `raw_data_siedco_full_delitos` y se regeneraron las capas del mapa.
5. 04:45 p. m.: se relanzaron los jobs de Expertopol (`pon-prod-expertopol-limpieza_delitos`, `partition_delitos-capturas` y `pon-prod-expertopol-delitos-resumen`).

**Control agregado al job de extracción.** La carga solo se escribe si trae al menos el 90 % de los registros de la última carga buena, en total y por tipo (`DE`, `SP`). La referencia está en `s3://pon-prod-raw-siedco-delitos-temporal/control/carga_motivospolicia.json`.

Detalle del control:

- Antes del cambio el script no tenía ninguna validación: leía la tabla, convertía las columnas a texto y escribía con sobrescritura, sin contar ni comparar. Tampoco había reintentos en el job ni versionado en el bucket.
- Además del volumen, valida que el hecho más reciente no tenga más de 5 días.
- Si una validación falla, espera 15 minutos y vuelve a leer Oracle, hasta 4 intentos. Si sigue fallando, el job termina en error **sin modificar los datos existentes**.
- Cada carga aceptada actualiza el registro de control con el total, el conteo por tipo y la fecha máxima.
- Los umbrales se ajustan con parámetros opcionales del job: `--min_proporcion`, `--max_dias_atraso`, `--intentos` y `--espera_minutos`.
- Script: `s3://aws-glue-assets-926162397524-us-east-1/scripts/pon-prod-full-siedco-motivospolicia-temporal.py`. Respaldo de la versión sin validación: `scripts/respaldos/pon-prod-full-siedco-motivospolicia-temporal.antes-validacion-20261009.py` en el mismo bucket.
- La carga incompleta se guardó para análisis en `s3://pon-prod-raw-siedco-delitos-temporal/control/forense-carga-incompleta-20261009/`.
- La restauración se hizo desde la copia del pipeline incremental (`pon_prod_siedco_raw.raw_siedco_usr_esta_motivospolicia`), que tiene las mismas 58 columnas. Ese día el job incremental `pon-prod-raw-siedco_etl` llevaba en ejecución desde las 00:08 a. m. sin terminar.

Pendiente de este control: no hay alerta cuando la carga es rechazada; el fallo solo queda registrado en Glue.

**Estado del respaldo en S3** (medido el 2026-10-09):

- 2.410.854 filas y 29 temáticas, con hechos del 2025-01-01 al 2026-10-07.
- Completo hasta el 2026-10-03; parcial del 04 al 07 (el 07 solo tiene 36 registros).
- Es una reconstrucción de 79 archivos, no una extracción única. Difiere cerca de 1 % de Oracle del 2026-10-06 y tiene 2.211 filas repetidas entre archivos.
- Es una sola copia y el bucket no tiene versionado.

**Tablas de Expertopol después de la corrección** (`pon-prod-expertopol-bd`):

| Tabla | 2024 | 2025 | 2026 |
|---|---|---|---|
| `pon-prod-expertopol-delitos_limpio` (21 temáticas de delitos) | 885.079 | 818.812 | 616.172 |
| `pon-prod-expertopol-capturas` | 197.401 | 197.236 | 158.330 |
| `pon-prod-expertopol-operaciones` (6 temáticas) | 328.523 | 338.434 | 281.775 |

**Pendiente.** Hasta que la Policía recargue `USR_ESTA.MOTIVOSPOLICIA` no entran datos nuevos: el mapa y Expertopol quedan congelados en el respaldo. Cuando la tabla esté completa, la cadena diaria se corrige sola.

## 13. Reglas para comparar el mapa con el tablero

Las capas y el tablero `02. Comparativo Delictivo (Datos crudos)` leen la misma vista de Athena, pero no muestran las mismas cantidades. Antes de clasificar una diferencia como error se deben aplicar estas reglas:

| Aspecto | Mapa (capas SIEDCO) | Tablero |
|---|---|---|
| Periodo | Últimos 6 meses | 2025 y 2026 completos |
| A qué unidad pertenece un hecho | Polígono dentro del cual cae la coordenada | Columna de jurisdicción (`juris.metropolitana / depto`) |
| Accidentes de tránsito | Excluidos | Incluidos como delitos |
| Registros sin coordenada | Excluidos | Incluidos |
| Capturas, incautaciones y recuperaciones | En las mismas capas que los delitos | En secciones aparte; sin recuperaciones |
| Alcance de una capa | Un turno; el total del día es la suma de las tres capas | Todo el día |

Para una comparación equivalente: en el tablero, dejar solo delitos y la unidad sin filtro de municipio, con un rango dentro de los últimos 6 meses; en el mapa, sumar las tres capas y quedarse con los registros de tipo `DE`. La diferencia restante corresponde a los accidentes de tránsito y a registros cuya coordenada no coincide con su jurisdicción: en `M. SOACHA` fue del 1,6 % (sección 8). Ese porcentaje se midió en una sola unidad; no se ha medido para todo el país.

Ejemplo verificado (`M. SOACHA`, 2026-10-01 a 2026-10-08): el tablero muestra 112 delitos con el municipio `Soacha` filtrado y el mapa 150 registros en las tres capas. La diferencia se compone de 3 delitos de la unidad ocurridos en otro municipio, menos 1 accidente de tránsito, más 38 registros operativos, menos 2 registros con coordenada fuera del polígono.
