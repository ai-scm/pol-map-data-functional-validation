-- Policía Comunitaria · consultas a la base RDS (Aurora PostgreSQL) de las capas RNMC
-- Secreto con las credenciales: rds-db-credentials/cluster-DVZUIGEEPCWQ6GRZHOYTT66KFQ/administrador/1761077868271
-- (base `postgres`, tabla public.hechos_z1_v2). Solo lectura: el motor nunca escribe en esta base.
-- El host del secreto es el de lectura; la carga diaria (Glue RNMC-to-RDS) escribe por el endpoint del escritor.
-- Ejemplo: estación de Zipaquirá (DESAB 64779), mes procesado 2026-09 -> ventana [2026-07-01, 2026-09-30 23:59:00].

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. Comparendos (RNMC) que lee el motor para la estación y sus unidades dependientes
--    El mapa pide las capas RNMC por sigla + codigo_unidad; el motor igual, para que los conteos coincidan.
-- ─────────────────────────────────────────────────────────────────────────────
SELECT "comportamiento", "articulo", "numeral", "fecha", "LATITUD" AS latitud, "LONGITUD" AS longitud,
       "incautacion", "tipo_bien", "Clase_Bien", "cantidad", "Unidad", "Mediacion_policial", "aplica_medida",
       "REGION", "DEPARTAMENTO", "MUNICIPIO", "ESTACION", "SUB_CAI", "CUADRANTE2", "grupoedad", "Nacionalidad"
FROM public.hechos_z1_v2
WHERE sigla = 'DESAB' AND codigo_unidad IN (64779)
  AND "fecha" BETWEEN '2026-07-01 00:00:00' AND '2026-09-30 23:59:00';

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. En qué capa del mapa sale cada comparendo (regla deducida del servicio capas-adicionales; ver README, sección 1.4)
--      rnmc-rinas ........................ artículo 27, numeral 1 (riñas)
--      rnmc-incautaciones ................ incautacion = '1'
--      comportamientos-contrarios-... .... incautacion = '0' y no es riña
--    Un comparendo de riña con incautación sale en las dos primeras. El mapa quita además las filas idénticas.
-- ─────────────────────────────────────────────────────────────────────────────
SELECT CASE WHEN "articulo" = '27' AND "numeral" = '1' THEN 'rnmc-rinas' END AS capa_rinas,
       CASE WHEN "incautacion" = '1' THEN 'rnmc-incautaciones'
            WHEN "incautacion" = '0' AND NOT ("articulo" = '27' AND "numeral" = '1') THEN 'comportamientos' END AS capa_otra,
       count(*) AS registros
FROM public.hechos_z1_v2
WHERE sigla = 'DESAB' AND codigo_unidad IN (64779)
  AND "fecha" BETWEEN '2026-07-01 00:00:00' AND '2026-09-30 23:59:00'
GROUP BY 1, 2 ORDER BY registros DESC;

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. Diagnóstico de unidades sin comparendos
-- ─────────────────────────────────────────────────────────────────────────────
-- Comparendos sin sigla o sin unidad (no salen en el mapa ni en el motor). El incidente de octubre de 2026 dejó
-- la sigla vacía ('') en los cuadrantes nuevos y la sigla vieja REMSA en la Sabana (hoy MESOA y DESAB).
SELECT sigla, codigo_unidad, count(*) AS registros
FROM public.hechos_z1_v2
WHERE "fecha" >= '2026-07-01' AND (sigla IS NULL OR sigla = '' OR sigla = 'REMSA' OR codigo_unidad = 0)
GROUP BY sigla, codigo_unidad ORDER BY registros DESC;

-- Comparendos por mes y sigla (para ver si una sigla dejó de recibir carga)
SELECT sigla, date_trunc('month', "fecha") AS mes, count(*) AS registros
FROM public.hechos_z1_v2
WHERE sigla = 'DESAB' AND "fecha" >= '2026-01-01'
GROUP BY 1, 2 ORDER BY 2;
