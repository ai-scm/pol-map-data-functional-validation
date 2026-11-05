-- Policía Comunitaria · consultas de Athena que ejecuta el motor (procesador, zonificacion_v2.py y fuentes_internas.py)
-- Sirven para reproducir un conteo de una tarjeta. Ejemplo: estación de Zipaquirá (DESAB 64779), mes procesado 2026-09.
--   * Ventana de hechos: los 3 meses que terminan en el mes procesado -> [2026-07-01, 2026-10-01)
--   * Ventana de antecedentes (zonas preventivas): los 9 meses anteriores -> [2025-10-01, 2026-07-01)
--   * Rectángulo (bbox) de la estación: reemplazar por el de su polígono (minx, miny, maxx, maxy en lon/lat).
--     El motor después recorta cada punto con el polígono real y con el de cada zona.

-- ─────────────────────────────────────────────────────────────────────────────
-- 1. SIEDCO · delitos y actividad operativa (database pon_prod_raw_siedco_delitos_temporal)
--    Misma vista y misma clasificación que la capa "Fuentes Internas - SIEDCO" del mapa.
--    Los registros sin subcategoría (accidentes de tránsito, droga repetida en mercancía) no están en el mapa.
-- ─────────────────────────────────────────────────────────────────────────────
SELECT * FROM (
  SELECT tematica, delito_asociado, modalidad, armas_medios, clase_sitio,
         fecha_hecho, hora_hecho, hora_24, hechos_id, latitud, longitud,
         CASE
           WHEN tematica = 'CAPTURAS' THEN 'CAPTURAS'
           WHEN tematica IN ('AUTOMOTORES RECUPERADOS', 'MOTOCICLETAS RECUPERADAS') THEN 'VEHICULOS RECUPERADOS'
           WHEN tematica = 'INCAUTACION DROGA' THEN 'DROGA INCAUTADA'
           WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' THEN 'ARMAS INCAUTADAS'
           WHEN tematica IN ('MERCANCIA RECUPERADA', 'MERCANCIA INCAUTADA') THEN 'CASOS DE MERCANCIA'
           ELSE 'DELITOS' END AS categoria,
         CASE
           WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'ORDEN JUDICIAL%' THEN 'ORDEN JUDICIAL'
           WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'FLAGRANCIA%' THEN 'FLAGRANCIA'
           WHEN tematica = 'AUTOMOTORES RECUPERADOS' THEN 'AUTOMOTORES'
           WHEN tematica = 'MOTOCICLETAS RECUPERADAS' THEN 'MOTOCICLETAS'
           WHEN tematica = 'INCAUTACION DROGA' AND clase_bien IN ('COCAINA', 'HEROINA', 'BASE DE COCA', 'BASUCO', 'MARIHUANA') THEN clase_bien
           WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma IN ('CON_PERMISO', 'SIN_PERMISO') THEN permiso_arma
           WHEN tematica = 'MERCANCIA RECUPERADA' AND COALESCE(tipo_bien, '-') <> 'VEHICULOS' THEN 'RECUPERADA'
           WHEN tematica = 'MERCANCIA INCAUTADA' AND COALESCE(tipo_bien, '-') <> 'ARMAMENTO'
                AND COALESCE(clase_bien, '-') NOT IN ('COCAINA', 'HEROINA', 'BASE DE COCA', 'BASUCO', 'MARIHUANA') THEN 'INCAUTADA'
           WHEN tematica IN ('HOMICIDIO DOLOSO O INTENCIONAL', 'LESIONES PERSONALES', 'HURTO PERSONAS', 'HURTO RESIDENCIAS',
                             'HURTO COMERCIO', 'HURTO AUTOMOTORES', 'HURTO MOTOCICLETAS', 'HURTO BANCOS',
                             'HURTO A SEMOVIENTES', 'HURTO CELULAR', 'HURTO A BICICLETAS', 'HURTO A CABLE',
                             'SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO', 'DELITOS SEXUALES', 'EXTORSION',
                             'HURTO PIRATERIA', 'TERRORISMO', 'VIOLENCIA INTRAFAMILIAR', 'ACCIONES SUBVERSIVAS') THEN tematica
         END AS subcategoria
  FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal"
  WHERE fecha_hecho >= date '2026-07-01' AND fecha_hecho < date '2026-10-01'
    AND latitud BETWEEN 4.98 AND 5.10 AND longitud BETWEEN -74.05 AND -73.92      -- bbox de ejemplo (Zipaquirá)
) WHERE subcategoria IS NOT NULL;

-- Homicidios de SIEDCO en la ventana (los que cuentan como homicidio en las zonas; las capturas por homicidio no):
SELECT fecha_hecho, hora_hecho, modalidad, armas_medios, clase_sitio, latitud, longitud
FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal"
WHERE tematica = 'HOMICIDIO DOLOSO O INTENCIONAL'
  AND fecha_hecho >= date '2026-07-01' AND fecha_hecho < date '2026-10-01'
  AND latitud BETWEEN 4.98 AND 5.10 AND longitud BETWEEN -74.05 AND -73.92;

-- ─────────────────────────────────────────────────────────────────────────────
-- 2. SECAD · casos de la línea 123 (database pon-prod-capas-iapol, tablas capa_11, capa_12 y capa_13)
--    capa_11 = hurto violento y homicidio · capa_12 = hurto general · capa_13 = riñas.
--    Se filtra por sigla y por la estación con sus dependientes (codigo_unidad), no por coordenadas.
--    Una llamada puede estar en varias filas: el motor deja un caso por llamada (hora_caso + ubicación).
-- ─────────────────────────────────────────────────────────────────────────────
SELECT latitud, longitud, hora_caso, prioridad, importancia, direccion, cod_inicial_desc, dpto, sitio, barrio,
       motivo, comentario,
       min(date(concat(anio, '-', lpad(mes, 2, '0'), '-', lpad(dia, 2, '0')))) AS fecha_particion
FROM "pon-prod-capas-iapol"."capa_13"
WHERE sigla = 'DESAB' AND codigo_unidad IN ('64779')          -- la estación y sus unidades dependientes
  AND anio IN ('2026')
  AND date(concat(anio, '-', lpad(mes, 2, '0'), '-', lpad(dia, 2, '0'))) >= date '2026-07-01'
  AND date(concat(anio, '-', lpad(mes, 2, '0'), '-', lpad(dia, 2, '0'))) <  date '2026-10-01'
GROUP BY latitud, longitud, hora_caso, prioridad, importancia, direccion, cod_inicial_desc, dpto, sitio, barrio,
         motivo, comentario;

-- Diagnóstico: unidades de una sigla con registros SECAD sin asignar (codigo_unidad = 0 queda fuera del mapa y del motor)
SELECT sigla, codigo_unidad, count(*) AS registros
FROM "pon-prod-capas-iapol"."capa_13"
WHERE anio = '2026' AND mes IN ('7', '8', '9') AND sigla = 'DESAB'
GROUP BY sigla, codigo_unidad ORDER BY registros DESC;

-- Diagnóstico de la lectura de Parquet (incidente MEVAL, noviembre de 2026): si algún archivo guardó `latitud` como
-- texto, esta consulta falla con HIVE_BAD_DATA aunque `count(*)` funcione (count no lee la columna).
SELECT max(latitud) FROM "pon-prod-capas-iapol"."capa_11"
WHERE sigla = 'MEVAL' AND anio = '2026' AND mes IN ('7', '8', '9');

-- ─────────────────────────────────────────────────────────────────────────────
-- 3. Otras fuentes internas (ventanas: SIMEP 3 meses, MTRS 12 meses, IRIS P1 vigentes, SIRAP 3 meses)
-- ─────────────────────────────────────────────────────────────────────────────
-- SIMEP · medidas de protección por violencia intrafamiliar
SELECT auto_id, tipo_conducta, fecha_creacion, latitud, longitud
FROM "pon-prod-raw-disec"."simep_datac"
WHERE fecha_creacion >= timestamp '2026-07-01' AND fecha_creacion < timestamp '2026-10-01'
  AND try_cast(latitud AS double) BETWEEN 4.98 AND 5.10 AND try_cast(longitud AS double) BETWEEN -74.05 AND -73.92;

-- MTRS · mesas técnicas de riesgo social (12 meses: de 2025-10-01 a 2026-10-01)
SELECT riesgo_social, otro_riesgo, delito, valoracion_riesgo, estado_riesgo, fecha_inicio_mesa_tecnica, latitud, longitud
FROM "pon-prod-raw-disec"."usr_disec.v_mtrs_riesgo_ubicacion"
WHERE fecha_inicio_mesa_tecnica >= timestamp '2025-10-01' AND fecha_inicio_mesa_tecnica < timestamp '2026-10-01'
  AND try_cast(latitud AS double) BETWEEN 4.98 AND 5.10 AND try_cast(longitud AS double) BETWEEN -74.05 AND -73.92;

-- IRIS P1 · estructuras criminales vigentes (todas; solo pesan las reportadas en la ventana)
SELECT delito_principal, fecha_creacion_irisp1, latitud, longitud
FROM "pon-prod-raw-disec"."usr_disec.v_general_irisp"
WHERE estado_existencia != 'No existe'
  AND try_cast(latitud AS double) BETWEEN 4.98 AND 5.10 AND try_cast(longitud AS double) BETWEEN -74.05 AND -73.92;

-- SIRAP · manifestaciones públicas (GEOPOL / PMU)
SELECT id_actividad, fecha_inicio, cant_personas, latitud, longitud
FROM "pon-prod-raw-geopol"."raw_geopol_usr_pmu_actividades"
WHERE fecha_inicio >= timestamp '2026-07-01' AND fecha_inicio < timestamp '2026-10-01'
  AND try_cast(latitud AS double) BETWEEN 4.98 AND 5.10 AND try_cast(longitud AS double) BETWEEN -74.05 AND -73.92;
