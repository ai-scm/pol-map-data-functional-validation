# Análisis

## ¿Cómo se construye el tablero?

- El tablero publicado **`pon-prod-sigco`** se genera desde el análisis del mismo nombre, donde se configuran las visualizaciones, campos calculados y filtros.
- El análisis utiliza **11 datasets en modo SPICE**, alimentados mediante conexiones Athena.
- Athena consulta tablas y vistas de la base **`pon-prod-raw-telepol`**, catálogo `AwsDataCatalog`, región `us-east-1`.
- Las tablas contienen datos almacenados en S3. Las vistas combinan información de negocio con dominios, personas y actividades.
- Para Zonas Seguras, la cadena es: **Oracle → Glue → S3 → tabla Athena → `vista_frentes_con_descripcion` → dataset SPICE → análisis → tablero**.
- Publicar cambios del análisis actualiza la estructura del tablero; refrescar SPICE actualiza sus datos. Son operaciones independientes.

## ¿Qué procesos de actualización de datos tiene?

- **Descubrimiento de Oracle:** un crawler Glue revisa los metadatos de las tablas JDBC y los registra en el catálogo.
- **Extracción incremental:** el job `pon-prod-raw-telepol_etl` consulta Oracle utilizando bookmarks para identificar registros nuevos y los escribe como Parquet en S3.
- **Consulta en Athena:** las tablas y vistas permiten consultar esos archivos. Las vistas no extraen información de Oracle por sí mismas.
- **Recarga de SPICE:** Quick consulta Athena y reemplaza completamente la copia de cada dataset mediante `FULL_REFRESH`.
- **Control del workflow:** jobs auxiliares registran las etapas de descubrimiento, importación, finalización, fallo y detención.

## ¿Cada cuánto se actualiza?

- El workflow de Glue tiene una programación **diaria a las 03:03, hora Colombia**, mediante el trigger `pon-prod-raw-telepol_scheduler`.
- Su expresión es `cron(03 8 * * ? *)`, equivalente a **08:03 UTC**. El ETL comienza después de completar las etapas previas.
- Los **11 datasets SPICE** tienen una recarga completa **diaria a las 00:00**, zona horaria `America/Bogota`. El inicio efectivo puede ocurrir minutos después.
- **SPICE se recarga antes de la extracción de ese día.** Los datos incorporados por el ETL normalmente aparecerían en la siguiente recarga de medianoche, salvo que se ejecute una recarga adicional.
- Las vistas Athena reflejan la información disponible en sus tablas base cuando se consultan.

## ¿Contra qué fuente se actualiza?

- **Glue consulta Oracle**, mediante la conexión `pon-prod-raw-telepol-connection`:
  - Host: `172.28.18.240`.
  - Puerto: `1521`.
  - Servicio: `TELEPOL`.
  - Para frentes: tabla **`USR_SISEC.SIGCO_FRENTES`**.
- **Quick consulta Athena**, mediante sus data sources, para cargar los datasets SPICE.
- **Campañas tiene una excepción:** el dataset consume `usr_sisec.sigco_campanias_edu`, proveniente de una carga histórica separada de 2024. El ETL incremental actual procesa otra tabla, `SIGCO_CAMPANA_EDUCATIVA`; no se ha confirmado que ambas sean equivalentes.

## ¿Cuál es la ruta donde se guarda la información?

- El destino principal de la extracción es **`s3://pon-prod-raw-telepol/`**.
- Las rutas relevantes son:

| Información | Ruta |
| --- | --- |
| Frentes | `s3://pon-prod-raw-telepol/raw_telepol_usr_sisec_sigco_frentes/` |
| Fortalecimientos | `s3://pon-prod-raw-telepol/raw_telepol_usr_sisec_sigco_fortalecimiento_frentes/` |
| Campañas consumidas por Quick | `s3://pon-prod-raw-telepol/USR_SISEC.SIGCO_CAMPANIAS_EDU/` |
| Scripts del workflow | `s3://pon-prod-raw-telepol-auxiliar-scripts-bucket/` |

- El ETL utiliza `jdbc_incremental.py`; los jobs de control utilizan `state_manager.py`.
- SPICE mantiene una copia administrada por Quick, sin una ruta S3 de usuario identificada para esa copia.

## ¿Cuáles son los jobs relacionados con la sincronización?

| Job | Función |
| --- | --- |
| `pon-prod-raw-telepol_pre_crawl` | Marca el inicio de la etapa de descubrimiento. |
| `pon-prod-raw-telepol_post_crawl` | Marca la etapa de importación después del crawler exitoso. |
| **`pon-prod-raw-telepol_etl`** | Extrae registros desde Oracle y escribe Parquet en S3. |
| `pon-prod-raw-telepol_post_etl` | Marca la finalización después del ETL exitoso. |
| `pon-prod-raw-telepol_post_failure` | Gestiona fallos; tiene configurado el tópico SNS `glue-workflow-failures`. |
| `pon-prod-raw-telepol_incremental_stopped` | Gestiona detenciones o cancelaciones monitorizadas. |

- Todos pertenecen al workflow **`pon-prod-raw-telepol`**.
- También participa el crawler **`pon-prod-raw-telepol_discoverer`**, que descubre las tablas de `TELEPOL/%`.
- El job histórico **`pon-prod-raw-telepol-full-load-job`** figura en los metadatos de campañas, pero **ya no existe entre los jobs actuales de Glue**. No tiene una programación actual verificable.

### Estado actual de la sincronización — hallazgo adicional confirmado

- Los workflows del **2, 3, 4 y 5 de octubre de 2026** fallaron en el crawler con el mensaje: **`Test connection failed for connection 'pon-prod-raw-telepol-connection'`**.
- Debido a ese fallo, el ETL no se ejecutó en esas cadenas; se ejecutó el manejador de fallos.
- Aunque el estado global aparece como **`COMPLETED`**, los workflows contienen una acción fallida. Ese estado no demuestra una sincronización exitosa.
- La última ejecución disponible del ETL sigue siendo la del **1 de octubre**, que no encontró datos nuevos de SIGCO.
- Estos fallos explican la interrupción reciente y son consistentes con el rechazo de conexión observado desde el bastión. **No explican por sí solos la ausencia histórica de registros de 2025–2026**, que todavía requiere comparación con Oracle.