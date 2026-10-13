# Eventos de usuarios en IAPOL

## Propósito

Resume el volumen de eventos de la plataforma por sigla, usuario, tipo y ventanas temporales relativas al momento de consulta.

La hoja contiene siete visuales y todos consumen `eventos_IAPOL`.

## Visuales definidos

Las referencias H2-V01 a H2-V07 siguen el orden de la definición JSON y no representan la posición física en pantalla.

| Referencia | Tipo | Medida o título | Configuración |
|---|---|---|---|
| H2-V01 | Barras | Eventos del año por sigla | `SUM(eventos_usuarios_año)` por `sigla_laborando`; Top 10 de siglas. |
| H2-V02 | Barras | Eventos del año por usuario | `SUM(eventos_usuarios_año)` por `username`; Top 10 por suma de `Interacciones totales`. |
| H2-V03 | KPI | Eventos del último mes | `SUM(eventos_ultimo_mes)`. |
| H2-V04 | KPI | Eventos de los últimos seis meses | `SUM(eventos_ultimos_6_meses)`. |
| H2-V05 | KPI | Eventos del año | `SUM(eventos_usuarios_año)`. |
| H2-V06 | KPI | Eventos del día actual | `SUM(eventos_usuarios_hoy)`. |
| H2-V07 | Tabla | Tipo de evento e interacciones | `SUM(Interacciones totales)` por `name_item`. |

Los títulos de H2-V01 a H2-V06 están ocultos en la definición. Los nombres anteriores describen los campos y ventanas configuradas; deben compararse con las etiquetas visibles en pantalla.

## Controles visibles

| Control | Dataset | Campo | Efecto esperado |
|---|---|---|---|
| Sigla | `eventos_IAPOL` | `sigla_laborando` | Filtra los visuales de la hoja. |
| Estado | `eventos_IAPOL` | `estado_user` | Filtra los visuales de la hoja. |
| fecha_evento_eve | `User_Roles` | `fecha_evento_eve` | No tiene un consumidor evidente en esta hoja, cuyos visuales usan `eventos_IAPOL`. |

No hay acciones de filtrado por clic configuradas en los siete visuales.

## Campos calculados utilizados

```text
eventos_ultimo_mes =
countOver(
  ifelse(dateDiff(fecha_evento, now(), "DD") <= 30, name_item, NULL),
  [username],
  PRE_FILTER
)
```

```text
eventos_ultimos_6_meses =
countOver(
  ifelse(dateDiff(fecha_evento, now(), "MM") <= 6, name_item, NULL),
  [username],
  PRE_FILTER
)
```

```text
eventos_usuarios_año =
countOver(
  ifelse(truncDate("YYYY", fecha_evento) = truncDate("YYYY", now()), name_item, NULL),
  [username],
  PRE_FILTER
)
```

```text
eventos_usuarios_hoy =
countOver(
  ifelse(truncDate("DD", fecha_evento) = truncDate("DD", now()), name_item, NULL),
  [username],
  PRE_FILTER
)
```

```text
Interacciones totales =
countOver(name_item, [username], PRE_FILTER)
```

`PRE_FILTER` calcula el valor por usuario antes de los filtros del análisis. Cada fila del usuario puede recibir el mismo conteo. Como los siete visuales usan `SUM`, la suma puede repetir ese valor y no debe interpretarse automáticamente como conteo de eventos.

## Filtros específicos

- H2-V01 aplica Top 10 de `sigla_laborando` y un filtro de dependencia inicialmente en todos los valores.
- H2-V02 aplica Top 10 de `username`, ordenado por la suma de `Interacciones totales`, y un filtro de dependencia inicialmente en todos los valores.
- Los filtros por `Fechainicio` y `Fechafin` de H2-V01 y H2-V02 están deshabilitados.
- El Top 10 adicional de usuario configurado para H2-V01 está deshabilitado.

Los parámetros de fecha no limitan actualmente los siete visuales. Las ventanas temporales de los KPI provienen de sus fórmulas relativas a `now()`.

## Hallazgos a validar

- El control `fecha_evento_eve` pertenece a `User_Roles`, pero esta hoja no usa ese dataset; probablemente no afecta sus visuales.
- Sumar un `countOver` repetido por cada fila puede sobredimensionar todos los KPI y rankings de la hoja.
- Los filtros visibles no cambian el valor calculado en la fase `PRE_FILTER` de la misma manera que un conteo estándar; pueden reducir filas sumadas sin recalcular el conteo base.
- El Top 10 de H2-V01 ordena `sigla_laborando` por conteo de la propia dimensión, no por la suma de eventos mostrada. El ranking debe confirmarse funcionalmente.
- El Top 10 de H2-V02 utiliza `Interacciones totales` para ordenar, mientras las barras muestran `eventos_usuarios_año`; ranking y medida visible no son equivalentes.

## Validaciones pendientes

- [ ] Comparar cada KPI con `COUNT(*)`, `COUNT(name_item)` y conteos por usuario en Athena.
- [ ] Medir el factor de repetición causado por `SUM(countOver(...))`.
- [ ] Validar las ventanas en los límites de día, 30 días, mes, seis meses y año.
- [ ] Confirmar criterios de orden y población de los dos Top 10.
- [ ] Probar el alcance de Sigla, Estado y fecha sobre todos los visuales.
- [ ] Revisar duplicados de eventos y el grano de `event_table`.

[Volver a Métricas de Uso de la Plataforma](../README.md)
