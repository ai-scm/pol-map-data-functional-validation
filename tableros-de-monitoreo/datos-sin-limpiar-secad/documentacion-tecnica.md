# Documentación técnica — Datos Sin Limpiar (SECAD)

## Activos y fuente lógica

| Elemento | Valor verificado |
|---|---|
| Dashboard y análisis | `pon-prod-ts-informe-datos-sin-modificacion-datalake` |
| Conjunto de datos | `llamada_autoupdate` |
| Modo | SPICE |
| Hojas publicadas | Historia, Últimos Días, Prioridad, Mapa, Patrullas, Llamante y METUN - OPERACIÓN XCRIME |

La tabla física de Athena y la consulta que alimenta SPICE no fueron visibles. Aunque el nombre funcional indica datos “sin modificación”, el conjunto ya expone campos derivados o tipados como año, mes, semana, día, día de semana, hora, segundos y minutos; por ello se debe confirmar qué transformaciones ocurren antes de la visualización.

## Grano y campos principales

El grano aparente es un pedido o llamada SECAD. Debe demostrarse con la llave funcional autorizada; `nume_llamada` no debe asumirse único sin revisar duplicados, reingresos y cambios de estado.

| Grupo | Campos observados |
|---|---|
| Identificación y origen | `nume_llamada`, `bd_origen`, `entidad`, `sigla`, `unidad` |
| Clasificación | `cod_inicial`, `cod_inicial_desc`, `cod_final`, `cod_final_desc`, `prioridad`, `importancia`, `calidad_pedido`, `canal_atencion` |
| Tiempo | `fecha_caso`, `anio`, `mes`, `semana`, `dia`, `dia_semana`, `hora`, `hora_caso`, `hora_asigna`, `hora_llegada`, `hora_termina` |
| Duraciones | `segs_llegada`, `segs_atenc`, `minutos_llegada`, `minutos_atencion`, `tiempo_llegada`, `tiempo_atenc` |
| Operación | `patrulla`, `evento_generado`, `enviar`, `sitio`, `cod_sitio` |
| Geografía | `dpto`, `barrio`, `direccion`, `latitud`, `longitud` |
| Sensibles | `nume_telefono`, `comentario`, ubicación y narrativa operacional |

## Parámetros y filtros

| Hoja | Alcance | Regla observada | Estado |
|---|---|---|---|
| Historia | Hoja | No se observaron controles o filtros propios. | Observado |
| Últimos Días | Hoja | `fecha_caso` se limita a los últimos `dias`; parámetro `dias` con valor visible inicial 30. | Confirmado |
| Últimos Días | Hoja | `sigla` contiene el parámetro `Sigla`; control visible inicialmente en `Todo`. | Confirmado |
| Prioridad | Hoja | `fecha_caso` se limita a los últimos `dias`; valor visible inicial 30. | Confirmado |
| Prioridad | Hoja | `sigla` aplica exclusiones resumidas en la interfaz como `CP3 y más`. | Confirmado parcialmente; falta lista completa |
| Mapa | Hoja | `fecha_caso` se limita a los últimos `dias`; valor visible inicial 30. | Confirmado |
| Patrullas | Hoja | No se observaron controles; falta confirmar filtros internos de los visuales. | Observado |
| Llamante | Hoja | No se observaron controles; falta confirmar filtros internos de los visuales. | Observado |
| METUN - OPERACIÓN XCRIME | Hoja | `fecha_caso` posterior al 2021-01-28. | Confirmado |
| METUN - OPERACIÓN XCRIME | Hoja | `sigla` incluida: `METUN`. | Confirmado |
| METUN - OPERACIÓN XCRIME | Hoja | `patrulla` comienza por `D1E1_CUAD`. | Confirmado |

“Últimos 30 días” es una ventana móvil relativa al momento de ejecución, no un mes calendario. La conciliación debe materializar el inicio y fin exactos y usar la misma zona horaria en Athena.

## Lógica por hoja

### Historia

- `Cuenta Total`: conteo de `cod_final` observado en el visual. Los nulos en `cod_final` no se contabilizan; comparar también `COUNT(*)` para detectar la diferencia.
- `Número bases`: conteo distinto de `bd_origen` observado.
- `Maximum`: máximo del volumen agrupado en el eje temporal; la expresión completa debe confirmarse antes de considerarla una medida oficial.
- Los gráficos temporales usan las dimensiones derivadas de `fecha_caso` (`anio`, `mes`, `dia`, `dia_semana`, `semana` y `hora`).

### Últimos Días

Los KPI y gráficos heredan la ventana `dias` y la condición de `sigla`. Para reproducirlos se debe aplicar primero el intervalo sobre `fecha_caso` y después la misma semántica de “contiene” usada por Quick, que no necesariamente equivale a igualdad exacta.

### Prioridad

El total corresponde al conteo de registros y la distribución agrupa por `prioridad`. La conciliación debe incluir explícitamente la lista completa de siglas excluidas; el texto `CP3 y más` es sólo un resumen de interfaz.

### Mapa

Los puntos utilizan `latitud` y `longitud`; `bd_origen` participa como agrupación o color y el detalle muestra campos del registro seleccionado. Antes de comparar cantidades se debe separar:

- registros con ambas coordenadas válidas;
- registros con coordenadas nulas;
- coordenadas iguales a cero;
- coordenadas fuera de Colombia o con latitud/longitud intercambiadas;
- múltiples registros superpuestos en el mismo punto.

### Patrullas

El análisis muestra un Top 30 de llamadas por `patrulla` y `sigla`, una distribución por `sigla` y un visual geográfico. “Top 30” implica orden y truncamiento: el total de las barras no debe compararse con el total general como si incluyera todas las patrullas.

### Llamante

Agrupa por `nume_telefono` y por `bd_origen`. El conteo debe evaluarse como conteo de eventos asociados al teléfono, no como personas distintas. Cualquier evidencia debe enmascarar el número y no almacenar exportaciones de producción.

### METUN - OPERACIÓN XCRIME

Se observan promedios de `minutos_llegada` y `minutos_atencion`, clasificaciones por `patrulla`, conteo de latitud igual a cero y detalle operacional. Se debe validar tratamiento de nulos, negativos, valores extremos y casos sin hora de llegada o terminación.

## Reglas de conciliación recomendadas

1. Comparar `COUNT(*)`, `COUNT(cod_final)` y `COUNT(DISTINCT nume_llamada)`; documentar cuál usa cada visual.
2. Recalcular derivados temporales desde `fecha_caso` con la zona horaria de negocio.
3. Verificar si `minutos_llegada` y `minutos_atencion` vienen de la fuente o son conversiones de segundos.
4. Conciliar por `bd_origen`, `sigla`, fecha y código final.
5. Revisar duplicados por llave funcional y no sólo por igualdad de toda la fila.
6. Confirmar si filtros de selección entre visuales permanecen activos al cambiar de hoja.

## Asuntos pendientes

- Tabla y consulta física de Athena, programación de SPICE y fecha/hora de corte.
- Fórmula exacta de `Maximum` y configuración completa de cada campo del visual.
- Lista de exclusiones de sigla en Prioridad.
- Filtros internos de Patrullas y Llamante.
- Regla oficial para duplicados y tratamiento de coordenadas.

## Consultas Athena orientativas

Estas consultas siguen la [plantilla SQL orientativa del módulo](../documentacion-tecnica.md#plantilla-sql-orientativa). Usan únicamente campos observados en el análisis y dejan como marcadores `<...>` lo que sigue `Pendiente`: catálogo y esquema físico, tabla real que alimenta SPICE, zona horaria, extremos exactos de la ventana móvil y la lista completa de siglas excluidas. No deben ejecutarse sin reemplazar esos marcadores por valores confirmados.

Recordatorios de conciliación específicos de este tablero:

- La ventana "Últimos N días" es móvil respecto al instante de ejecución; materializar `<inicio>` y `<fin_exclusivo>` como marcas concretas antes de comparar.
- Comparar `COUNT(*)`, `COUNT(cod_final)` y `COUNT(DISTINCT nume_llamada)` porque los visuales no usan el mismo grano.
- No copiar `nume_telefono`, `comentario`, coordenadas ni narrativa a la evidencia.

### Hoja Historia — conteos base y número de bases

```sql
-- Cuenta Total (cod_final no nulo) vs COUNT(*) y llave funcional
SELECT
    COUNT(*)                        AS registros,
    COUNT(cod_final)                AS cuenta_cod_final,   -- excluye nulos
    COUNT(DISTINCT nume_llamada)    AS llamadas_distintas,
    COUNT(DISTINCT bd_origen)       AS numero_bases
FROM <catalogo>.<esquema>.<tabla_llamada_autoupdate>;
```

### Hoja Últimos Días — ventana móvil y filtro de sigla

```sql
-- Reproduce el parámetro `dias` (valor visible inicial 30) y el control `Sigla`.
-- Sustituir la comparación de sigla por la misma semántica "contiene" del dashboard.
SELECT
    COUNT(*)                        AS registros,
    COUNT(DISTINCT nume_llamada)    AS llamadas_distintas
FROM <catalogo>.<esquema>.<tabla_llamada_autoupdate>
WHERE fecha_caso >= TIMESTAMP '<inicio_ultimos_dias>'
  AND fecha_caso <  TIMESTAMP '<fin_exclusivo>'
  AND (<todas_las_siglas> OR sigla = '<sigla_seleccionada>');
```

### Hoja Prioridad — distribución con exclusión de siglas

```sql
-- La interfaz resume las exclusiones como `CP3 y más`; requiere la lista completa confirmada.
SELECT
    prioridad,
    COUNT(*) AS registros
FROM <catalogo>.<esquema>.<tabla_llamada_autoupdate>
WHERE fecha_caso >= TIMESTAMP '<inicio_ultimos_dias>'
  AND fecha_caso <  TIMESTAMP '<fin_exclusivo>'
  AND sigla NOT IN (<lista_completa_siglas_excluidas>)
GROUP BY prioridad
ORDER BY registros DESC;
```

### Hoja Mapa — calidad de coordenadas

```sql
-- Separar los grupos de coordenadas antes de comparar cantidades.
SELECT
    SUM(CASE WHEN latitud IS NOT NULL AND longitud IS NOT NULL THEN 1 ELSE 0 END) AS con_coordenadas,
    SUM(CASE WHEN latitud IS NULL OR  longitud IS NULL         THEN 1 ELSE 0 END) AS sin_coordenadas,
    SUM(CASE WHEN latitud = 0 OR longitud = 0                  THEN 1 ELSE 0 END) AS coordenadas_en_cero
FROM <catalogo>.<esquema>.<tabla_llamada_autoupdate>
WHERE fecha_caso >= TIMESTAMP '<inicio_ultimos_dias>'
  AND fecha_caso <  TIMESTAMP '<fin_exclusivo>';
```

### Hoja METUN - OPERACIÓN XCRIME — filtros confirmados

```sql
-- Filtros confirmados: fecha_caso posterior al 2021-01-28, sigla = METUN, patrulla que inicia por D1E1_CUAD.
SELECT
    COUNT(*)                     AS registros,
    AVG(minutos_llegada)         AS promedio_minutos_llegada,
    AVG(minutos_atencion)        AS promedio_minutos_atencion,
    SUM(CASE WHEN latitud = 0 THEN 1 ELSE 0 END) AS latitud_en_cero
FROM <catalogo>.<esquema>.<tabla_llamada_autoupdate>
WHERE fecha_caso > TIMESTAMP '2021-01-28 00:00:00'
  AND sigla = 'METUN'
  AND patrulla LIKE 'D1E1_CUAD%';
```

> Pendiente antes de ejecutar: catálogo, esquema y tabla física de Athena; zona horaria de negocio; extremos exactos de la ventana móvil; lista completa de siglas excluidas en Prioridad; y confirmar si `minutos_llegada`/`minutos_atencion` provienen de la fuente o se derivan de segundos.

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)