# Documentación técnica de Tableros de Monitoreo

## Objetivo y alcance

Este documento relaciona los seis accesos del módulo con sus activos de Amazon Quick, análisis y conjuntos de datos. La documentación de cada submódulo detalla filtros, parámetros, campos calculados, agregaciones, alcance temporal, dependencias y pruebas técnicas.

La inspección se realizó el 2026-09-04 sobre los dashboards publicados y, cuando estuvo disponible, sobre el análisis editable. No se copiaron valores de registros productivos, datos personales, coordenadas, teléfonos, credenciales ni URL internas.

## Convención de evidencia

| Estado | Significado |
|---|---|
| Confirmado | La expresión, filtro o campo se leyó directamente en el análisis o en la configuración del visual. |
| Observado | El comportamiento, control, encabezado o agregación aparece en el dashboard o análisis, pero no se obtuvo su expresión completa. |
| Inferido | La regla se deduce del nombre y configuración visible. Debe confirmarse antes de usarla como contrato. |
| Pendiente | El activo o su configuración no estuvo disponible; no se propone una regla como si fuera real. |

## Trazabilidad de activos

| Submódulo | ID proporcionado | Dashboard en Quick | Análisis informado | Conjunto de datos observado | Estado técnico |
|---|---|---|---|---|---|
| Datos Sin Limpiar (SECAD) | `f41770e9-82ef-4101-b286-584b63bb0d96` | `pon-prod-ts-informe-datos-sin-modificacion-datalake` | `pon-prod-ts-informe-datos-sin-modificacion-datalake` | `llamada_autoupdate` (SPICE) | Análisis disponible. |
| Métricas de Uso de la Plataforma | `02989568-503e-46ed-8d01-2311bc5f6707` | `pon-prod-ts-metricas-uso-plataforma` | `eventos_IAPOL_metricas_uso analysis` | `eventos_IAPOL` (SPICE) | Análisis disponible. |
| Monitoreo Componentes | `a2f9a0d2-07b5-40b3-ab99-8a6254725378` | No encontrado | No informado | No identificado | Pendiente; el contenido solicita autenticación externa. |
| Tablero Monitoreo Pedidos SECAD v3.0 | `1ddbf100-16b1-45a3-a388-5f5fd3dec7bf` | `Tablero Monitoreo Pedidos SECAD v3.0` | `vw_pedidos_secad analysis` | `vw_pedidos_secad_v2` (SPICE) | Análisis disponible. |
| Última actualización de datos migrados | `8cae6307-9b57-4c94-beb3-ae8c7ee7e04f` | `migracion_tablas` | `utima_actualizacion_tablas analysis` | `utima_actualizacion_tablas` | El nombre informado no aparece en el catálogo de análisis accesible. |
| Tablero de control ingesta datos planta nacional | `3529d12a-f9f4-4fb9-b5bf-3d2b372abcb8` | `Tablero de control planta nacional` | `Monitoreo ingesta llamadas de emergencia` | `v_control_files`, `v_qs_refresh_monitor`, `v_monitoreo_final_clean` | Metadatos del dashboard publicados disponibles; análisis no localizado. |

## Orden lógico de evaluación

Para reproducir una cifra se debe considerar, en este orden conceptual, el conjunto de datos y sus transformaciones, los filtros del análisis, los filtros de hoja, los filtros del visual y las selecciones o filtros cruzados. Los controles pueden alimentar un filtro directamente o hacerlo mediante un parámetro; por ello, ver el valor del control no basta para reconstruir la consulta.

Una medida sin nivel explícito se evalúa en el contexto de filtros del visual. Las expresiones con `PRE_FILTER` o `PRE_AGG` cambian ese comportamiento y se documentan textualmente donde fueron verificadas.

## Documentos por submódulo

- [Datos Sin Limpiar (SECAD)](datos-sin-limpiar-secad/documentacion-tecnica.md)
- [Métricas de Uso de la Plataforma](metricas-de-uso-de-la-plataforma/documentacion-tecnica.md)
- [Monitoreo Componentes](monitoreo-componentes/documentacion-tecnica.md)
- [Tablero Monitoreo Pedidos SECAD v3.0](tablero-monitoreo-pedidos-secad-v3-0/documentacion-tecnica.md)
- [Última actualización de datos migrados](ultima-actualizacion-de-datos-migrados/documentacion-tecnica.md)
- [Control de ingesta de datos de planta nacional](tablero-de-control-ingesta-datos-planta-nacional/documentacion-tecnica.md)

## Procedimiento de conciliación

1. Registrar fecha y hora de refresco de SPICE, fecha de la partición de Athena y corte de la fuente Policía.
2. Reproducir filtros de hoja y visual, incluidos parámetros, inclusiones y exclusiones.
3. Identificar el grano de la medida: registros, usuarios distintos, siglas distintas, archivos o ejecuciones.
4. Consultar Athena usando el mismo campo de fecha y zona horaria del dashboard.
5. Comparar total general y agrupaciones que correspondan: fecha, departamento, municipio, sigla, origen o estado.
6. Separar diferencias atribuibles al desfase de carga de diferencias causadas por lógica o calidad.
7. Registrar fórmula, resultado, evidencia, responsable y ticket en `ejecucion-validaciones-2026-09-04.md`.

## Plantilla SQL orientativa

La siguiente estructura no debe ejecutarse sin reemplazar nombres y reglas por los confirmados en el análisis:

```sql
SELECT
    <dimension>,
    COUNT(*) AS cantidad_registros,
    COUNT(DISTINCT <llave_negocio>) AS cantidad_distinta,
    SUM(CASE WHEN <campo_obligatorio> IS NULL THEN 1 ELSE 0 END) AS nulos_obligatorios
FROM <catalogo>.<esquema>.<tabla>
WHERE <campo_fecha> >= TIMESTAMP '<inicio>'
  AND <campo_fecha> <  TIMESTAMP '<fin_exclusivo>'
  AND <filtros_negocio>
GROUP BY <dimension>;
```

## Aspectos todavía no demostrados

- Tablas físicas, consultas SQL y transformaciones anteriores a SPICE.
- Programación y fecha exacta del refresco de cada conjunto de datos.
- Listas completas resumidas en Quick como “y más”.
- Fórmulas de los campos o KPI que el análisis no permitió abrir.
- Reglas técnicas de Monitoreo Componentes y del análisis de datos migrados.

Estos puntos deben conservar el estado `Pendiente`; no deben completarse por semejanza con otro tablero.
