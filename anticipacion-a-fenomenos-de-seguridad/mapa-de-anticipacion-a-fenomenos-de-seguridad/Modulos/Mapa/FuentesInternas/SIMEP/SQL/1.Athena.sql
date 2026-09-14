-- ============================================================
-- Fecha de Creación: 2023-10-01
-- Campo de fecha utilizado: 
-- Reglas aplicadas:
-- ============================================================

-- QUERY PARA OBTENER LOS DATOS DE LA TABLA DE SIMEP
SELECT *
    FROM "pon-prod-raw-disec"."simep_datac"
    WHERE fecha_creacion <= current_date

-- QUERY PARA OBTENER LOS DATOS DE LA TABLA DE SIMEP FILTRADOS POR SIGLA
SELECT DISTINCT
    medida.auto_id,
    medida.descripcion_medida,
    medida.tipo_conducta,
    medida.tipo_medida,
    medida.m_articulo,
    medida.m_literal,
    medida.numero_expediente,
    auto.fecha_expedicion AS fecha_creacion,
    auto.latitud,
    auto.longitud,
    auto.id_unidad,
    auto.descripcion_dependencia,
    auto.sigla_fisica,
    auto.cod_regional,
    auto.desc_regional,
    (CASE WHEN (medida.vigente = 1) THEN 'Si' ELSE 'No' END) AS vigente
FROM "pon-prod-raw-simep-s3"."usr_simep_v_simep_medidas_arcgis" medida
LEFT JOIN "pon-prod-raw-simep-s3"."usr_simep_v_simep_intervinientes_arcgis" interviniente 
    ON medida.auto_id = interviniente.auto_id
INNER JOIN "pon-prod-raw-simep-s3"."usr_simep_v_simep_autos_arcgis" auto 
    ON medida.auto_id = auto.auto_id
WHERE auto.fecha_expedicion <= current_date
AND auto.sigla_fisica = 'MEBOG';
