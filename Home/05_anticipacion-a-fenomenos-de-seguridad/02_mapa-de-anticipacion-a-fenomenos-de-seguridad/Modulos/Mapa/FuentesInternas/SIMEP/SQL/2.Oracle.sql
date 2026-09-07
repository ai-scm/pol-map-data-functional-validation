-- ============================================================
-- Fecha de Creación: 2023-10-01
-- Campo de fecha utilizado: 
-- Reglas aplicadas:
-- ============================================================

-- QUERY PARA OBTENER LOS DATOS DE LA TABLA DE SIMEP
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
FROM "USR_DISEC"."V_SIMEP_MEDIDAS_ARCGIS" medida
LEFT JOIN "USR_DISEC"."V_SIMEP_INTERVINIENTES_ARCGIS" interviniente 
    ON medida.auto_id = interviniente.auto_id
INNER JOIN "USR_DISEC"."V_SIMEP_AUTOS_ARCGIS" auto 
    ON medida.auto_id = auto.auto_id
WHERE auto.fecha_expedicion <= TRUNC(SYSDATE)
AND auto.sigla_fisica = 'MEBOG';
