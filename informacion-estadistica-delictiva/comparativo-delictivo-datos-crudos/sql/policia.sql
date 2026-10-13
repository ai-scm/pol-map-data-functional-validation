-- ============================================================
-- Fecha de Creación: 2026-10-07
-- Campo de fecha utilizado: FECHA_HECHO (texto DD/MM/YYYY; se convierte con TO_DATE)
-- Reglas aplicadas:
--   * Solo operaciones de lectura sobre USR_ESTA.MOTIVOSPOLICIA (Oracle SIEDCO).
--   * Cada bloque mide una novedad de calidad de datos (N01 a N19); el codigo coincide
--     con la tabla "Novedades de calidad de datos en la fuente" de documentacion-tecnica.md.
--   * Las consultas "a" cuentan registros impactados; las "b" y "c" muestran evidencia.
--     No guardar en el repositorio el resultado de las consultas de evidencia.
-- ============================================================

-- =====================================================================================
-- NOVEDADES DE CALIDAD DE DATOS - SIEDCO
-- Tabla de origen del tablero "Comparativo Delictivo": USR_ESTA.MOTIVOSPOLICIA
-- Base de datos: Oracle 19c, servicio SIEDCO. Solo consultas de lectura (SELECT).
--
-- Cada bloque documenta una novedad:
--   QUE ES       : descripcion de la novedad
--   IMPACTO      : como afecta al tablero
--   QUE DEVUELVE : como leer el resultado
-- Las consultas "a" cuantifican los registros impactados; las "b" muestran evidencia.
--
-- Notas sobre la tabla:
--   * Todas las columnas son VARCHAR2 (fechas, edades y coordenadas vienen como texto).
--   * Cada fila es una persona asociada a un hecho (un hecho puede tener varias filas).
--   * tipo_lista_conducta: 'DE' = delitos, 'SP' = servicio de policia (capturas, incautaciones), 'OT' = otros.
-- =====================================================================================


-- -------------------------------------------------------------------------------------
-- N01. EDAD VACIA EN DELITOS CONTRA LAS PERSONAS
-- QUE ES       : registros sin edad en delitos donde siempre hay una persona identificada.
-- IMPACTO      : la tabla "Rango de edad victimas" deja estos casos por fuera o los clasifica mal.
-- QUE DEVUELVE : por delito, total de registros, cuantos no tienen edad y el porcentaje.
-- -------------------------------------------------------------------------------------
-- N01a
SELECT tematica,
       COUNT(*)                                                              AS total_registros,
       SUM(CASE WHEN edad IS NULL THEN 1 ELSE 0 END)                         AS sin_edad,
       ROUND(100 * SUM(CASE WHEN edad IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_sin_edad
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE'
AND    tematica IN ('VIOLENCIA INTRAFAMILIAR', 'LESIONES PERSONALES', 'HOMICIDIO DOLOSO O INTENCIONAL',
                    'DELITOS SEXUALES', 'HOMICIDIOS EN AT', 'LESIONES AT', 'HURTO PERSONAS',
                    'SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO', 'EXTORSION')
GROUP  BY tematica
ORDER  BY sin_edad DESC;

-- N01b  Evidencia: casos de violencia intrafamiliar sin edad
SELECT hechos_id, fecha_hecho, juris_metropolitana_depto, municipio_hecho, genero, edad
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tematica = 'VIOLENCIA INTRAFAMILIAR'
AND    edad IS NULL
AND    ROWNUM <= 20;


-- -------------------------------------------------------------------------------------
-- N02. EDADES IMPOSIBLES
-- QUE ES       : edades negativas, en cero, mayores de 100 o que no son un numero.
-- IMPACTO      : distorsiona los rangos de edad; el tablero no las descarta.
-- QUE DEVUELVE : cantidad de registros por tipo de error.
-- -------------------------------------------------------------------------------------
-- N02a
SELECT tipo_error, COUNT(*) AS registros
FROM  (SELECT CASE
                WHEN NOT REGEXP_LIKE(edad, '^-?[0-9]+$') THEN 'NO ES UN NUMERO'
                WHEN TO_NUMBER(edad) < 0                 THEN 'EDAD NEGATIVA'
                WHEN TO_NUMBER(edad) = 0                 THEN 'EDAD EN CERO'
                WHEN TO_NUMBER(edad) > 100               THEN 'MAYOR DE 100'
              END AS tipo_error
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  edad IS NOT NULL)
WHERE  tipo_error IS NOT NULL
GROUP  BY tipo_error
ORDER  BY registros DESC;

-- N02b  Evidencia: registros con edad negativa o mayor de 100
SELECT hechos_id, fecha_hecho, tematica, juris_metropolitana_depto, genero, edad
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  REGEXP_LIKE(edad, '^-[0-9]+$')
   OR  REGEXP_LIKE(edad, '^[0-9]{3,}$') AND edad <> '100'
ORDER  BY tematica, hechos_id;


-- -------------------------------------------------------------------------------------
-- N03. GENERO VACIO
-- QUE ES       : registros de delitos contra las personas sin genero.
-- IMPACTO      : los porcentajes de hombres y mujeres del tablero no suman el total.
-- QUE DEVUELVE : por delito, total, sin genero y porcentaje.
-- -------------------------------------------------------------------------------------
-- N03a
SELECT tematica,
       COUNT(*)                                                                AS total_registros,
       SUM(CASE WHEN genero IS NULL THEN 1 ELSE 0 END)                         AS sin_genero,
       ROUND(100 * SUM(CASE WHEN genero IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_sin_genero
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE'
AND    tematica IN ('VIOLENCIA INTRAFAMILIAR', 'LESIONES PERSONALES', 'HOMICIDIO DOLOSO O INTENCIONAL',
                    'DELITOS SEXUALES', 'HOMICIDIOS EN AT', 'LESIONES AT', 'HURTO PERSONAS',
                    'SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO', 'EXTORSION')
GROUP  BY tematica
HAVING SUM(CASE WHEN genero IS NULL THEN 1 ELSE 0 END) > 0
ORDER  BY sin_genero DESC;


-- -------------------------------------------------------------------------------------
-- N04. PAIS DE LA PERSONA NO REPORTADO
-- QUE ES       : registros sin pais de la persona.
-- IMPACTO      : la tabla de nacionalidad queda con mas de la mitad de los casos en "no reportado".
-- QUE DEVUELVE : por anio y tipo de conducta, total, sin pais y porcentaje.
-- -------------------------------------------------------------------------------------
-- N04a
SELECT anio, tipo_lista_conducta,
       COUNT(*)                                                                      AS total_registros,
       SUM(CASE WHEN pais_persona IS NULL THEN 1 ELSE 0 END)                         AS sin_pais,
       ROUND(100 * SUM(CASE WHEN pais_persona IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_sin_pais
FROM   USR_ESTA.MOTIVOSPOLICIA
GROUP  BY anio, tipo_lista_conducta
ORDER  BY anio, tipo_lista_conducta;


-- -------------------------------------------------------------------------------------
-- N05. COORDENADAS VACIAS, EN CERO O FUERA DE COLOMBIA
-- QUE ES       : latitud o longitud vacia, en cero, no numerica o fuera del territorio nacional.
-- IMPACTO      : esos hechos no aparecen (o aparecen mal ubicados) en la hoja "Mapa por delito".
-- QUE DEVUELVE : cantidad de registros de delitos por tipo de problema.
-- -------------------------------------------------------------------------------------
-- N05a
SELECT problema, COUNT(*) AS registros
FROM  (SELECT CASE
                WHEN latitud IS NULL OR longitud IS NULL                 THEN '1. COORDENADA VACIA'
                WHEN lat IS NULL OR lon IS NULL                          THEN '2. NO ES UN NUMERO VALIDO'
                WHEN lat = 0 OR lon = 0                                  THEN '3. COORDENADA EN CERO'
                WHEN lat NOT BETWEEN -4.5 AND 13.5 OR lon NOT BETWEEN -82 AND -66 THEN '4. FUERA DE COLOMBIA'
              END AS problema
       FROM  (SELECT latitud, longitud,
                     CASE WHEN REGEXP_LIKE(latitud,  '^-?[0-9]{1,3}(\.[0-9]{1,18})?$') THEN TO_NUMBER(latitud,  '999D999999999999999999', 'NLS_NUMERIC_CHARACTERS=''.,''') END AS lat,
                     CASE WHEN REGEXP_LIKE(longitud, '^-?[0-9]{1,3}(\.[0-9]{1,18})?$') THEN TO_NUMBER(longitud, '999D999999999999999999', 'NLS_NUMERIC_CHARACTERS=''.,''') END AS lon
              FROM   USR_ESTA.MOTIVOSPOLICIA
              WHERE  tipo_lista_conducta = 'DE'))
WHERE  problema IS NOT NULL
GROUP  BY problema
ORDER  BY problema;

-- N05b  Evidencia: ejemplos de coordenadas no validas o fuera de Colombia
SELECT hechos_id, tematica, juris_metropolitana_depto, municipio_hecho, latitud, longitud
FROM  (SELECT m.*,
              CASE WHEN REGEXP_LIKE(latitud,  '^-?[0-9]{1,3}(\.[0-9]{1,18})?$') THEN TO_NUMBER(latitud,  '999D999999999999999999', 'NLS_NUMERIC_CHARACTERS=''.,''') END AS lat,
              CASE WHEN REGEXP_LIKE(longitud, '^-?[0-9]{1,3}(\.[0-9]{1,18})?$') THEN TO_NUMBER(longitud, '999D999999999999999999', 'NLS_NUMERIC_CHARACTERS=''.,''') END AS lon
       FROM   USR_ESTA.MOTIVOSPOLICIA m
       WHERE  tipo_lista_conducta = 'DE' AND latitud IS NOT NULL AND latitud <> '0')
WHERE  (lat IS NULL OR lon IS NULL OR lat NOT BETWEEN -4.5 AND 13.5 OR lon NOT BETWEEN -82 AND -66)
AND    ROWNUM <= 20;


-- -------------------------------------------------------------------------------------
-- N06. MUNICIPIO DEL HECHO QUE NO CORRESPONDE A LA UNIDAD CON JURISDICCION
-- QUE ES       : un mismo municipio aparece bajo varias unidades (metropolitana / departamento).
--                Se toma como unidad correcta la que concentra la mayoria de registros del municipio;
--                los registros del mismo municipio bajo otra unidad se cuentan como inconsistentes.
-- IMPACTO      : al filtrar una unidad, la lista de municipios muestra municipios de otros departamentos
--                (por ejemplo, Abejorral o Agua de Dios bajo M. BOGOTA).
-- QUE DEVUELVE : (a) municipios afectados y registros inconsistentes; (b) detalle para M. BOGOTA.
-- -------------------------------------------------------------------------------------
-- N06a
SELECT COUNT(DISTINCT depto_hecho || ' / ' || municipio_hecho) AS municipios_afectados,
       SUM(registros)                                          AS registros_inconsistentes
FROM  (SELECT depto_hecho, municipio_hecho, juris_metropolitana_depto, COUNT(*) AS registros,
              RANK() OVER (PARTITION BY depto_hecho, municipio_hecho ORDER BY COUNT(*) DESC) AS orden
       FROM   USR_ESTA.MOTIVOSPOLICIA
       GROUP  BY depto_hecho, municipio_hecho, juris_metropolitana_depto)
WHERE  orden > 1;

-- N06b  Evidencia: registros con unidad M. BOGOTA cuyo hecho ocurrio en otro departamento
SELECT depto_hecho, COUNT(*) AS registros, COUNT(DISTINCT municipio_hecho) AS municipios
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  juris_metropolitana_depto = 'M. BOGOTÁ'
GROUP  BY depto_hecho
ORDER  BY registros DESC;

-- N06c  Evidencia: los 20 municipios con mas registros bajo una unidad distinta a la principal
SELECT depto_hecho, municipio_hecho, juris_metropolitana_depto AS unidad_registrada, registros,
       unidad_principal, registros_unidad_principal
FROM  (SELECT depto_hecho, municipio_hecho, juris_metropolitana_depto, COUNT(*) AS registros,
              RANK() OVER (PARTITION BY depto_hecho, municipio_hecho ORDER BY COUNT(*) DESC) AS orden,
              FIRST_VALUE(juris_metropolitana_depto) OVER (PARTITION BY depto_hecho, municipio_hecho ORDER BY COUNT(*) DESC) AS unidad_principal,
              MAX(COUNT(*)) OVER (PARTITION BY depto_hecho, municipio_hecho) AS registros_unidad_principal
       FROM   USR_ESTA.MOTIVOSPOLICIA
       GROUP  BY depto_hecho, municipio_hecho, juris_metropolitana_depto)
WHERE  orden > 1
ORDER  BY registros DESC
FETCH FIRST 20 ROWS ONLY;


-- -------------------------------------------------------------------------------------
-- N07. CUADRANTE PENDIENTE POR ASIGNAR
-- QUE ES       : registros cuyo cuadrante (juris_dependencia) es el texto 'CUADRANTE PENDIENTE POR ASIGNAR'.
-- IMPACTO      : aparece en filtros y tablas como si fuera un cuadrante real y concentra hechos
--                que no se pueden ubicar en el territorio.
-- QUE DEVUELVE : por unidad, total de registros de delitos, pendientes y porcentaje.
-- -------------------------------------------------------------------------------------
-- N07a
SELECT juris_metropolitana_depto,
       COUNT(*)                                                                                    AS total_registros,
       SUM(CASE WHEN juris_dependencia = 'CUADRANTE PENDIENTE POR ASIGNAR' THEN 1 ELSE 0 END)      AS cuadrante_pendiente,
       ROUND(100 * SUM(CASE WHEN juris_dependencia = 'CUADRANTE PENDIENTE POR ASIGNAR' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_pendiente
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE'
GROUP  BY juris_metropolitana_depto
HAVING SUM(CASE WHEN juris_dependencia = 'CUADRANTE PENDIENTE POR ASIGNAR' THEN 1 ELSE 0 END) > 0
ORDER  BY cuadrante_pendiente DESC;


-- -------------------------------------------------------------------------------------
-- N08. COLUMNA DE CUADRANTE (JURIS_DEPENDENCIA) CON VALORES QUE NO SON CUADRANTES
-- QUE ES       : la columna deberia traer el codigo del cuadrante; trae tambien nombres de estacion,
--                CAI, subestaciones y textos genericos.
-- IMPACTO      : en el filtro "Cuadrantes" del tablero aparecen estaciones.
-- QUE DEVUELVE : clasificacion del contenido de la columna, con valores distintos y registros.
-- -------------------------------------------------------------------------------------
-- N08a
SELECT tipo_de_valor, COUNT(DISTINCT juris_dependencia) AS valores_distintos, COUNT(*) AS registros
FROM  (SELECT juris_dependencia,
              CASE
                WHEN juris_dependencia IS NULL                               THEN '1. VACIO'
                WHEN juris_dependencia = 'CUADRANTE PENDIENTE POR ASIGNAR'    THEN '2. PENDIENTE POR ASIGNAR'
                WHEN REGEXP_LIKE(juris_dependencia, '^ESTACI[OÓ]N ')          THEN '3. NOMBRE DE ESTACION'
                WHEN juris_dependencia LIKE 'SUBESTACI%'                      THEN '4. SUBESTACION'
                WHEN juris_dependencia LIKE 'CAI %'                           THEN '5. CAI'
                WHEN REGEXP_LIKE(juris_dependencia, '^[A-Z]{5}MNVCC')         THEN '6. CODIGO DE CUADRANTE (esperado)'
                ELSE '7. OTRO'
              END AS tipo_de_valor
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  tipo_lista_conducta = 'DE')
GROUP  BY tipo_de_valor
ORDER  BY tipo_de_valor;

-- N08b  Evidencia: estaciones que aparecen como cuadrante en M. BOGOTA
SELECT juris_estacion_area, juris_cai, juris_dependencia, COUNT(*) AS registros
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  juris_metropolitana_depto = 'M. BOGOTÁ'
AND    REGEXP_LIKE(juris_dependencia, '^ESTACI[OÓ]N ')
GROUP  BY juris_estacion_area, juris_cai, juris_dependencia
ORDER  BY registros DESC;


-- -------------------------------------------------------------------------------------
-- N09. COLUMNA DE CAI (JURIS_CAI) VACIA O CON VALORES QUE NO SON CAI
-- QUE ES       : la columna trae CAI, pero tambien subestaciones, estaciones y codigos de cuadrante,
--                y viene vacia en una parte de los registros.
-- IMPACTO      : el filtro "CAI" lista elementos que no son CAI; los vacios salian como "NULL".
-- QUE DEVUELVE : clasificacion del contenido de la columna, con valores distintos y registros.
-- -------------------------------------------------------------------------------------
-- N09a
SELECT tipo_de_valor, COUNT(DISTINCT juris_cai) AS valores_distintos, COUNT(*) AS registros
FROM  (SELECT juris_cai,
              CASE
                WHEN juris_cai IS NULL                                THEN '1. VACIO'
                WHEN juris_cai LIKE 'CAI %'                           THEN '2. CAI (esperado)'
                WHEN juris_cai LIKE 'SUBESTACI%'                      THEN '3. SUBESTACION'
                WHEN REGEXP_LIKE(juris_cai, '^ESTACI[OÓ]N ')          THEN '4. NOMBRE DE ESTACION'
                WHEN REGEXP_LIKE(juris_cai, '^[A-Z]{5}MNVCC')         THEN '5. CODIGO DE CUADRANTE'
                WHEN juris_cai LIKE 'CUADRANTE%'                      THEN '6. TEXTO CUADRANTE'
                ELSE '7. OTRO'
              END AS tipo_de_valor
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  tipo_lista_conducta = 'DE')
GROUP  BY tipo_de_valor
ORDER  BY tipo_de_valor;

-- N09b  Evidencia: unidades con mas registros de delitos sin CAI
SELECT juris_metropolitana_depto,
       COUNT(*)                                                                    AS total_registros,
       SUM(CASE WHEN juris_cai IS NULL THEN 1 ELSE 0 END)                          AS sin_cai,
       ROUND(100 * SUM(CASE WHEN juris_cai IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_sin_cai
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE'
GROUP  BY juris_metropolitana_depto
ORDER  BY sin_cai DESC
FETCH FIRST 15 ROWS ONLY;


-- -------------------------------------------------------------------------------------
-- N10. COLUMNA DE ESTACION (JURIS_ESTACION_AREA) CON VALORES QUE NO SON ESTACIONES
-- QUE ES       : la columna trae distritos especiales, codigos de cuadrante y textos genericos.
-- IMPACTO      : el filtro "Estacion" lista valores que no son estaciones.
-- QUE DEVUELVE : los valores que no empiezan por ESTACION, con sus registros.
-- -------------------------------------------------------------------------------------
-- N10a
SELECT juris_estacion_area, COUNT(DISTINCT juris_metropolitana_depto) AS unidades, COUNT(*) AS registros
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  NOT REGEXP_LIKE(juris_estacion_area, '^ESTACI[OÓ]N ') OR juris_estacion_area IS NULL
GROUP  BY juris_estacion_area
ORDER  BY registros DESC;


-- -------------------------------------------------------------------------------------
-- N11. ESTACIONES CON EL MISMO NOMBRE EN VARIAS UNIDADES
-- QUE ES       : el nombre de la estacion no es unico en el pais (ESTACION NORTE, ESTACION SUR, ...).
-- IMPACTO      : cualquier tabla o filtro por nombre de estacion suma ciudades distintas en una sola fila.
-- QUE DEVUELVE : (a) cuantos nombres se repiten y cuantos registros agrupan; (b) el detalle.
-- -------------------------------------------------------------------------------------
-- N11a
SELECT COUNT(*) AS nombres_repetidos, SUM(registros) AS registros_bajo_nombres_repetidos
FROM  (SELECT juris_estacion_area, COUNT(*) AS registros
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  REGEXP_LIKE(juris_estacion_area, '^ESTACI[OÓ]N ')
       GROUP  BY juris_estacion_area
       HAVING COUNT(DISTINCT juris_metropolitana_depto) > 1);

-- N11b  Evidencia: nombres de estacion presentes en 3 o mas unidades
SELECT juris_estacion_area,
       COUNT(DISTINCT juris_metropolitana_depto) AS unidades,
       COUNT(*)                                  AS registros,
       LISTAGG(DISTINCT juris_metropolitana_depto, ', ') WITHIN GROUP (ORDER BY juris_metropolitana_depto) AS en_que_unidades
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  REGEXP_LIKE(juris_estacion_area, '^ESTACI[OÓ]N ')
GROUP  BY juris_estacion_area
HAVING COUNT(DISTINCT juris_metropolitana_depto) >= 3
ORDER  BY unidades DESC, registros DESC;


-- -------------------------------------------------------------------------------------
-- N12. UN MISMO HECHO REGISTRADO EN VARIOS DELITOS (TEMATICAS)
-- QUE ES       : el mismo HECHOS_ID aparece bajo dos o mas tematicas (p. ej. hurto celular y hurto personas).
-- IMPACTO      : con el filtro "Delito de analisis" en "Todo", el total del tablero cuenta el hecho
--                una vez por cada tematica.
-- QUE DEVUELVE : (a) hechos y registros segun el numero de tematicas; (b) las parejas mas frecuentes.
-- -------------------------------------------------------------------------------------
-- N12a
SELECT anio, tematicas_por_hecho, COUNT(*) AS hechos, SUM(registros) AS registros
FROM  (SELECT anio, hechos_id, COUNT(DISTINCT tematica) AS tematicas_por_hecho, COUNT(*) AS registros
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  tipo_lista_conducta = 'DE'
       GROUP  BY anio, hechos_id)
GROUP  BY anio, tematicas_por_hecho
ORDER  BY anio, tematicas_por_hecho;

-- N12b  Evidencia: parejas de delitos que comparten hecho
SELECT a.tematica AS delito_1, b.tematica AS delito_2, COUNT(*) AS hechos_compartidos
FROM  (SELECT DISTINCT hechos_id, tematica FROM USR_ESTA.MOTIVOSPOLICIA WHERE tipo_lista_conducta = 'DE') a
JOIN  (SELECT DISTINCT hechos_id, tematica FROM USR_ESTA.MOTIVOSPOLICIA WHERE tipo_lista_conducta = 'DE') b
  ON   a.hechos_id = b.hechos_id AND a.tematica < b.tematica
GROUP  BY a.tematica, b.tematica
ORDER  BY hechos_compartidos DESC
FETCH FIRST 15 ROWS ONLY;


-- -------------------------------------------------------------------------------------
-- N13. VARIOS REGISTROS POR HECHO (CONTEO DE PERSONAS FRENTE A CONTEO DE HECHOS)
-- QUE ES       : cada fila es una persona; un hecho con varias personas ocupa varias filas.
-- IMPACTO      : el tablero cuenta filas. Si la cifra oficial es por hecho, el tablero muestra mas.
-- QUE DEVUELVE : por delito, registros, hechos distintos y la diferencia entre ambos.
-- -------------------------------------------------------------------------------------
-- N13a
SELECT tematica,
       COUNT(*)                                   AS registros,
       COUNT(DISTINCT hechos_id)                  AS hechos_distintos,
       COUNT(*) - COUNT(DISTINCT hechos_id)       AS registros_adicionales,
       ROUND(100 * (COUNT(*) - COUNT(DISTINCT hechos_id)) / COUNT(DISTINCT hechos_id), 2) AS pct_sobre_hechos
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE' AND anio = '2026'
GROUP  BY tematica
ORDER  BY registros_adicionales DESC;

-- N13b  Evidencia: un homicidio con varias victimas (mismo hecho, varias filas)
SELECT hechos_id, fecha_hecho, municipio_hecho, genero, edad, armas_medios
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tematica = 'HOMICIDIO DOLOSO O INTENCIONAL'
AND    hechos_id IN (SELECT hechos_id
                     FROM  (SELECT hechos_id
                            FROM   USR_ESTA.MOTIVOSPOLICIA
                            WHERE  tematica = 'HOMICIDIO DOLOSO O INTENCIONAL' AND anio = '2026'
                            GROUP  BY hechos_id
                            HAVING COUNT(*) >= 4
                            ORDER  BY COUNT(*) DESC)
                     WHERE ROWNUM <= 2)
ORDER  BY hechos_id;


-- -------------------------------------------------------------------------------------
-- N14. POSIBLES REGISTROS DUPLICADOS
-- QUE ES       : filas del mismo hecho y delito con todos los datos de la persona identicos.
--                Pueden ser personas distintas con los mismos datos o un registro repetido; requiere revision.
-- IMPACTO      : si son repetidos, inflan el conteo del tablero.
-- QUE DEVUELVE : (a) grupos de filas identicas y filas sobrantes; (b) ejemplos.
-- -------------------------------------------------------------------------------------
-- N14a
SELECT COUNT(*) AS grupos_de_filas_identicas, SUM(veces - 1) AS filas_sobrantes
FROM  (SELECT COUNT(*) AS veces
       FROM   USR_ESTA.MOTIVOSPOLICIA
       WHERE  tipo_lista_conducta = 'DE'
       GROUP  BY hechos_id, tematica, fecha_hecho, hora_hecho, genero, edad, estado_civil_persona, grado_instruccion_persona,
                 pais_persona, agrupa_clase_empleado, armas_medios, modalidad, clase_sitio, barrios_hecho, juris_dependencia,
                 clase_bien, tipo_bien, marca, descripcion_lineamarca, cantidad, valor, causas_lesion_muerte_persona,
                 delito_asociado, latitud, longitud
       HAVING COUNT(*) > 1);

-- N14b  Evidencia: los grupos con mas filas identicas
SELECT hechos_id, tematica, fecha_hecho, genero, edad, COUNT(*) AS veces
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tipo_lista_conducta = 'DE'
GROUP  BY hechos_id, tematica, fecha_hecho, hora_hecho, genero, edad, estado_civil_persona, grado_instruccion_persona,
          pais_persona, agrupa_clase_empleado, armas_medios, modalidad, clase_sitio, barrios_hecho, juris_dependencia,
          clase_bien, tipo_bien, marca, descripcion_lineamarca, cantidad, valor, causas_lesion_muerte_persona,
          delito_asociado, latitud, longitud
HAVING COUNT(*) > 1
ORDER  BY veces DESC
FETCH FIRST 15 ROWS ONLY;


-- -------------------------------------------------------------------------------------
-- N15. CAUSA DE LESION O MUERTE VACIA EN HOMICIDIOS Y LESIONES
-- QUE ES       : registros de homicidio o lesiones sin causa de lesion o muerte.
-- IMPACTO      : la tabla "Posible causa" del tablero queda incompleta.
-- QUE DEVUELVE : por delito, total, sin causa y porcentaje.
-- -------------------------------------------------------------------------------------
-- N15a
SELECT tematica,
       COUNT(*)                                                                                      AS total_registros,
       SUM(CASE WHEN causas_lesion_muerte_persona IS NULL THEN 1 ELSE 0 END)                         AS sin_causa,
       ROUND(100 * SUM(CASE WHEN causas_lesion_muerte_persona IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_sin_causa
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tematica IN ('HOMICIDIO DOLOSO O INTENCIONAL', 'HOMICIDIOS EN AT', 'LESIONES PERSONALES', 'LESIONES AT')
GROUP  BY tematica
ORDER  BY sin_causa DESC;


-- -------------------------------------------------------------------------------------
-- N16. NOMBRES ESCRITOS DE VARIAS FORMAS (TILDES)
-- QUE ES       : la misma palabra aparece con y sin tilde (ESTACION / ESTACIÓN) en los nombres de estacion.
-- IMPACTO      : desordena listas y busquedas en los filtros; dos escrituras de una misma estacion
--                se tratarian como estaciones distintas.
-- QUE DEVUELVE : (a) cuantas estaciones usan cada escritura; (b) nombres que solo difieren en tildes.
--                Si (b) no devuelve filas, no hay estaciones duplicadas por tildes dentro de una misma unidad.
-- -------------------------------------------------------------------------------------
-- N16a
SELECT CASE WHEN juris_estacion_area LIKE 'ESTACIÓN %' THEN 'CON TILDE (ESTACIÓN)'
            WHEN juris_estacion_area LIKE 'ESTACION %' THEN 'SIN TILDE (ESTACION)' END AS escritura,
       COUNT(DISTINCT juris_estacion_area) AS estaciones, COUNT(*) AS registros
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  REGEXP_LIKE(juris_estacion_area, '^ESTACI[OÓ]N ')
GROUP  BY CASE WHEN juris_estacion_area LIKE 'ESTACIÓN %' THEN 'CON TILDE (ESTACIÓN)'
               WHEN juris_estacion_area LIKE 'ESTACION %' THEN 'SIN TILDE (ESTACION)' END;

-- N16b  Evidencia: valores que quedan iguales al quitar tildes (misma unidad)
SELECT juris_metropolitana_depto, sin_tildes, COUNT(*) AS escrituras, LISTAGG(valor, '  |  ') WITHIN GROUP (ORDER BY valor) AS como_aparece
FROM  (SELECT DISTINCT juris_metropolitana_depto, juris_estacion_area AS valor,
              TRANSLATE(juris_estacion_area, 'ÁÉÍÓÚÜ', 'AEIOUU') AS sin_tildes
       FROM   USR_ESTA.MOTIVOSPOLICIA)
GROUP  BY juris_metropolitana_depto, sin_tildes
HAVING COUNT(*) > 1
ORDER  BY juris_metropolitana_depto, sin_tildes;


-- -------------------------------------------------------------------------------------
-- N17. DEPARTAMENTOS Y METROPOLITANAS EN UNA SOLA COLUMNA
-- QUE ES       : JURIS_METROPOLITANA_DEPTO guarda dos tipos de unidad sin una columna que los distinga.
-- IMPACTO      : el filtro "Unidad" los muestra mezclados.
-- QUE DEVUELVE : cuantas unidades y registros hay de cada tipo.
-- -------------------------------------------------------------------------------------
-- N17a
SELECT CASE WHEN juris_metropolitana_depto LIKE 'M. %' THEN 'METROPOLITANA'
            WHEN juris_metropolitana_depto IS NULL      THEN 'VACIO'
            ELSE 'DEPARTAMENTO' END             AS tipo_de_unidad,
       COUNT(DISTINCT juris_metropolitana_depto) AS unidades,
       COUNT(*)                                  AS registros
FROM   USR_ESTA.MOTIVOSPOLICIA
GROUP  BY CASE WHEN juris_metropolitana_depto LIKE 'M. %' THEN 'METROPOLITANA'
               WHEN juris_metropolitana_depto IS NULL      THEN 'VACIO'
               ELSE 'DEPARTAMENTO' END;


-- -------------------------------------------------------------------------------------
-- N18. CAPTURAS SIN SITUACION JURIDICA O PENDIENTES POR MEDIDA
-- QUE ES       : capturas sin situacion juridica registrada, o que siguen 'PENDIENTE POR MEDIDA'
--                mas de 30 dias despues de la captura.
-- IMPACTO      : la tabla "Situacion juridica de los capturados" queda incompleta.
-- QUE DEVUELVE : por anio, total de capturas, sin situacion y pendientes con mas de 30 dias.
-- -------------------------------------------------------------------------------------
-- N18a
SELECT anio,
       COUNT(*)                                                    AS total_capturas,
       SUM(CASE WHEN situacion_juridica IS NULL THEN 1 ELSE 0 END) AS sin_situacion_juridica,
       SUM(CASE WHEN situacion_juridica = 'PENDIENTE POR MEDIDA'
                 AND TO_DATE(fecha_hecho, 'DD/MM/YYYY') < TRUNC(SYSDATE) - 30 THEN 1 ELSE 0 END) AS pendiente_mas_de_30_dias
FROM   USR_ESTA.MOTIVOSPOLICIA
WHERE  tematica = 'CAPTURAS'
GROUP  BY anio
ORDER  BY anio;


-- -------------------------------------------------------------------------------------
-- N19. VERIFICACIONES DE FORMATO (COLUMNAS DE TEXTO)
-- QUE ES       : como todo es VARCHAR2, la base no impide fechas o numeros mal escritos.
-- IMPACTO      : un valor mal escrito hace fallar o descarta el registro en el tablero.
-- QUE DEVUELVE : una fila con el conteo de cada verificacion (0 = sin novedad).
-- -------------------------------------------------------------------------------------
-- N19a
SELECT COUNT(*)                                                                                             AS total_registros,
       SUM(CASE WHEN fecha_hecho IS NULL THEN 1 ELSE 0 END)                                                 AS fecha_vacia,
       SUM(CASE WHEN NOT REGEXP_LIKE(fecha_hecho, '^[0-3][0-9]/[01][0-9]/[12][0-9]{3}$') THEN 1 ELSE 0 END) AS fecha_con_formato_invalido,
       SUM(CASE WHEN SUBSTR(fecha_hecho, 7, 4) <> anio THEN 1 ELSE 0 END)                                   AS anio_distinto_a_la_fecha,
       SUM(CASE WHEN hechos_id IS NULL THEN 1 ELSE 0 END)                                                   AS sin_id_de_hecho,
       SUM(CASE WHEN NOT REGEXP_LIKE(hora_24, '^([01][0-9]|2[0-3])$') OR hora_24 IS NULL THEN 1 ELSE 0 END) AS hora_invalida,
       SUM(CASE WHEN zona NOT IN ('URBANA', 'RURAL') OR zona IS NULL THEN 1 ELSE 0 END)                     AS zona_distinta_de_urbana_rural,
       SUM(CASE WHEN juris_metropolitana_depto IS NULL THEN 1 ELSE 0 END)                                   AS sin_unidad,
       SUM(CASE WHEN juris_region IS NULL THEN 1 ELSE 0 END)                                                AS sin_region
FROM   USR_ESTA.MOTIVOSPOLICIA;
