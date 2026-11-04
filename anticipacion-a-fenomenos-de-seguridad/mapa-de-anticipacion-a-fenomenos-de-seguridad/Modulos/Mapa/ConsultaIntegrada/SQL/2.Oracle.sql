-- ============================================================
-- Fecha de Creación: 2026-11-03
-- Servicio: POST /bff/antecedentes-comparendos-personas (actores-potenciales-bff)
-- Origen de las consultas: actores_potenciales/api/app/config.json
--   y app/services/oracle_service.py (repositorio pon-iapol-capas)
-- Campo de fecha utilizado: ver cada consulta (FECHA / FECHA_INICIO_EXISTENCIA)
-- Reglas aplicadas:
--   * :key_value es la cédula enviada en "value" (se pasa como variable bind).
--   * Los filtros de fecha son opcionales: solo se agregan si el cliente envía
--     fecha_inicio / fecha_fin. Una fecha sin hora cubre el día completo
--     (inicio 00:00:00, fin 23:59:59).
--   * Conexión Oracle: puerto 1538, call_timeout 60 s (ORACLE_CALL_TIMEOUT_MS).
-- ============================================================


-- ============================================================
-- RAMA CIUDADANO  (value_type = 'cc' o cualquier valor distinto de 'idpolicia')
-- ============================================================

-- 1. ANTECEDENTES CONSULTADOS SOBRE LA PERSONA  ->  "antecedentes_personas"
--    Base de datos: SIVICC (secreto pon-prod-sivicc-connection)
SELECT FECHA, IDENTIFICACION, CIUDADANO, GENERO, ESTADO,
       TIENE_ANTECEDENTES, TIENE_DETENCION, CC_FUNCIONARIO, FUNCIONARIO,
       LATITUD, LONGITUD
FROM USR_MNVCC.AUDITORIA_CONS_PERSONA
WHERE IDENTIFICACION = :key_value
  AND FECHA >= :fecha_inicio        -- opcional
  AND FECHA <= :fecha_fin;          -- opcional


-- 2. COMPARENDOS (RNMC) DE LA PERSONA  ->  "comparendos"
--    Base de datos: DBOPER (secreto pon-prod-DBOPER-on-premise)
--    Se hace en dos consultas y se unen en memoria con pandas (inner join por ID_HECHOS).

-- 2a. Tabla base: la persona como infractor (ID_TIPO_PERSONA = 350). Sin filtro de fecha.
SELECT FECHA_CREACION, IDENTIFICACION, NOMBRES, APELLIDOS, EDAD, ID_HECHOS
FROM USR_CNP.CNP_PERSONAS
WHERE IDENTIFICACION = :key_value
  AND ID_TIPO_PERSONA = 350;

-- 2b. Tabla de hechos: se consulta por bloques de máximo 1000 ID_HECHOS (límite ORA-01795).
--     El filtro de fecha se aplica aquí, sobre la fecha del hecho.
SELECT ID_HECHOS, FECHA AS FECHA_HECHO, LOCALIDAD, DIRECCION_HECHOS,
       ID_COMPORTAMIENTO, APELACION, ATIENDE_APELACION, APLICA_MEDIDA, VIGENTE,
       RELATO_HECHOS, OBSERVACIONES_PONAL,
       IDENTIFICACION_POL AS CC_FUNCIONARIO, LATITUD, LONGITUD
FROM USR_CNP.CNP_HECHOS
WHERE ID_HECHOS IN (:val0, :val1 /* ... hasta :val999 */)
  AND FECHA >= :fecha_inicio        -- opcional
  AND FECHA <= :fecha_fin;          -- opcional

-- 2c. El nombre del funcionario (campo FUNCIONARIO) se agrega después con Athena:
--     ver 1.Athena.sql.


-- 3. IRIS P1 DE LA PERSONA  ->  "resultados_iris_p1"
--    Base de datos: DISEC (secreto pon-prod-disec-op-rnmc)
--    Si esta consulta falla (p. ej. ORA-01722 con cédulas no numéricas) el servicio
--    registra el error y devuelve la lista vacía; no afecta el resto de la respuesta.
SELECT i.ALIAS, i.NOMBRE, i.APELLIDO, i.CEDULA,
       v.CRIMINALIDAD_ID, v.ESTADO, v.ESTADO_EXISTENCIA, v.CODIGO_IRISP,
       v.DELITO_PRINCIPAL, v.DELITO_SECUNDARIO, v.SIGLA_UNIDAD, v.UNIDAD,
       v.MUNICIPIO, v.ZONA, v.NOMBRE_CLASE, v.FECHA_INICIO_EXISTENCIA,
       v.CANTIDAD_INTEGRANTE, v.CARACTERISTICAS_GENERALES, v.DESCRIPCION_TRAMITE,
       v.LATITUD, v.LONGITUD, v.BARRIO
FROM USR_DISEC.IRISP_INTEGRANTE i
JOIN USR_DISEC.VM_GENERAL_IRISP v ON i.CRIMINALIDAD_ID = v.CRIMINALIDAD_ID
WHERE i.CEDULA = :key_value
  AND v.FECHA_INICIO_EXISTENCIA >= :fecha_inicio   -- opcional
  AND v.FECHA_INICIO_EXISTENCIA <= :fecha_fin;     -- opcional


-- ============================================================
-- RAMA POLICÍA  (value_type = 'idpolicia'; :key_value = cédula del funcionario)
-- Devuelve lo que ese funcionario consultó o impuso, no datos de un ciudadano.
-- ============================================================

-- 4. ANTECEDENTES DE PERSONAS CONSULTADOS POR EL POLICÍA  ->  "antecedentes_personas"
--    SIVICC. "FECHA + 0" evita que Oracle use el índice de FECHA (con rangos cortos
--    recorría todas las consultas del país y el ALB respondía 504).
SELECT FECHA, IDENTIFICACION, CIUDADANO, GENERO, ESTADO,
       TIENE_ANTECEDENTES, TIENE_DETENCION, CC_FUNCIONARIO, FUNCIONARIO,
       LATITUD, LONGITUD
FROM USR_MNVCC.AUDITORIA_CONS_PERSONA
WHERE CC_FUNCIONARIO = :key_value
  AND FECHA + 0 >= :fecha_inicio    -- opcional
  AND FECHA + 0 <= :fecha_fin;      -- opcional


-- 5. VEHÍCULOS CONSULTADOS POR EL POLICÍA  ->  "antecedentes_vehiculos"
--    SIVICC. Corre en un hilo aparte con límite de 25 s (timeout_segundos):
--    si no responde a tiempo, la respuesta sale sin este bloque y
--    metadata.vehiculos_error = 'timeout'.
SELECT FECHA_CREACION, PLACA, CLASE, TIENE_ANTECEDENTES,
       USUARIO_CREACION AS CC_FUNCIONARIO, LATITUD, LONGITUD
FROM USR_MNVCC.AUDITORIA_CONS_VEHICULO
WHERE USUARIO_CREACION = :key_value
  AND FECHA_CREACION >= :fecha_inicio   -- opcional
  AND FECHA_CREACION <= :fecha_fin;     -- opcional


-- 6. COMPARENDOS IMPUESTOS POR EL POLICÍA  ->  "comparendos"
--    DBOPER. Mismo esquema de dos consultas + unión en memoria que el punto 2.

-- 6a. Hechos impuestos por el funcionario (el filtro de fecha va en la tabla base)
SELECT ID_HECHOS, FECHA AS FECHA_HECHO, LOCALIDAD, DIRECCION_HECHOS,
       ID_COMPORTAMIENTO, APELACION, ATIENDE_APELACION, APLICA_MEDIDA, VIGENTE,
       RELATO_HECHOS, OBSERVACIONES_PONAL,
       IDENTIFICACION_POL AS CC_FUNCIONARIO, LATITUD, LONGITUD
FROM USR_CNP.CNP_HECHOS
WHERE IDENTIFICACION_POL = :key_value
  AND FECHA >= :fecha_inicio        -- opcional
  AND FECHA <= :fecha_fin;          -- opcional

-- 6b. Personas de cada hecho (350 = infractor; 365 y 565 = testigo / custodio)
SELECT ID_HECHOS, ID_TIPO_PERSONA, FECHA_CREACION, ID_TIPO_DOC, IDENTIFICACION,
       NOMBRES, APELLIDOS, EDAD, ID_GENERO, NACIONALIDAD, TELEFONO, EMAIL,
       ACTIVIDAD_COMERCIAL, ID_POBLA_VULNERABLE, RAZON_SOCIAL, NIT,
       ID_PAIS_RESIDE, ID_MUN_RESIDE, DIRECCION_RESIDE, NOMBRE_VIA, NUMERO_VIA,
       VALOR1_VIA, VALOR2_VIA, VALOR3_VIA, VALOR4_VIA, VALOR5_VIA, VALOR6_VIA, VALOR7_VIA,
       COMPLEMENTO1, VALOR_COMPLEMENTO1, COMPLEMENTO2, VALOR_COMPLEMENTO2,
       COMPLEMENTO3, VALOR_COMPLEMENTO3
FROM USR_CNP.CNP_PERSONAS
WHERE ID_HECHOS IN (:val0, :val1 /* ... bloques de 1000 */)
  AND ID_TIPO_PERSONA IN (350, 365, 565);

-- 6c. Catálogos que se cargan una vez en memoria para traducir códigos
--     (si fallan se reintentan a los 5 minutos y los nombres quedan en null)
SELECT ID_DOMINIO, DESCRIPCION FROM USR_CNP.CNP_DOMINIOS;
SELECT CODIGO, DESCRIPCION, TIPO, LUGE_CODIGO FROM USR_CNP.VM_LUGARES_GEOGRAFICOS;
