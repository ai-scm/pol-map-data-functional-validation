-- ============================================================
-- Fecha de Creación: 2026-11-03
-- Servicio: POST /bff/antecedentes-comparendos-personas (actores-potenciales-bff)
-- Origen de la consulta: actores_potenciales/api/app/services/central_service.py
--   (método _enriquecer_con_funcionarios, repositorio pon-iapol-capas)
-- Campo de fecha utilizado: ninguno (esta consulta no filtra por fecha)
-- Reglas aplicadas:
--   * Se ejecuta una sola vez por petición, con los CC_FUNCIONARIO distintos
--     que aparecieron en los comparendos.
--   * Sirve solo para completar el campo FUNCIONARIO (nombre del policía).
--     Los antecedentes de SIVICC ya traen su propio FUNCIONARIO.
--   * Si Athena falla o no encuentra la cédula, FUNCIONARIO queda en null y la
--     respuesta sigue siendo 200 (el error solo queda en los logs).
--   * Resultados en s3://pon-prod-athena-query-results-capas-adicionales/capa-actores-potenciales/
-- ============================================================


-- NOMBRE DEL FUNCIONARIO A PARTIR DE SU CÉDULA
-- DataSource: AwsDataCatalog | Database: pon-prod-raw-sivicc
SELECT ROUND(identificacion) AS identificacion,
       funcionario
FROM "pon-prod-raw-sivicc"."usr_mnvcc.vm_personal_agrupado"
WHERE ROUND(identificacion) IN (1234567890, 9876543210);   -- lista armada en tiempo de ejecución
