-- ============================================================
-- Fecha de Creación: 2026-10-13
-- Campo de fecha utilizado: FECHA_HECHO (texto DD/MM/YYYY, se convierte con TO_DATE)
-- Reglas aplicadas:
--   * Ventana de los ultimos 6 meses (la misma del job de Glue).
--   * Un archivo por turno: 1 PRIMERO, 2 SECUNDO, 3 TERCERO.
--   * Clasificacion por categoria / subcategoria / detalle.
--   * Se excluyen accidentes de transito (HOMICIDIOS EN AT, LESIONES AT).
--   * La droga solo sale en DROGA INCAUTADA (SIEDCO la repite en MERCANCIA INCAUTADA).
-- ============================================================

-- QUERY PARA OBTENER LOS DATOS DE SIEDCO CLASIFICADOS POR TEMATICA
-- (equivale a lo que genera el job de Glue; agregar AND turno = '3 TERCERO' para una sola capa)
SELECT *
FROM (
  SELECT
    CASE
      WHEN tematica = 'CAPTURAS' THEN 'CAPTURAS'
      WHEN tematica IN ('AUTOMOTORES RECUPERADOS', 'MOTOCICLETAS RECUPERADAS') THEN 'VEHICULOS RECUPERADOS'
      WHEN tematica = 'INCAUTACION DROGA' THEN 'DROGA INCAUTADA'
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' THEN 'ARMAS INCAUTADAS'
      WHEN tematica IN ('MERCANCIA RECUPERADA', 'MERCANCIA INCAUTADA') THEN 'CASOS DE MERCANCIA'
      ELSE 'DELITOS'
    END AS categoria,
    CASE
      -- 1. Capturas
      WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'ORDEN JUDICIAL%' THEN 'ORDEN JUDICIAL'
      WHEN tematica = 'CAPTURAS' AND circunstancia_captura LIKE 'FLAGRANCIA%' THEN 'FLAGRANCIA'
      -- 2. Vehiculos recuperados
      WHEN tematica = 'AUTOMOTORES RECUPERADOS' THEN 'AUTOMOTORES'
      WHEN tematica = 'MOTOCICLETAS RECUPERADAS' THEN 'MOTOCICLETAS'
      -- 3. Droga incautada (en la base "bazuco" esta escrito BASUCO)
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'COCAINA' THEN 'COCAINA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'HEROINA' THEN 'HEROINA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASE DE COCA' THEN 'BASE DE COCA'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'BASUCO' THEN 'BAZUCO'
      WHEN tematica = 'INCAUTACION DROGA' AND clase_bien = 'MARIHUANA' THEN 'MARIHUANA'
      -- 4. Armas incautadas
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'CON_PERMISO' THEN 'CON PERMISO'
      WHEN tematica = 'INCAUTACION ARMAS DE FUEGO' AND permiso_arma = 'SIN_PERMISO' THEN 'SIN PERMISO'
      -- 5. Casos de mercancia
      WHEN tematica = 'MERCANCIA RECUPERADA' AND NVL(tipo_bien, '-') <> 'VEHICULOS' THEN 'RECUPERADA'
      -- La droga ya sale en DROGA INCAUTADA: SIEDCO la repite en MERCANCIA INCAUTADA
      WHEN tematica = 'MERCANCIA INCAUTADA' AND NVL(tipo_bien, '-') <> 'ARMAMENTO'
           AND NVL(clase_bien, '-') NOT IN ('COCAINA', 'HEROINA', 'BASE DE COCA', 'BASUCO', 'MARIHUANA') THEN 'INCAUTADA'
      -- 6. Delitos
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
    END AS subcategoria,
    -- Tercer nivel solo para hurto y secuestro
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
    END AS detalle,
    t.*
  FROM usr_esta.motivospolicia t
  -- Mismo corte que usa hoy el job de las capas: ultimos 6 meses
  WHERE TO_DATE(fecha_hecho, 'DD/MM/YYYY') >= ADD_MONTHS(TRUNC(SYSDATE), -6)
)
WHERE subcategoria IS NOT NULL;

-- TEMATICAS DISPONIBLES EN LA TABLA (deben ser 29)
SELECT tematica, COUNT(*) AS registros
FROM usr_esta.motivospolicia
GROUP BY tematica
ORDER BY registros DESC;

-- CLASES DE DROGA DE LA TEMATICA INCAUTACION DROGA (define las subcategorias de droga)
SELECT clase_bien, tipo_bien, unidad_medida, COUNT(*) AS n
FROM usr_esta.motivospolicia
WHERE tematica = 'INCAUTACION DROGA'
GROUP BY clase_bien, tipo_bien, unidad_medida
ORDER BY n DESC;
