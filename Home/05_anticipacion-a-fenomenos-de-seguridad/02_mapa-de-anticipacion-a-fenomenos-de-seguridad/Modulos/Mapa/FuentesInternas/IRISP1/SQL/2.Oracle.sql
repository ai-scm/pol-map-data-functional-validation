-- ============================================================
-- Fecha de Creación: 2023-10-01
-- Campo de fecha utilizado: 
-- Reglas aplicadas:
-- ============================================================

-- QUERY PARA OBTENER LOS DATOS DE LA TABLA DE GESCOV
SELECT * 
  FROM USR_DISEC.V_GENERAL_IRISP
        WHERE estado_existencia != 'No existe' 
        AND sigla_unidad = 'MEBOG';
