# Análisis

Tablero: **Sistema Estadístico de Gestión Territorial**. Configuración verificada en AWS el **13 de octubre de 2026**, región `us-east-1`. Los horarios indicados corresponden a Colombia (`America/Bogota`), salvo donde se especifica UTC.

## ¿Cómo se construye el tablero?

- El tablero publicado **`pon-prod-segt-sistema-estadistico-gestion-territorial`** se genera desde el análisis del mismo nombre, donde se configuran visualizaciones, campos calculados y filtros.
- La versión publicada consultada es la **19**, publicada el **6 de octubre de 2026 a las 08:02**, hora Colombia.
- Tiene dos hojas: **Proyectos** y **Recursos Gestionados**, con 27 visuales cada una, incluidos elementos de contenido personalizado.
- La definición publicada declara **tres datasets SPICE**, conectados a Athena, catálogo `AwsDataCatalog`, workgroup `primary`:

| Dataset | Base Athena | Tabla consumida | Uso en la definición publicada |
| --- | --- | --- | --- |
| `usr_disec.v_gestion_proyecto_detalle` | `pon-prod-raw-disec` | `usr_disec.v_gestion_proyecto_detalle` | Datos de proyectos; su identificador interno en el tablero es `raw_disec_usr_disec_seget_proyecto`. También aparece referenciado en la hoja Recursos Gestionados. |
| `usr_disec.v_gestion_recurso_detalle` | `pon-prod-raw-disec` | `usr_disec.v_gestion_recurso_detalle` | Datos de recursos gestionados. |
| `gestion_territorial` | `pon-prod-gestionterritorial-op` | `raw_pon_prod_disec_gestionterritorial` | Solo aparece asociado a un visual de contenido personalizado en cada hoja; esos dos visuales no tienen campos de datos ni acciones configuradas. |

- **Las dos tablas `v_gestion_*_detalle` son tablas externas Parquet en Athena**, no vistas SQL de Athena. Los objetos de origen que extrae Glue son `USR_DISEC.V_GESTION_PROYECTO_DETALLE` y `USR_DISEC.V_GESTION_RECURSO_DETALLE` en Oracle.
- La cadena principal confirmada es: **Oracle DISEC → job Glue de carga completa → Parquet en S3 → tablas del catálogo Glue consultadas por Athena → datasets SPICE → análisis → tablero**.
- Publicar el análisis actualiza la estructura del tablero; recargar SPICE actualiza los datos. Son operaciones independientes.

### Lógica de medidas confirmada

| Campo calculado | Dataset | Expresión publicada |
| --- | --- | --- |
| `COSTO` | Proyectos | `sum(max(costo, [{proyecto_id}]))` |
| `PROYECTOS_POR_CATEGORIA` | Proyectos | `sum(count({proyecto_id},[categoria]))/sum(count({proyecto_id},[]))` |
| `VALOR` | Recursos | `sum(valor,[valor,{codigo_elemento}])` |
| `VALOR_CATEGORIA` | Recursos | `sum(sum(valor,[categoria]))/sum(sum(valor,[]))` |

- `COSTO` utiliza el máximo de costo por proyecto antes de sumar; para reproducirlo debe respetarse el contexto de filtros del visual.
- El campo calculado `ESTADO` traduce `id_estado` a formulación, presentado, aprobado, desaprobado, adjudicado, en ejecución, terminado y no viable; los demás valores se presentan como `SIN INFORMACIÓN`.
- Los campos `FUENTE` y `FUENTE.` traducen `id_fuente` a FONSET municipio/departamento, regalías, recursos propios de alcaldía/gobernación, FONSECON, cooperación internacional, convenio y FONSET multas código; los demás valores se presentan como `OTRA`.
- Las expresiones de porcentajes usan `count` y `sum` según la configuración publicada. No se ha validado su equivalencia con un conteo de proyectos únicos ni con totales conciliados contra Oracle.

## ¿Qué procesos de actualización de datos tiene?

- **Orquestación de carga completa:** el job `pon-prod-raw-disec-dashboard-scheduler` lee una lista de 13 objetos Oracle y lanza el job `pon-prod-raw-disec-dashboard-full-load-job` para cada objeto, con hasta cinco ejecuciones en paralelo. La lista incluye las dos fuentes de gestión territorial.
- **Extracción desde Oracle:** el job de carga completa utiliza la conexión `pon-prod-raw-disec-connection`. Para ambas fuentes, el scheduler configura `filtering=false`, sin restricción temporal de extracción.
- **Reemplazo en S3 y catálogo:** el script lee el objeto Oracle, purga el prefijo S3 de destino con retención cero, elimina la tabla previa del catálogo si existe y escribe Parquet con compresión Snappy, actualizando el catálogo Glue. No es una extracción incremental por bookmarks.
- **Consulta en Athena:** las tablas externas permiten consultar los archivos generados. El nombre que comienza por `v_` no significa que Athena vuelva a consultar Oracle.
- **Recarga de SPICE:** QuickSight consulta Athena y reemplaza completamente la copia de cada uno de los dos datasets actuales mediante `FULL_REFRESH`.
- **Dataset anterior:** `gestion_territorial` apunta a otra base y otro bucket. No tiene programación de recarga SPICE y no se confirmó el proceso que genera sus archivos. El crawler asociado inspecciona S3; no realiza la extracción Oracle.

## ¿Cada cuánto se actualiza?

| Proceso | Programación confirmada |
| --- | --- |
| Trigger Glue `pon-prod-raw-disec-dashboard-scheduler` | Activo, `cron(30 3 */2 * ? *)`: 03:30 UTC en los días del mes seleccionados por `*/2`, equivalentes a las **22:30 del día anterior en Colombia**. La regla se reinicia cada mes; no garantiza un intervalo fijo de 48 horas al cambiar de mes. |
| SPICE `usr_disec.v_gestion_recurso_detalle` | Recarga completa **diaria a las 17:05**, `America/Bogota`. |
| SPICE `usr_disec.v_gestion_proyecto_detalle` | Recarga completa **diaria a las 17:06**, `America/Bogota`. |
| SPICE `gestion_territorial` | Sin horarios de recarga configurados. La única ingesta devuelta por la consulta fue manual, del **5 de marzo de 2025 a las 11:58**. |
| Crawler `pon-prod-disec-gestion-territorial` | Sin programación ni última ejecución informadas en la configuración consultada. |

- **La recarga SPICE de la tarde ocurre antes de la extracción nocturna.** Los datos extraídos a las 22:30 normalmente aparecerían en la recarga de la tarde siguiente, si ambas etapas terminan correctamente y no se ejecuta una recarga adicional.
- El refresco diario de SPICE puede cargar nuevamente los mismos archivos entre ejecuciones de Glue. Una ingesta reciente no demuestra que Oracle se haya sincronizado ese mismo día.
- Existe además el workflow general `pon-prod-raw-disec`, con trigger diario `cron(30 6 * * ? *)`, equivalente a **01:30 Colombia**. La carga completa de los dos objetos de este tablero se confirmó en el scheduler de dashboards; no se atribuye a ese workflow general por compartir prefijo.

## ¿Contra qué fuente se actualiza?

- **Glue consulta Oracle**, mediante la conexión JDBC `pon-prod-raw-disec-connection`:
  - Host: `172.28.18.185`.
  - Puerto: `1538`.
  - Servicio: `DISEC`.
  - Proyectos: **`USR_DISEC.V_GESTION_PROYECTO_DETALLE`**.
  - Recursos gestionados: **`USR_DISEC.V_GESTION_RECURSO_DETALLE`**.
- **QuickSight consulta Athena** mediante los data sources `usr_disec.v_gestion_proyecto_detalle`, `usr_disec.v_gestion_recurso_detalle` y `SEGET`.
- No se inspeccionaron las definiciones SQL de los objetos Oracle; sus tablas base y reglas de negocio anteriores a Glue quedan pendientes de confirmar.
- La fuente anterior de `gestion_territorial` es la tabla Athena `pon-prod-gestionterritorial-op.raw_pon_prod_disec_gestionterritorial`; no se confirmó su origen anterior a S3 ni su equivalencia con las dos fuentes actuales.

## ¿Cuál es la ruta donde se guarda la información?

| Información | Ruta |
| --- | --- |
| Detalle de proyectos | `s3://pon-prod-raw-disec/USR_DISEC.V_GESTION_PROYECTO_DETALLE/` |
| Detalle de recursos gestionados | `s3://pon-prod-raw-disec/USR_DISEC.V_GESTION_RECURSO_DETALLE/` |
| Fuente del dataset anterior `gestion_territorial` | `s3://pon-prod-disec-gestionterritorial/` |
| Script de extracción completa | `s3://pon-prod-glue-scripts/etl/full_load_job.py` |
| Script de orquestación | `s3://pon-prod-glue-scripts/shell/job_scheduler.py` |

- El catálogo registra las dos fuentes actuales como tablas externas Parquet creadas por `pon-prod-raw-disec-dashboard-full-load-job`.
- SPICE mantiene una copia administrada por QuickSight, sin una ruta S3 de usuario identificada para esa copia.

## ¿Cuáles son los jobs relacionados con la sincronización?

| Recurso | Función y relación confirmada |
| --- | --- |
| **`pon-prod-raw-disec-dashboard-scheduler`** — job | Orquesta cargas completas de 13 objetos, incluidos los dos de gestión territorial; hasta cinco ejecuciones simultáneas. |
| **`pon-prod-raw-disec-dashboard-full-load-job`** — job | Extrae cada objeto desde Oracle, reemplaza sus archivos S3 y recrea/actualiza su tabla en el catálogo Glue. |
| `pon-prod-raw-disec-dashboard-scheduler` — trigger | Inicia el job de orquestación según `cron(30 3 */2 * ? *)`; estado `ACTIVATED`. |
| `pon-prod-disec-gestion-territorial` — crawler | Apunta a `s3://pon-prod-disec-gestionterritorial/`, fuente del dataset anterior; no tiene una programación informada. |

- El workflow general `pon-prod-raw-disec` contiene los jobs `pon-prod-raw-disec_pre_crawl`, `pon-prod-raw-disec_post_crawl`, `pon-prod-raw-disec_etl`, `pon-prod-raw-disec_post_etl`, `pon-prod-raw-disec_post_failure` y `pon-prod-raw-disec_incremental_stopped`, junto al crawler `pon-prod-raw-disec_discoverer`. No se verificó que esa cadena actualice directamente los dos prefijos consumidos por este tablero.

### Estado actual de la sincronización — hallazgos confirmados

- La última extracción consultada de **proyectos** comenzó el **12 de octubre de 2026 a las 22:30:31** y terminó a las **22:33:31**, en estado `SUCCEEDED`.
- La última extracción consultada de **recursos** comenzó el **12 de octubre de 2026 a las 22:30:31** y terminó a las **22:33:14**, en estado `SUCCEEDED`.
- El scheduler terminó en `SUCCEEDED` en las ejecuciones del 10 y 12 de octubre. La del **8 de octubre a las 22:30** falló con **`Max concurrent runs exceeded`**. El job es compartido por varios objetos; ese fallo no se atribuye exclusivamente a gestión territorial.

| Dataset | Última ingesta SPICE consultada: inicio | Estado | Filas incorporadas | Filas descartadas |
| --- | --- | --- | ---: | ---: |
| Proyectos | 12/10/2026 17:06:28 | `COMPLETED` | 27.076 | 29 |
| Recursos gestionados | 12/10/2026 17:05:32 | `COMPLETED` | 36.942 | 31 |
| `gestion_territorial` | 05/03/2025 11:58:01 | `COMPLETED`, manual | 823.605 | 1.872 |

- **Las últimas ingestiones consultadas de los dos datasets actuales preceden a la extracción nocturna del 12 de octubre.** No acreditan que SPICE ya contenga esa extracción.
- `COMPLETED` no significa que se hayan incorporado todas las filas: QuickSight informa filas descartadas. No se confirmó la causa ni su impacto sobre los indicadores.
- La fecha `LastUpdatedTime` de un dataset corresponde a sus metadatos y no debe utilizarse como sustituto de la fecha de ingesta ni de la fecha de extracción de Oracle.
- La antigüedad de `gestion_territorial` no demuestra que los indicadores actuales estén desactualizados: en los visuales publicados solo aparece asociado a contenido personalizado sin campos de datos.

### Alcance de la verificación

- Se consultaron los metadatos del análisis, la definición del tablero publicado, los datasets y sus data sources, horarios e ingestiones SPICE, tablas y conexión de Glue, crawler, jobs, triggers y ejecuciones recientes. También se leyeron los dos scripts de carga/orquestación almacenados en S3.
- No se ejecutaron cargas, recargas, modificaciones de AWS ni consultas de registros de negocio. Quedan pendientes la conciliación contra Oracle, las definiciones SQL de origen y la explicación de las filas descartadas por SPICE.
