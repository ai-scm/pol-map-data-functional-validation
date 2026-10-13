-- ============================================================
-- Fecha de Creación: 2026-10-13
-- Campo de fecha utilizado: FECHA_HECHO
-- Reglas aplicadas:
--   * Ventana de los ultimos 6 meses (la misma del job de Glue).
--   * Un archivo por turno: 1 PRIMERO, 2 SECUNDO, 3 TERCERO.
--   * Clasificacion por categoria / subcategoria / detalle.
--   * Se excluyen accidentes de transito (HOMICIDIOS EN AT, LESIONES AT).
--   * La droga solo sale en DROGA INCAUTADA (SIEDCO la repite en MERCANCIA INCAUTADA).
-- ============================================================

-- QUERY QUE EJECUTA EL JOB pon-prod-xcrime-update-fuentes-internas PARA GENERAR LA CAPA SIEDCO III
-- (para SIEDCO I y II cambiar el turno; la fecha es "hoy menos 6 meses")
SELECT *
FROM (
  SELECT v.*,
    CASE
      WHEN tematica = 'CAPTURAS' THEN 'CAPTURAS'
      WHEN tematica IN ('AUTOMOTORES RECUPERADOS', 'MOTOCICLETAS RECUPERADAS') THEN 'VEHICULOS RECUPERADOS'
      WHEN tematica = 'INCAUTACION DROGA' THEN 'DROGA INCAUTADA'
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' THEN 'ARMAS INCAUTADAS'
      WHEN tematica IN ('MERCANCIA RECUPERADA', 'MERCANCIA INCAUTADA') THEN 'CASOS DE MERCANCIA'
      ELSE 'DELITOS'
    END
     AS categoria,
    CASE
      WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'ORDEN JUDICIAL%' THEN 'ORDEN JUDICIAL'
      WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'FLAGRANCIA%' THEN 'FLAGRANCIA'
      WHEN tematica = 'AUTOMOTORES RECUPERADOS' THEN 'AUTOMOTORES'
      WHEN tematica = 'MOTOCICLETAS RECUPERADAS' THEN 'MOTOCICLETAS'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'COCAINA' THEN 'COCAINA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'HEROINA' THEN 'HEROINA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASE DE COCA' THEN 'BASE DE COCA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASUCO' THEN 'BAZUCO'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'MARIHUANA' THEN 'MARIHUANA'
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'CON_PERMISO' THEN 'CON PERMISO'
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'SIN_PERMISO' THEN 'SIN PERMISO'
      WHEN tematica = 'MERCANCIA RECUPERADA' AND COALESCE(tipo_bien, '-') <> 'VEHICULOS' THEN 'RECUPERADA'
      -- La droga ya sale en DROGA INCAUTADA: SIEDCO la repite en MERCANCIA INCAUTADA
      WHEN tematica = 'MERCANCIA INCAUTADA' AND COALESCE(tipo_bien, '-') <> 'ARMAMENTO'
           AND COALESCE(clase_bien, '-') NOT IN ('COCAINA', 'HEROINA', 'BASE DE COCA', 'BASUCO', 'MARIHUANA') THEN 'INCAUTADA'
      WHEN tematica = 'HOMICIDIO DOLOSO O INTENCIONAL' THEN 'HOMICIDIO'
      WHEN tematica = 'LESIONES PERSONALES' THEN 'LESIONES PERSONALES'
      WHEN tematica IN ('HURTO PERSONAS', 'HURTO RESIDENCIAS', 'HURTO COMERCIO', 'HURTO AUTOMOTORES',
                        'HURTO MOTOCICLETAS', 'HURTO BANCOS', 'HURTO A SEMOVIENTES', 'HURTO CELULAR',
                        'HURTO A BICICLETAS', 'HURTO A CABLE') THEN 'HURTO'
      WHEN tematica IN ('SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO') THEN 'SECUESTRO'
      WHEN tematica = 'DELITOS SEXUALES' THEN 'DELITOS SEXUALES'
      WHEN tematica = 'EXTORSION' THEN 'EXTORSION'
      WHEN tematica = 'HURTO PIRATERIA' THEN 'PIRATERIA'
      WHEN tematica = 'TERRORISMO' THEN 'TERRORISMO'
      WHEN tematica = 'VIOLENCIA INTRAFAMILIAR' THEN 'VIOLENCIA INTRAFAMILIAR'
      WHEN tematica = 'ACCIONES SUBVERSIVAS' THEN 'ACCIONES SUBVERSIVAS'
    END
     AS subcategoria,
    CASE tematica
      WHEN 'HURTO PERSONAS' THEN 'PERSONAS'
      WHEN 'HURTO RESIDENCIAS' THEN 'RESIDENCIAS'
      WHEN 'HURTO COMERCIO' THEN 'COMERCIO'
      WHEN 'HURTO AUTOMOTORES' THEN 'AUTOMOTORES'
      WHEN 'HURTO MOTOCICLETAS' THEN 'MOTOCICLETAS'
      WHEN 'HURTO BANCOS' THEN 'BANCOS'
      WHEN 'HURTO A SEMOVIENTES' THEN 'SEMOVIENTES'
      WHEN 'HURTO CELULAR' THEN 'CELULARES'
      WHEN 'HURTO A BICICLETAS' THEN 'BICICLETAS'
      WHEN 'HURTO A CABLE' THEN 'CABLE'
      WHEN 'SECUESTRO SIMPLE' THEN 'SIMPLE'
      WHEN 'SECUESTRO EXTORSIVO' THEN 'EXTORSIVO'
    END
     AS detalle
  FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal" v
  WHERE turno = '3 TERCERO'
  AND fecha_hecho >= date '2026-04-06'
)
WHERE subcategoria IS NOT NULL;

-- CONTEO POR TEMATICA PARA COMPARAR CONTRA ORACLE Y CONTRA EL MAPA
SELECT categoria, subcategoria, detalle, COUNT(*) AS registros
FROM (
  SELECT *
  FROM (
    SELECT v.*,
      CASE
        WHEN tematica = 'CAPTURAS' THEN 'CAPTURAS'
        WHEN tematica IN ('AUTOMOTORES RECUPERADOS', 'MOTOCICLETAS RECUPERADAS') THEN 'VEHICULOS RECUPERADOS'
        WHEN tematica = 'INCAUTACION DROGA' THEN 'DROGA INCAUTADA'
        WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' THEN 'ARMAS INCAUTADAS'
        WHEN tematica IN ('MERCANCIA RECUPERADA', 'MERCANCIA INCAUTADA') THEN 'CASOS DE MERCANCIA'
        ELSE 'DELITOS'
      END
       AS categoria,
      CASE
        WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'ORDEN JUDICIAL%' THEN 'ORDEN JUDICIAL'
        WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'FLAGRANCIA%' THEN 'FLAGRANCIA'
        WHEN tematica = 'AUTOMOTORES RECUPERADOS' THEN 'AUTOMOTORES'
        WHEN tematica = 'MOTOCICLETAS RECUPERADAS' THEN 'MOTOCICLETAS'
        WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'COCAINA' THEN 'COCAINA'
        WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'HEROINA' THEN 'HEROINA'
        WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASE DE COCA' THEN 'BASE DE COCA'
        WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASUCO' THEN 'BAZUCO'
        WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'MARIHUANA' THEN 'MARIHUANA'
        WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'CON_PERMISO' THEN 'CON PERMISO'
        WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'SIN_PERMISO' THEN 'SIN PERMISO'
        WHEN tematica = 'MERCANCIA RECUPERADA' AND COALESCE(tipo_bien, '-') <> 'VEHICULOS' THEN 'RECUPERADA'
        -- La droga ya sale en DROGA INCAUTADA: SIEDCO la repite en MERCANCIA INCAUTADA
        WHEN tematica = 'MERCANCIA INCAUTADA' AND COALESCE(tipo_bien, '-') <> 'ARMAMENTO'
             AND COALESCE(clase_bien, '-') NOT IN ('COCAINA', 'HEROINA', 'BASE DE COCA', 'BASUCO', 'MARIHUANA') THEN 'INCAUTADA'
        WHEN tematica = 'HOMICIDIO DOLOSO O INTENCIONAL' THEN 'HOMICIDIO'
        WHEN tematica = 'LESIONES PERSONALES' THEN 'LESIONES PERSONALES'
        WHEN tematica IN ('HURTO PERSONAS', 'HURTO RESIDENCIAS', 'HURTO COMERCIO', 'HURTO AUTOMOTORES',
                          'HURTO MOTOCICLETAS', 'HURTO BANCOS', 'HURTO A SEMOVIENTES', 'HURTO CELULAR',
                          'HURTO A BICICLETAS', 'HURTO A CABLE') THEN 'HURTO'
        WHEN tematica IN ('SECUESTRO SIMPLE', 'SECUESTRO EXTORSIVO') THEN 'SECUESTRO'
        WHEN tematica = 'DELITOS SEXUALES' THEN 'DELITOS SEXUALES'
        WHEN tematica = 'EXTORSION' THEN 'EXTORSION'
        WHEN tematica = 'HURTO PIRATERIA' THEN 'PIRATERIA'
        WHEN tematica = 'TERRORISMO' THEN 'TERRORISMO'
        WHEN tematica = 'VIOLENCIA INTRAFAMILIAR' THEN 'VIOLENCIA INTRAFAMILIAR'
        WHEN tematica = 'ACCIONES SUBVERSIVAS' THEN 'ACCIONES SUBVERSIVAS'
      END
       AS subcategoria,
      CASE tematica
        WHEN 'HURTO PERSONAS' THEN 'PERSONAS'
        WHEN 'HURTO RESIDENCIAS' THEN 'RESIDENCIAS'
        WHEN 'HURTO COMERCIO' THEN 'COMERCIO'
        WHEN 'HURTO AUTOMOTORES' THEN 'AUTOMOTORES'
        WHEN 'HURTO MOTOCICLETAS' THEN 'MOTOCICLETAS'
        WHEN 'HURTO BANCOS' THEN 'BANCOS'
        WHEN 'HURTO A SEMOVIENTES' THEN 'SEMOVIENTES'
        WHEN 'HURTO CELULAR' THEN 'CELULARES'
        WHEN 'HURTO A BICICLETAS' THEN 'BICICLETAS'
        WHEN 'HURTO A CABLE' THEN 'CABLE'
        WHEN 'SECUESTRO SIMPLE' THEN 'SIMPLE'
        WHEN 'SECUESTRO EXTORSIVO' THEN 'EXTORSIVO'
      END
       AS detalle
    FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal" v
    WHERE turno = '3 TERCERO'
    AND fecha_hecho >= date '2026-04-06'
  )
  WHERE subcategoria IS NOT NULL
)
GROUP BY categoria, subcategoria, detalle
ORDER BY categoria, subcategoria, detalle;

-- TEMATICAS DISPONIBLES EN LA COPIA CRUDA (deben ser 29)
SELECT tematica, COUNT(*) AS registros
FROM "pon_prod_raw_siedco_delitos_temporal"."raw_data_siedco_full_delitos"
GROUP BY tematica
ORDER BY registros DESC;

-- REGISTROS POR DIA DEL HECHO (para revisar hasta que fecha esta completa la carga)
SELECT fecha_hecho, COUNT(*) AS total, COUNT(DISTINCT tematica) AS tematicas
FROM "pon_prod_raw_siedco_delitos_temporal"."vw_delitos_corregido_schema_temporal"
WHERE fecha_hecho >= current_date - interval '15' day
GROUP BY fecha_hecho
ORDER BY fecha_hecho;
