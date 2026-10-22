-- ============================================================
-- Fecha de Creación: 2026-10-21
-- Campo de fecha utilizado: fecha_inicio_act (GESCOV); fecha_hecho (SIEDCO)
-- Reglas aplicadas:
--   - Una fila = una actividad (punto) de un plan preventivo.
--   - Solo planes aprobados: Aprobacion Distrito, Aprobacion Estacion, Aprobado Extraordinario.
--   - Semana de domingo a sábado; la semana 1 contiene el 1 de enero.
--   - Cumplimiento = Cumple / (Cumple + No cumple).
--   - Ejemplo: semana 7 de 2026 (2026-02-08 a 2026-02-14).
-- Solo lectura.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Totales de la semana por estado del plan y cumplimiento
--    (los "Elaborado" se informan aparte; los rechazos no cuentan)
-- ------------------------------------------------------------
SELECT
    estado,
    estado_cumplimiento,
    COUNT(*) AS actividades
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
GROUP BY estado, estado_cumplimiento
ORDER BY estado, estado_cumplimiento;


-- ------------------------------------------------------------
-- 2. Contexto semanal: zona, tipo de plan y día de la semana
-- ------------------------------------------------------------
SELECT
    zona,
    tipo_plan,
    estado_cumplimiento,
    COUNT(*) AS actividades
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
GROUP BY zona, tipo_plan, estado_cumplimiento
ORDER BY zona, tipo_plan, estado_cumplimiento;

SELECT
    date_format(fecha_inicio_act, '%W')                                AS dia,
    COUNT(*)                                                           AS total,
    SUM(CASE WHEN estado_cumplimiento = 'Cumple' THEN 1 ELSE 0 END)    AS cumplidos
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
GROUP BY date_format(fecha_inicio_act, '%W')
ORDER BY cumplidos DESC;


-- ------------------------------------------------------------
-- 3. Cumplimiento por unidad (estaciones = unidad; patrullas = cuadrante)
-- ------------------------------------------------------------
SELECT
    sigla_unidad,
    CASE WHEN sigla_unidad LIKE 'ME%' THEN 'METROPOLITANA' ELSE 'DEPARTAMENTO' END AS tipo_unidad,
    COUNT(DISTINCT unidad)                                             AS estaciones,
    COUNT(DISTINCT cuadrante)                                          AS patrullas,
    SUM(CASE WHEN estado_cumplimiento = 'Cumple'    THEN 1 ELSE 0 END) AS cumplidos,
    SUM(CASE WHEN estado_cumplimiento = 'No cumple' THEN 1 ELSE 0 END) AS no_cumplidos,
    COUNT(*)                                                           AS total_planeado
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
GROUP BY sigla_unidad
ORDER BY total_planeado DESC;


-- ------------------------------------------------------------
-- 4. Planes elaborados sin aprobación, por unidad
-- ------------------------------------------------------------
SELECT
    sigla_unidad,
    COUNT(*) AS elaborados
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado = 'Elaborado'
GROUP BY sigla_unidad
ORDER BY elaborados DESC;


-- ------------------------------------------------------------
-- 5. Top 5 al 100 %: sin "No cumple", ordenado por volumen.
--    Cambiar la columna agrupadora y el filtro según la categoría:
--      distritos      -> cosec_distrito
--      estaciones     -> unidad, con unidad LIKE 'ESTACION%'
--      subestaciones  -> cai,    con cai LIKE 'SUBESTACION%'
--      CAI            -> cai,    con cai LIKE 'CAI %'
--      patrullas      -> cuadrante
-- ------------------------------------------------------------
SELECT
    sigla_unidad,
    unidad,
    COUNT(*) AS actividades
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
  AND unidad LIKE 'ESTACION%'
GROUP BY sigla_unidad, unidad
HAVING SUM(CASE WHEN estado_cumplimiento = 'No cumple' THEN 1 ELSE 0 END) = 0
ORDER BY actividades DESC
LIMIT 5;


-- ------------------------------------------------------------
-- 6. Planes implementados: actividades cumplidas por plan y participación
-- ------------------------------------------------------------
SELECT
    plan_descripcion,
    COUNT(*)                                             AS cumplidos,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1)   AS porcentaje
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
  AND estado_cumplimiento = 'Cumple'
GROUP BY plan_descripcion
ORDER BY cumplidos DESC;


-- ------------------------------------------------------------
-- 7. Histórico semanal del año (semana 1 = 2025-12-28 a 2026-01-03)
-- ------------------------------------------------------------
WITH base AS (
    SELECT
        date_add('day', -(day_of_week(fecha_inicio_act) % 7), date(fecha_inicio_act)) AS inicio_semana,
        estado_cumplimiento
    FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
    WHERE fecha_inicio_act >= TIMESTAMP '2025-12-28 00:00:00'
      AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
      AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
)
SELECT
    date_diff('day', DATE '2025-12-28', inicio_semana) / 7 + 1                AS semana,
    inicio_semana,
    SUM(CASE WHEN estado_cumplimiento = 'Cumple'    THEN 1 ELSE 0 END)        AS cumplidos,
    SUM(CASE WHEN estado_cumplimiento = 'No cumple' THEN 1 ELSE 0 END)        AS no_cumplidos,
    COUNT(*)                                                                  AS total_planeado
FROM base
GROUP BY inicio_semana
ORDER BY inicio_semana;


-- ------------------------------------------------------------
-- 8. Plan mínimo de la guía GESCOV: techo(cuadrantes / 2) x 6 x 7
-- ------------------------------------------------------------
SELECT
    sigla_unidad,
    COUNT(DISTINCT cuadrante)                                          AS cuadrantes,
    CEIL(COUNT(DISTINCT cuadrante) / 2.0) * 6 * 7                      AS plan_minimo_semana,
    COUNT(*)                                                           AS total_planeado,
    ROUND(100.0 * COUNT(*) / (CEIL(COUNT(DISTINCT cuadrante) / 2.0) * 6 * 7)) AS porcentaje_del_minimo
FROM "pon-prod-raw-disec"."usr_disec.v_gescov_ddhh"
WHERE fecha_inicio_act >= TIMESTAMP '2026-02-08 00:00:00'
  AND fecha_inicio_act <  TIMESTAMP '2026-02-15 00:00:00'
  AND estado IN ('Aprobacion Distrito', 'Aprobacion Estacion', 'Aprobado Extraordinario')
GROUP BY sigla_unidad
ORDER BY porcentaje_del_minimo;


-- ------------------------------------------------------------
-- 9. Delitos de impacto (SIEDCO): registros del 1 de enero al corte,
--    año actual frente al mismo periodo del año anterior.
--    Cada registro es un caso; no usar la columna cantidad.
-- ------------------------------------------------------------
SELECT
    tematica,
    COUNT_IF(fecha_hecho BETWEEN DATE '2025-01-01' AND DATE '2025-02-18') AS anio_anterior,
    COUNT_IF(fecha_hecho BETWEEN DATE '2026-01-01' AND DATE '2026-02-18') AS anio_actual
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tematica IN (
    'HOMICIDIO DOLOSO O INTENCIONAL', 'LESIONES PERSONALES',
    'HURTO PERSONAS', 'HURTO RESIDENCIAS', 'HURTO COMERCIO', 'HURTO AUTOMOTORES',
    'HURTO MOTOCICLETAS', 'HURTO BANCOS', 'HURTO A SEMOVIENTES', 'HURTO CELULAR', 'HURTO A BICICLETAS',
    'SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO', 'EXTORSION', 'DELITOS SEXUALES',
    'VIOLENCIA INTRAFAMILIAR', 'HURTO PIRATERIA', 'ACCIONES SUBVERSIVAS', 'TERRORISMO',
    'HOMICIDIOS EN AT', 'LESIONES AT')
GROUP BY tematica
ORDER BY anio_anterior DESC;

-- Feminicidios: homicidios con la marca en conductas_especiales o descripcion_conducta.
SELECT
    COUNT_IF(fecha_hecho BETWEEN DATE '2025-01-01' AND DATE '2025-02-18') AS anio_anterior,
    COUNT_IF(fecha_hecho BETWEEN DATE '2026-01-01' AND DATE '2026-02-18') AS anio_actual
FROM pon_prod_raw_siedco_delitos_temporal.vw_delitos_corregido_schema_temporal
WHERE tematica = 'HOMICIDIO DOLOSO O INTENCIONAL'
  AND (upper(conductas_especiales) LIKE '%FEMINI%' OR upper(descripcion_conducta) LIKE '%FEMINI%');
