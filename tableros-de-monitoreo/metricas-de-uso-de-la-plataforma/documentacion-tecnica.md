# Documentación técnica — Métricas de Uso de la Plataforma

## Activos y publicación

| Elemento | Valor verificado |
|---|---|
| Dashboard | `pon-prod-ts-metricas-uso-plataforma` |
| Análisis | `eventos_IAPOL_metricas_uso analysis` |
| Conjunto de datos | `eventos_IAPOL` |
| Modo | SPICE |
| Hojas publicadas | Información de usuarios; Uso mapa anticipacion |

El análisis contiene además `Información de usuarios (Anterior)`, `Estadísticas de uso` y `Sheet 10`, marcadas como no publicadas. Sus objetos no forman parte del contrato funcional del dashboard actual, pero se incluyen en este inventario para cubrir todas las hojas del análisis.

## Modelo lógico

El conjunto combina información de usuario y eventos de interacción. El identificador técnico usado en las medidas es `username`; la documentación y las evidencias no deben registrar su valor, nombres, apellidos, correo, dirección ni otros atributos personales.

Campos relevantes observados: `username`, `usuarios_policia`, `estado_empleado`, `estado_user`, `sigla`, `sigla_laborando`, `descripcion_dependencia`, `fecha_evento`, `event_time`, `name_item`, `dias_sin_interaccion` y los campos calculados descritos más adelante.

## Filtros compartidos

| Campo o condición | Alcance | Regla | Estado |
|---|---|---|---|
| `usuarios_policia` | Entre hojas | Igual a `1`. | Confirmado |
| `estado_empleado` | Entre hojas | Incluye `AC`. | Confirmado |
| `sigla_laborando = sigla` | Entre hojas | Condición observada en el panel de filtros. | Confirmado en configuración; validar la semántica de comparación entre campos |

Estos filtros definen la población base. Un total calculado directamente sobre `eventos_IAPOL` sin aplicarlos no es comparable con el dashboard.

## Hoja Información de usuarios

### Controles y alcance

| Control | Valor visible inicial | Aplicación observada |
|---|---|---|
| Periodo gráfico actividad | Últimos 7 meses | Controla el periodo del gráfico de actividad; confirmar si afecta otros visuales. |
| Sigla | Todo | Filtro de hoja sobre `sigla_laborando`. |
| Dependencia | Todo | Filtro de hoja sobre `descripcion_dependencia`. |
| Estado | Todo | Filtro de hoja sobre `estado_user`. |

Los tres filtros organizacionales se evalúan junto con la población base. La ventana “Últimos 7 meses” es móvil y debe convertirse en fechas concretas en cada ejecución.

### Campos calculados confirmados

#### Estado actividad

```text
ifelse(
 {estado_user} = 'Sin ingreso', 'Nunca ingresó',
 {dias_sin_interaccion} <= 10, '0–10 días',
 {dias_sin_interaccion} <= 30, '11–30 días',
 {dias_sin_interaccion} <= 60, '31–60 días',
 'Más de 60 días'
)
```

La evaluación es secuencial. Un usuario `Sin ingreso` siempre se clasifica como `Nunca ingresó`, aun si el campo de días contiene un valor. Los umbrales 10, 30 y 60 son inclusivos.

#### Etapa embudo

```text
ifelse(
 dateDiff({fecha_evento}, now(), "DD") <= 10, '3. Activos',
 {estado_user} = 'Sin ingreso', '1. Registrados',
 '2. Ingresaron'
)
```

La condición de activo tiene prioridad. Debe revisarse qué ocurre con fechas futuras y nulas; una fecha futura puede producir una diferencia negativa y satisfacer `<= 10`.

#### Primera fecha de ingreso

```text
minOver({fecha_evento}, [username], PRE_AGG)
```

Calcula la fecha mínima por usuario antes de la agregación del visual, dentro del contexto anterior aplicable.

#### Ingreso antes del mes actual

```text
ifelse(
 isNull({Primera fecha de ingreso}), 0,
 {Primera fecha de ingreso} < truncDate('MM', now()), 1,
 0
)
```

Usa el inicio del mes calendario actual como límite exclusivo.

#### Interacciones totales

```text
countOver({name_item}, [username], PRE_FILTER)
```

Al usar `PRE_FILTER`, el conteo por usuario se calcula antes de los filtros del análisis. No debe esperarse que todos los controles reduzcan este valor de la misma manera que una medida estándar.

### KPI confirmados

| KPI o campo | Expresión |
|---|---|
| Total usuarios | `distinct_count(username)` |
| Han ingresado | `distinct_countIf(username, {estado_user} = 'Con ingreso')` |
| Nunca ingresaron | `distinct_countIf(username, {estado_user} = 'Sin ingreso')` |
| Usuarios ingreso 10 días | `distinctCountIf(username, dateDiff({fecha_evento}, now(), "DD") <= 10)` |
| Porcentaje activos 10 días | `{Usuarios_ingreso_10_dias} / distinct_count(username)` |
| Porcentaje han ingresado | `distinct_countIf(username,{estado_user}='Con ingreso') / distinct_count(username)` |
| Porcentaje nunca ingresaron | `distinct_countIf(username,{estado_user}='Sin ingreso') / distinct_count(username)` |

El denominador es el total distinto de usuarios en el contexto de filtros, salvo que Quick aplique una configuración adicional del visual. Un usuario con varios eventos se cuenta una sola vez en estas medidas.

### Comparaciones con el periodo anterior

```text
Porcentaje activos 10 días mes anterior =
distinct_countIf(
 username,
 {fecha_evento} >= addDateTime(-10, 'DD', truncDate('MM', now()))
 AND {fecha_evento} < truncDate('MM', now())
) / distinct_count(username)
```

La etiqueta “mes anterior” no usa todo el mes anterior: usa los diez días inmediatamente anteriores al inicio del mes actual.

```text
Porcentaje ingresaron mes anterior =
distinct_countIf(username,{Ingreso antes del mes actual}=1)
/ distinct_count(username)
```

```text
Porcentaje nunca ingresaron mes anterior =
1 - {Porcentaje ingresaron mes anterior}
```

Las variaciones están definidas como resta simple:

```text
Variación activos 10 días vs mes anterior =
{Porcentaje Activos 10 días} - {Porcentaje activos 10 días mes anterior}

Variación ingreso vs mes anterior =
{Porcentaje Han ingresado} - {Porcentaje ingresaron mes anterior}

Variación nunca ingresaron vs mes anterior =
{Porcentaje Nunca ingresaron} - {Porcentaje nunca ingresaron mes anterior}
```

Estas medidas expresan diferencia absoluta de proporciones, es decir, puntos porcentuales cuando se formatean como porcentaje; no son una tasa de crecimiento relativa.

### Totales del embudo

```text
Total embudo activos =
distinctCountOver(
 ifelse(dateDiff({fecha_evento}, now(), "DD") <= 10, username, NULL),
 [], PRE_AGG
)
```

```text
Total embudo ingresaron =
distinctCountOver(
 ifelse({estado_user}='Con ingreso', username, NULL),
 [], PRE_AGG
)
```

```text
Total embudo registrados =
distinctCountOver(username, [], PRE_AGG)
```

La fórmula del campo `Valor embudo` no pudo extraerse y queda pendiente. No debe reconstruirse sólo a partir del nombre de las etapas.

## Hoja Uso mapa anticipacion

### Filtros confirmados

| Campo | Regla |
|---|---|
| `fecha_evento` | Entre los parámetros `Fechainicio` y `Fechafin`. |
| `name_item` | Incluye `Mapa de Anticipación a Fenómenos de Seguridad`. |
| `estado_empleado` | Control visible en `AC`; además existe el filtro compartido. |
| `sigla` | Control `SIGLA`, valor visible inicial `Todo`. |

La hoja mide únicamente interacciones cuyo elemento coincide con el nombre indicado. Variaciones de mayúsculas, tildes o renombramientos del evento pueden quedar fuera si la condición es una igualdad o inclusión exacta.

Se observó un visual de detalle con `fecha_evento` máxima por atributos de usuario, oculto mediante una regla. Su existencia no autoriza exponer los datos personales subyacentes.

## Hojas internas no publicadas

### Información de usuarios (Anterior)

Versión anterior con KPI de total, ingreso, falta de ingreso y actividad en diez días; tabla de seguimiento; usuarios activos por sigla; y un Top 10 por acciones. Hereda los filtros de población y añade controles de sigla, estado de empleado y dependencia. El detalle completo está en [`informacion-de-usuarios-anterior/README.md`](informacion-de-usuarios-anterior/README.md).

Esta hoja presenta dos riesgos de mantenimiento: puede conservar lógica obsoleta frente a la versión vigente y el Top 10 aparece configurado como recuento de un campo ya calculado. No debe utilizarse como fuente oficial mientras permanezca no publicada.

### Estadísticas de uso

Contiene:

- recuento de `username` por `fecha_evento`, filtrado entre `Fechainicio` y `Fechafin` y excluyendo siglas homologadas nulas;
- suma de `Interacciones Totales` por `parent_corregido_para_null_manual`, con `category = Dashboard`, padre no nulo y filtro de fechas;
- conteo distinto de `username` por padre, también con padre no nulo y filtro de fechas.

La suma de `Interacciones Totales` requiere revisión porque ese campo usa `PRE_FILTER` y puede repetirse en varias filas. Véase [`estadisticas-de-uso/README.md`](estadisticas-de-uso/README.md).

### Sheet 10

Contiene una sola serie de conteo distinto de `username` por `fecha_evento`, filtrada por el elemento `Mapa de Anticipación a Fenómenos de Seguridad` y por el periodo fijo 2026-01-01 a 2026-06-10. No tiene controles observados y su periodo quedará obsoleto. Véase [`sheet-10/README.md`](sheet-10/README.md).

## Pruebas técnicas mínimas

1. Evaluar los límites exactos de 10, 30 y 60 días, además de nulos y fechas futuras.
2. Confirmar que `Total usuarios = Han ingresado + Nunca ingresaron` para el mismo corte, o documentar estados adicionales.
3. Comparar usuarios distintos, no cantidad de eventos, para los KPI de adopción.
4. Comparar eventos para las métricas de interacción y revisar duplicados por identificador de evento.
5. Congelar la fecha de evaluación de `now()` en la conciliación; ejecutar en días distintos cambia el resultado.
6. Probar extremos inclusivos de `Fechainicio` y `Fechafin`.
7. Verificar que cuentas técnicas, usuarios no Policía y empleados distintos de `AC` queden fuera.
8. Confirmar que las tres hojas internas continúen no publicadas hasta resolver sus diferencias de agregación y periodos fijos.

## Asuntos pendientes

- Tabla física de Athena, consulta de preparación, programación de SPICE y zona horaria.
- Fórmula de `Valor embudo`.
- Alcance exacto del control `Periodo gráfico actividad`.
- Semántica completa de la condición `sigla_laborando = sigla`.
- Tratamiento de fechas futuras y nulas en las expresiones con `dateDiff`.

## Consultas Athena orientativas

Estas consultas siguen la [plantilla SQL orientativa del módulo](../documentacion-tecnica.md#plantilla-sql-orientativa) y traducen a SQL las expresiones confirmadas del análisis. El identificador `username` es sensible: no registrar su valor ni otros atributos personales en la evidencia. Antes de ejecutar, materializar `now()` a un instante fijo del corte y sustituir los marcadores `<...>`: catálogo/esquema físico, tabla real que alimenta SPICE y zona horaria.

Toda comparación con el dashboard debe aplicar primero la **población base** (filtros compartidos), de lo contrario los totales no son comparables.

### Población base (filtros compartidos)

```sql
-- Condición reutilizable en todas las medidas de la hoja Información de usuarios.
-- usuarios_policia = 1 AND estado_empleado incluye 'AC' AND sigla_laborando = sigla
WHERE usuarios_policia = 1
  AND estado_empleado = 'AC'
  AND sigla_laborando = sigla
```

### KPI de adopción (hoja Información de usuarios)

```sql
-- Total usuarios, han ingresado y nunca ingresaron: cuentan usuarios DISTINTOS, no eventos.
SELECT
    COUNT(DISTINCT username)                                                        AS total_usuarios,
    COUNT(DISTINCT CASE WHEN estado_user = 'Con ingreso' THEN username END)         AS han_ingresado,
    COUNT(DISTINCT CASE WHEN estado_user = 'Sin ingreso' THEN username END)         AS nunca_ingresaron
FROM <catalogo>.<esquema>.<tabla_eventos_iapol>
WHERE usuarios_policia = 1
  AND estado_empleado = 'AC'
  AND sigla_laborando = sigla;
```

### Usuarios activos en 10 días

```sql
-- distinctCountIf(username, dateDiff(fecha_evento, now(), "DD") <= 10)
-- Reemplazar TIMESTAMP '<now_corte>' por el instante fijo de la conciliación.
SELECT
    COUNT(DISTINCT CASE
        WHEN date_diff('day', fecha_evento, TIMESTAMP '<now_corte>') <= 10
        THEN username END)                                                          AS usuarios_activos_10d,
    COUNT(DISTINCT username)                                                        AS total_usuarios
FROM <catalogo>.<esquema>.<tabla_eventos_iapol>
WHERE usuarios_policia = 1
  AND estado_empleado = 'AC'
  AND sigla_laborando = sigla;
-- Porcentaje activos 10 días = usuarios_activos_10d / total_usuarios
-- Revisar fechas futuras/nulas: una diferencia negativa también satisface <= 10.
```

### Hoja Uso mapa anticipacion — interacciones con el elemento

```sql
-- Filtros confirmados: fecha_evento entre parámetros, name_item incluye el mapa,
-- estado_empleado 'AC' y población base compartida.
SELECT COUNT(DISTINCT username) AS usuarios_con_interaccion
FROM <catalogo>.<esquema>.<tabla_eventos_iapol>
WHERE fecha_evento >= TIMESTAMP '<Fechainicio>'
  AND fecha_evento <= TIMESTAMP '<Fechafin>'
  AND name_item = 'Mapa de Anticipación a Fenómenos de Seguridad'
  AND usuarios_policia = 1
  AND estado_empleado = 'AC'
  AND sigla_laborando = sigla;
```

> Pendiente antes de ejecutar: catálogo/esquema, tabla física y zona horaria; congelar `now()` en la conciliación; confirmar la semántica de `sigla_laborando = sigla` y el tratamiento de fechas futuras/nulas en las expresiones con `dateDiff`. Las hojas internas (`Información de usuarios (Anterior)`, `Estadísticas de uso`, `Sheet 10`) permanecen no publicadas y no deben usarse como fuente oficial.

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)