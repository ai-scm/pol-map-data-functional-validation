SELECT
  "archive_size",
  "archive_last_modified",
  "archive_status",
  "archive_name",
  "archive_content_type",
  "modified_by",
  "archive_created_at",
  "archive_extension",
  "class_name",
  "document_key",
  ingestion_status,
  CASE upper(coalesce(ingestion_status, 'UNKNOWN'))
    WHEN 'UPLOADED' THEN 'Archivo recibido'
    WHEN 'PROCESSING' THEN 'Leyendo y preparando el documento'
    WHEN 'CHUNKED' THEN 'Contenido preparado'
    WHEN 'STORED' THEN 'Documento guardado'
    WHEN 'QUEUED_FOR_INDEXING' THEN 'En espera de incorporación al chatbot'
    WHEN 'INDEXING' THEN 'Incorporando contenido al chatbot'
    WHEN 'INDEXED' THEN 'Contenido incorporado; pendiente de verificación'
    WHEN 'VERIFYING' THEN 'Verificando disponibilidad'
    WHEN 'AVAILABLE' THEN 'Disponible para consultas'
    WHEN 'DELETING' THEN 'Retirando documento'
    WHEN 'DELETED' THEN 'Documento retirado'
    WHEN 'FAILED' THEN 'No se pudo completar el proceso'
    WHEN 'HISTORICAL_REVIEW' THEN 'Contenido consultable; requiere revisión'
    WHEN 'HISTORICAL_STORED' THEN 'Original guardado; contenido por verificar'
    WHEN 'HISTORICAL_MISSING_ORIGINAL' THEN 'Archivo original no encontrado'
    WHEN 'HISTORICAL_INVALID_ORIGINAL' THEN 'Archivo original incompleto; requiere reemplazo'
    WHEN 'HISTORICAL_RETIRED' THEN 'Retirado del inventario'
    WHEN 'HISTORICAL_RETIREMENT_REVIEW' THEN 'Retiro pendiente de completar'
    WHEN 'HISTORICAL_PARTIAL_INDEX' THEN 'Contenido parcialmente indexado'
    WHEN 'HISTORICAL_PENDING_INDEX' THEN 'Contenido preparado; indexación pendiente'
    WHEN 'UNKNOWN' THEN CASE WHEN archive_status = 'Deprecated'
      THEN 'Retirado (sin seguimiento histórico)' ELSE 'Sin seguimiento histórico' END
    ELSE 'Estado pendiente de confirmar'
  END AS estado_cargue,
  CAST(CASE upper(coalesce(ingestion_status, 'UNKNOWN'))
    WHEN 'UPLOADED' THEN 10 / 100.0
    WHEN 'PROCESSING' THEN 25 / 100.0
    WHEN 'CHUNKED' THEN 45 / 100.0
    WHEN 'STORED' THEN 60 / 100.0
    WHEN 'QUEUED_FOR_INDEXING' THEN 65 / 100.0
    WHEN 'INDEXING' THEN 80 / 100.0
    WHEN 'INDEXED' THEN 90 / 100.0
    WHEN 'VERIFYING' THEN 95 / 100.0
    WHEN 'AVAILABLE' THEN 100 / 100.0
    WHEN 'DELETED' THEN 100 / 100.0
    WHEN 'HISTORICAL_REVIEW' THEN 95 / 100.0
    WHEN 'HISTORICAL_STORED' THEN 60 / 100.0
    WHEN 'HISTORICAL_MISSING_ORIGINAL' THEN 0 / 100.0
    WHEN 'HISTORICAL_INVALID_ORIGINAL' THEN 0 / 100.0
    WHEN 'HISTORICAL_RETIRED' THEN 100 / 100.0
    WHEN 'HISTORICAL_RETIREMENT_REVIEW' THEN 95 / 100.0
    WHEN 'HISTORICAL_PARTIAL_INDEX' THEN 80 / 100.0
    WHEN 'HISTORICAL_PENDING_INDEX' THEN 65 / 100.0
    ELSE NULL
  END AS DOUBLE) AS avance_cargue
FROM "pon-prod-dynamo-tables"."default"."pon-prod-expertopol-document-inventory"
WHERE <<$SeguimientoActualizacion>> >= 0
