-- ============================================================
-- Fecha de Creación: 2023-10-01
-- Campo de fecha utilizado: 
-- Reglas aplicadas:
-- ============================================================

-- QUERY PARA OBTENER LOS DATOS DE LA TABLA DE GESCOV
SELECT * FROM usr_disec.v_evos_planes
WHERE estado_cumplimiento = 'Cumple' 
AND sigla_unidad = 'MEBOG'
AND fecha_inicio_plan > timestamp '2026-07-12 00:00:00';
