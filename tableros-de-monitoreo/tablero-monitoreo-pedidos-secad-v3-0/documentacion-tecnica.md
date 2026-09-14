# Documentación técnica — Tablero Monitoreo Pedidos SECAD v3.0

## Activos y fuente lógica

| Elemento | Valor verificado |
|---|---|
| Dashboard | `Tablero Monitoreo Pedidos SECAD v3.0` |
| Análisis | `vw_pedidos_secad analysis` |
| Conjunto de datos | `vw_pedidos_secad_v2` |
| Modo | SPICE |
| Hoja | `Sheet 1` |

El conjunto contiene datos operacionales SECAD y campos calculados, entre ellos `Calcular_hora` e `intervalo_fecha_hora`. La fuente física, la zona horaria y la unidad de `intervalo_fecha_hora` no estuvieron visibles.

## KPI de disponibilidad

### UP

| Propiedad | Configuración confirmada |
|---|---|
| Medida | `sigla` con agregación `Distinct count` |
| Filtro de visual | `intervalo_fecha_hora <= 24` |
| Filtro de hoja | `bd_origen` incluye `raw_secad_deama y más` |

Conceptualmente:

```text
UP = distinct_count(sigla)
     donde intervalo_fecha_hora <= 24
     y bd_origen pertenece a la lista configurada
```

### DOWN

| Propiedad | Configuración confirmada |
|---|---|
| Medida | `sigla` con agregación `Distinct count` |
| Filtro de visual | `intervalo_fecha_hora > 24` |
| Filtro de visual adicional | `hora_asigna` durante el año actual |
| Filtro de hoja | `bd_origen` incluye `raw_secad_deama y más` |

Conceptualmente:

```text
DOWN = distinct_count(sigla)
       donde intervalo_fecha_hora > 24
       y hora_asigna pertenece al año actual
       y bd_origen pertenece a la lista configurada
```

## Hallazgos de lógica

- Los KPI cuentan siglas distintas, no pedidos ni filas.
- El valor 24 pertenece a `UP` por el operador `<=`; `DOWN` comienza estrictamente después de 24.
- Sólo `DOWN` mostró el filtro `hora_asigna = año actual`. Esta asimetría puede hacer que `UP + DOWN` no represente el universo de siglas del mismo periodo.
- La unidad del umbral 24 parece temporal por el nombre del campo, pero debe confirmarse; no se documenta como “horas” hasta ver la fórmula o el tipo semántico.
- La lista de `bd_origen` está resumida como `raw_secad_deama y más`; se necesita la lista completa para reproducir los KPI.
- Los valores nulos de `intervalo_fecha_hora` no satisfacen ninguna de las dos comparaciones y pueden quedar fuera de ambos KPI.

## Tabla Reporte Pedidos Secad

Campos verificados en el visual:

| Campo | Uso |
|---|---|
| `sigla` | Unidad o sigla reportada. |
| `Calcular_hora` | Campo calculado oculto, posiblemente auxiliar de orden o presentación; fórmula pendiente. |
| `hora_asigna` | Fecha/hora mostrada con granularidad de minuto. |
| `patrulla` | Recurso asignado. |
| `unidad` | Unidad operacional. |
| `latitud`, `longitud` | Posición asociada. |
| `comentario` | Detalle narrativo sensible. |

La tabla no debe exportarse completa ni copiarse a este repositorio. La documentación de evidencia debe usar filas sintéticas o valores anonimizados.

## Campos de interés del conjunto

Además de los campos del visual se observaron `nume_llamada`, `nume_telefono`, `bd_origen`, `fecha_caso`, `hora_caso`, `hora_llegada`, `hora_termina`, `prioridad`, `row_num`, `segs_llegada`, `segs_atenc`, `tiempo_llegada`, `tiempo_atenc`, `cod_inicial`, `cod_final` y sus descripciones.

## Pruebas técnicas mínimas

1. Crear casos controlados para valores 23,99; 24; 24,01; nulo y negativo de `intervalo_fecha_hora`, respetando el tipo real del campo.
2. Reproducir `COUNT(DISTINCT sigla)` y no `COUNT(*)`.
3. Ejecutar una comparación con y sin el filtro de año actual para cuantificar la asimetría.
4. Obtener y versionar la lista completa de orígenes incluidos.
5. Verificar si una sigla puede aparecer simultáneamente en UP y DOWN por tener múltiples filas; al ser KPI independientes, es posible que ocurra.
6. Validar zona horaria y granularidad de `hora_asigna`.
7. Confirmar que el campo oculto `Calcular_hora` no cambia el filtro ni la clasificación.

## Asuntos pendientes

- Fórmulas de `Calcular_hora` e `intervalo_fecha_hora`.
- Unidad del umbral 24 y definición funcional de disponibilidad.
- Lista completa de `bd_origen`.
- Fuente física de Athena, reglas de deduplicación y refresco de SPICE.
- Justificación o corrección de la diferencia temporal entre UP y DOWN.

## Consultas Athena orientativas

Estas consultas siguen la [plantilla SQL orientativa del módulo](../documentacion-tecnica.md#plantilla-sql-orientativa) y reproducen la lógica confirmada de los KPI `UP` y `DOWN`: cuentan **siglas distintas** (`COUNT(DISTINCT sigla)`), no filas ni pedidos, y usan el umbral `intervalo_fecha_hora`. No deben ejecutarse sin reemplazar los marcadores `<...>` por valores confirmados: catálogo y esquema físico, unidad real del umbral 24, lista completa de `bd_origen` (la interfaz la resume como `raw_secad_deama y más`) y zona horaria de `hora_asigna`.

### KPI UP — disponibilidad

```sql
-- UP = distinct_count(sigla) donde intervalo_fecha_hora <= 24
--      y bd_origen pertenece a la lista configurada.
SELECT COUNT(DISTINCT sigla) AS up_siglas
FROM <catalogo>.<esquema>.vw_pedidos_secad_v2
WHERE intervalo_fecha_hora <= 24
  AND bd_origen IN (<lista_completa_bd_origen>);
```

### KPI DOWN — indisponibilidad

```sql
-- DOWN = distinct_count(sigla) donde intervalo_fecha_hora > 24,
--        hora_asigna dentro del año actual (filtro presente solo en DOWN)
--        y bd_origen pertenece a la lista configurada.
SELECT COUNT(DISTINCT sigla) AS down_siglas
FROM <catalogo>.<esquema>.vw_pedidos_secad_v2
WHERE intervalo_fecha_hora > 24
  AND YEAR(hora_asigna) = YEAR(CURRENT_DATE)
  AND bd_origen IN (<lista_completa_bd_origen>);
```

### Prueba de la asimetría UP/DOWN

```sql
-- Cuantifica el efecto del filtro de año actual, presente solo en DOWN.
SELECT
    COUNT(DISTINCT CASE WHEN intervalo_fecha_hora > 24 THEN sigla END)                                      AS down_sin_filtro_anio,
    COUNT(DISTINCT CASE WHEN intervalo_fecha_hora > 24 AND YEAR(hora_asigna) = YEAR(CURRENT_DATE)
                        THEN sigla END)                                                                     AS down_con_filtro_anio,
    COUNT(DISTINCT CASE WHEN intervalo_fecha_hora IS NULL THEN sigla END)                                   AS siglas_intervalo_nulo
FROM <catalogo>.<esquema>.vw_pedidos_secad_v2
WHERE bd_origen IN (<lista_completa_bd_origen>);
```

> Notas de lógica confirmadas en este tablero:
> - El valor 24 pertenece a `UP` por el operador `<=`; `DOWN` empieza estrictamente después de 24.
> - Los nulos de `intervalo_fecha_hora` no satisfacen ninguna comparación y pueden quedar fuera de ambos KPI.
> - Una misma sigla puede aparecer en `UP` y `DOWN` por tener varias filas; son KPI independientes.
>
> Pendiente antes de ejecutar: catálogo/esquema y fuente física; unidad del umbral 24 (parece temporal pero no está confirmado como horas); lista completa de `bd_origen`; y zona horaria/granularidad de `hora_asigna`. No copiar la tabla `Reporte Pedidos Secad` ni campos como `comentario`, `nume_telefono`, `latitud`/`longitud`.

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)