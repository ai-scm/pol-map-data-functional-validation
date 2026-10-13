# Documentación técnica — Métricas de Uso de la Plataforma

## Evidencia y alcance

Esta documentación se reconstruyó el 2026-10-13 a partir de la definición del dashboard vigente y de las definiciones de sus dos datasets. Los JSON se usaron como evidencia técnica y permanecen fuera del repositorio.

| Archivo de entrada | Contenido | SHA-256 |
|---|---|---|
| `dashboard-definition3.json` | Dashboard `Actividad de usuarios en IAPOL` | `2d8656e70abb265698aefe1e3b49a939062ac57438d96ef72afca324f140d7e6` |
| `dataset-definition-1.json` | Dataset `eventos_IAPOL` | `63bca57d5f1f06fd91068b4c123bdff890fcdb35c248ab879421edce48e774eb` |
| `dataset-definition-2.json` | Dataset `User_Roles` | `c595155201835efb4998ea76fe5b4c019184d64660daff142a3506a711927cd8` |

La referencia de cada dataset en el dashboard coincide con la definición recibida. No se consultaron el análisis editable, la pantalla embebida, los permisos del dashboard, los schedules de SPICE ni datos productivos.

La documentación anterior describía otro dashboard y fue retirada. Sus hojas, capturas, identificadores, resultados históricos y fórmulas visuales no se trasladan automáticamente al dashboard vigente.

## Activos confirmados

| Elemento | Configuración |
|---|---|
| Dashboard | `Actividad de usuarios en IAPOL` |
| Estado | `CREATION_SUCCESSFUL` |
| Errores en la exportación | No reportados |
| Hojas | `Actividad de usuarios en IAPOL`; `Eventos de usuarios en IAPOL` |
| Visuales | 9 en H1 y 7 en H2 |
| Datasets | `User_Roles`; `eventos_IAPOL` |
| Modo | SPICE en ambos |
| Campos calculados | 48: 9 sobre `User_Roles` y 39 sobre `eventos_IAPOL` |
| Parámetros | `sigla`, `Fechainicio`, `Fechafin` |
| Filtros | 23 grupos: 18 habilitados y 5 deshabilitados |
| Acciones por clic | Ninguna en los 16 visuales |

El JSON del dashboard no identifica el análisis que lo originó. No se conserva el nombre del análisis anterior como si correspondiera al activo vigente.

## Modelo de datos

### Dataset `eventos_IAPOL`

El dataset contiene una tabla física de tipo `CustomSql`, llamada `personal_agrupado` en la definición:

```text
users_keycloak AS user
LEFT JOIN usr_mnvcc.vm_personal_agrupado AS p
    ON p.usuario_empresarial = user.username
LEFT JOIN event_table AS ev
    ON ev.username = user.username
WHERE p.sigla_laborando IS NOT NULL
```

La consulta obtiene usuarios de `pon-prod-events`, personal de `pon-prod-raw-sivicc` y eventos de `pon-prod-events`.

La tabla lógica aplica estas transformaciones:

1. Renombra `fecha_evento` a `fecha_eventos`.
2. Crea un nuevo `fecha_evento` con `addDateTime(-5, 'HH', fecha_eventos)`.
3. Proyecta 35 columnas de salida.

El ajuste de cinco horas está confirmado en la preparación de Quick, pero el JSON no explica la zona horaria original. No se debe documentar como conversión UTC→Colombia hasta confirmar el origen temporal.

### Dataset `User_Roles`

El dataset contiene una tabla física de tipo `CustomSql`:

```text
users_keycloak AS user
LEFT JOIN usr_mnvcc.vm_personal_agrupado AS p
    ON p.usuario_empresarial = user.username
LEFT JOIN event_table AS ev
    ON ev.username = user.username
LEFT JOIN eventos
    ON eventos.user_id = user.id
LEFT JOIN usuarios_roles AS roles
    ON roles.user_id = user.id
WHERE p.sigla_laborando IS NOT NULL
```

Expone 34 columnas. No declara `LogicalTableMap`; la fecha `fecha_evento_ev` se entrega como STRING y el dashboard crea `fecha_evento_eve` mediante `parseDate`.

### Grano y multiplicación de filas

Ninguna definición declara una llave única. El grano efectivo depende de las cardinalidades de personal, `event_table`, `eventos` y `usuarios_roles`.

`User_Roles` une tres colecciones potencialmente multivaluadas directamente con el usuario. Si un usuario tiene varios eventos y roles, las combinaciones pueden multiplicarse. Antes de sumar eventos se debe medir:

```text
filas por usuario
eventos distintos por usuario
roles distintos por usuario
combinaciones evento × rol
```

Los conteos distintos de `username` reducen el efecto sobre usuarios, pero no corrigen automáticamente sumas de interacciones, listados duplicados ni otras medidas a nivel de fila.

## Campos de salida

### `eventos_IAPOL` — 35 campos

| Campo | Tipo | Campo | Tipo |
|---|---|---|---|
| `id` | STRING | `username` | STRING |
| `first_name` | STRING | `last_name` | STRING |
| `sigla` | STRING | `unidad` | STRING |
| `created_timestamp` | DATETIME | `type` | STRING |
| `event_time` | DATETIME | `estado_user` | STRING |
| `direccion` | STRING | `fisica` | STRING |
| `descripcion_dependencia` | STRING | `sigla_papa` | STRING |
| `grad_alfabetico` | STRING | `apellidos` | STRING |
| `nombres` | STRING | `estado_empleado` | STRING |
| `especialidad` | STRING | `nombre_grado` | STRING |
| `descripcion_cargo` | STRING | `correo_electronico` | STRING |
| `usuario_empresarial` | STRING | `sigla_personal` | STRING |
| `sigla_laborando` | STRING | `desc_categoria` | STRING |
| `activo` | STRING | `desc_estado` | STRING |
| `numero_celular` | DECIMAL | `action` | STRING |
| `name_item` | STRING | `category` | STRING |
| `fecha_eventos` | DATETIME | `parent` | STRING |
| `fecha_evento` | DATETIME |  |  |

### `User_Roles` — 34 campos

| Campo | Tipo | Campo | Tipo |
|---|---|---|---|
| `id` | STRING | `username` | STRING |
| `first_name` | STRING | `last_name` | STRING |
| `sigla` | STRING | `unidad` | STRING |
| `created_timestamp` | DATETIME | `type` | STRING |
| `event_time` | DATETIME | `estado_user` | STRING |
| `direccion` | STRING | `fisica` | STRING |
| `descripcion_dependencia` | STRING | `sigla_papa` | STRING |
| `grad_alfabetico` | STRING | `apellidos` | STRING |
| `nombres` | STRING | `estado_empleado` | STRING |
| `especialidad` | STRING | `nombre_grado` | STRING |
| `descripcion_cargo` | STRING | `correo_electronico` | STRING |
| `usuario_empresarial` | STRING | `sigla_personal` | STRING |
| `sigla_laborando` | STRING | `desc_categoria` | STRING |
| `activo` | STRING | `desc_estado` | STRING |
| `numero_celular` | DECIMAL | `name_item` | STRING |
| `fecha_evento_dia` | DATETIME | `fecha_evento_ev` | STRING |
| `rol` | STRING | `group_name` | STRING |

## Población base

La población se restringe por dos mecanismos:

1. Ambas consultas SQL exigen `p.sigla_laborando IS NOT NULL`.
2. El dashboard aplica filtros sobre correo institucional, estado laboral y sigla.

Para `eventos_IAPOL`:

```text
usuarios_policia = ifelse(
  contains(correo_electronico, '@correo.policia.gov.co'),
  1,
  0
)
```

Para `User_Roles`:

```text
usuarios_ponal = ifelse(
  contains(correo_electronico, '@correo.policia.gov.co'),
  1,
  0
)
```

El dashboard filtra ambos indicadores a `1` y `estado_empleado` a `AC`. La validación debe confirmar mayúsculas, espacios, correos nulos y dominios alternativos autorizados.

## Parámetros

| Parámetro | Tipo | Valor inicial | Uso vigente |
|---|---|---|---|
| `sigla` | STRING, valor único | Sin valor estático | Usado por F03 en `eventos_IAPOL` y F20 en `User_Roles`. |
| `Fechainicio` | DATETIME | Inicio del mes anterior | Sólo aparece en F12 y F15, ambos deshabilitados. |
| `Fechafin` | DATETIME | Inicio del día actual | Sólo aparece en F12 y F15, ambos deshabilitados. |

Los parámetros de fecha no limitan actualmente los visuales. Las ventanas temporales activas se calculan con `now()` o mediante filtros relativos.

## Campos calculados utilizados por los visuales vigentes

### Fechas y estado de actividad — `User_Roles`

```text
fecha_evento_eve =
parseDate(fecha_evento_ev, "yyyy-MM-dd HH:mm:ss")
```

```text
dias_sin_interaccion =
abs(dateDiff(now(), maxOver(fecha_evento_eve, [username], PRE_AGG), "DD"))
```

```text
estado_actividad =
ifelse(
  estado_user = 'Sin ingreso', 'Nunca ingresó',
  dias_sin_interaccion <= 10, '0–10 días',
  dias_sin_interaccion <= 30, '11–30 días',
  dias_sin_interaccion <= 60, '31–60 días',
  'Más de 60 días'
)
```

El uso de `abs` convierte fechas futuras en días positivos y puede ocultar problemas de calidad. Además, el filtro F22 excluye fechas nulas antes de visualizar `estado_actividad`.

### Usuarios distintos — `User_Roles`

```text
usuarios_actividad_mes =
distinctCountIf(
  username,
  truncDate("MM", parseDate(fecha_evento_ev, "yyyy-MM-dd HH:mm:ss"))
    = truncDate("MM", now())
)
```

```text
usuarios_activos_6_meses =
distinctCountIf(
  username,
  dateDiff(parseDate(fecha_evento_ev, "yyyy-MM-dd HH:mm:ss"), now(), "MM") <= 6
)
```

```text
usuarios_actividad_año =
distinctCountIf(username, isNotNull(fecha_evento_ev))
```

`usuarios_actividad_año` depende del filtro F22 para obtener alcance anual; su expresión sola cuenta cualquier fecha no nula disponible en el contexto.

### Usuarios del día y última actividad — `eventos_IAPOL`

```text
Usuarios_ingreso_dia_actual =
distinctCountIf(
  username,
  truncDate("DD", fecha_evento) = truncDate("DD", now())
)
```

```text
ultima_fecha_actividad =
maxOver(fecha_evento, [username], PRE_AGG)
```

### Conteos de eventos — `eventos_IAPOL`

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

Todos estos campos se agregan mediante `SUM` en H2. Un `countOver` devuelve el conteo de la partición en cada fila de esa partición; sumarlo puede repetir el valor. Esta configuración requiere conciliación antes de aceptar los KPI como conteos de eventos.

### Roles homologados — `User_Roles`

`grupos_chatbot` convierte seis valores de `group_name` en etiquetas funcionales para H1-V08. Cualquier otro grupo produce NULL y queda fuera por F23.

## Campos calculados heredados sin uso directo en los visuales actuales

La definición conserva campos de adopción, embudo y homologación que no aparecen directamente en los pozos de los 16 visuales ni como medidas vigentes:

- `Estado actividad`, `Etapa embudo`, `Ingreso antes del mes actual`.
- `KPI Total usuarios`, `KPI Han ingresado`, `KPI Nunca ingresaron`.
- `Porcentaje Activos 10 días`, `Porcentaje Han ingresado`, `Porcentaje Nunca ingresaron`.
- Porcentajes del periodo anterior y sus tres variaciones.
- `Primera fecha de ingreso`, `Total embudo activos`, `Total embudo ingresaron`, `Total embudo registrados`, `Valor embudo`.
- `Usuarios_ingreso_10_dias`, `Usuarios_ingreso_durante_2026`, `Usuarios_ingreso_ultima_30_dias`, `Usuarios_ingreso_ultima_semana`.
- `SIgla_laborando_ME_DE`, `sigla_laborando_EXCLUIR_ME_DE`, `rol_dominante_user`, `ultimaInteraccion`.
- `parent_corregido_para_null_manual`, que contiene una homologación extensa de elementos y módulos.
- `eventos_usuarios_año` de `User_Roles`.

`dias_sin_interaccion` de `User_Roles` sí participa indirectamente en `estado_actividad`. `es_evento_hoy` participa únicamente en F08, que está deshabilitado.

La presencia de un campo calculado no demuestra que el dashboard vigente lo muestre. Estos campos deben tratarse como configuración heredada hasta revisar el análisis editable.

## Inventario de filtros

| Ref. | Estado | Dataset | Campo | Alcance y regla |
|---|---|---|---|---|
| F01 | Habilitado | `eventos_IAPOL` | `usuarios_policia` | Todas las hojas/datasets; igual a `1`. |
| F02 | Habilitado | `eventos_IAPOL` | `estado_empleado` | Todas las hojas; incluye `AC`, excluye nulos. |
| F03 | Habilitado | `eventos_IAPOL` | `sigla_laborando` | Todas las hojas; igual al parámetro `sigla`. |
| F04 | Habilitado | `eventos_IAPOL` | `sigla_laborando` | Todos los visuales de H1 y H2; lista inicialmente en todos los valores, excluye nulos. |
| F05 | Habilitado | `eventos_IAPOL` | `descripcion_dependencia` | Todos los visuales de H1 y H2; inicialmente todos, excluye nulos. |
| F06 | Habilitado | `eventos_IAPOL` | `estado_user` | Todos los visuales de H1 y H2; inicialmente todos, excluye nulos. |
| F07 | Deshabilitado | `eventos_IAPOL` | `fecha_evento` | Rango fijo 2026-01-01 a 2026-09-10, extremos incluidos. |
| F08 | Deshabilitado | `eventos_IAPOL` | `es_evento_hoy` | H1-V03; igual a `1`. |
| F09 | Habilitado | `User_Roles` | `fecha_evento_eve` | H1-V06; año actual, excluye nulos. |
| F10 | Habilitado | `eventos_IAPOL` | `Usuarios_ingreso_dia_actual` | H1-V03; igual a `1`. |
| F11 | Habilitado | `eventos_IAPOL` | `username` | H2-V02; Top 10 ordenado por `SUM(Interacciones totales)`. |
| F12 | Deshabilitado | `eventos_IAPOL` | `fecha_evento` | H2-V02; entre `Fechainicio` incluido y `Fechafin` excluido. |
| F13 | Habilitado | `eventos_IAPOL` | `descripcion_dependencia` | H2-V02; inicialmente todos, excluye nulos. |
| F14 | Deshabilitado | `eventos_IAPOL` | `username` | H2-V01; Top 10 por `SUM(Interacciones totales)`. |
| F15 | Deshabilitado | `eventos_IAPOL` | `fecha_evento` | H2-V01; entre `Fechainicio` incluido y `Fechafin` excluido. |
| F16 | Habilitado | `eventos_IAPOL` | `descripcion_dependencia` | H2-V01; inicialmente todos, excluye nulos. |
| F17 | Habilitado | `eventos_IAPOL` | `sigla_laborando` | H2-V01; Top 10 por conteo descendente de la dimensión. |
| F18 | Habilitado | `User_Roles` | `usuarios_ponal` | Todas las hojas; igual a `1`, excluye nulos. |
| F19 | Habilitado | `User_Roles` | `estado_empleado` | Todas las hojas; incluye `AC`, excluye nulos. |
| F20 | Habilitado | `User_Roles` | `sigla_laborando` | Todas las hojas; igual al parámetro `sigla`. |
| F21 | Habilitado | `User_Roles` | `sigla_laborando` | Todas las hojas; lista inicialmente en todos los valores, excluye nulos. |
| F22 | Habilitado | `User_Roles` | `fecha_evento_eve` | Todas las hojas; año actual, excluye nulos. |
| F23 | Habilitado | `User_Roles` | `grupos_chatbot` | H1-V08; incluye las seis etiquetas homologadas. |

F01 declara alcance `ALL_DATASETS`; los demás filtros declaran `SINGLE_DATASET`. Aunque varios indiquen “todas las hojas”, sólo pueden afectar visuales compatibles con su dataset.

## Controles por hoja

| Hoja | Control | Filtro fuente | Observación |
|---|---|---|---|
| H1 | Estado | F06, `eventos_IAPOL.estado_user` | No filtra directamente los siete visuales de `User_Roles`. |
| H1 | Sigla | F21, `User_Roles.sigla_laborando` | No filtra directamente H1-V03 y H1-V04. |
| H1 | fecha_evento_eve | F22, `User_Roles.fecha_evento_eve` | Año actual; el título técnico debe revisarse para usuarios finales. |
| H1 | Estado Empleado | F19, `User_Roles.estado_empleado` | Incluye `AC`. |
| H2 | Sigla | F04, `eventos_IAPOL.sigla_laborando` | Compatible con los siete visuales. |
| H2 | Estado | F06, `eventos_IAPOL.estado_user` | Compatible con los siete visuales. |
| H2 | fecha_evento_eve | F22, `User_Roles.fecha_evento_eve` | H2 no contiene visuales de `User_Roles`; no tiene efecto evidente. |

## Publicación

- Exportación CSV habilitada.
- Exportación con campos ocultos deshabilitada.
- Filtros ad hoc deshabilitados.
- Controles de hoja inicialmente colapsados.
- Menú, maximización, ordenamiento de ejes, drill y tooltips habilitados.
- Q&A y acciones de Quick Suite deshabilitados.
- Resumen ejecutivo y Data Stories habilitados.

No hay acciones por punto de datos en los visuales. La definición no contiene reglas de seguridad por fila ni por columna en los datasets. Se deben revisar los permisos del dashboard antes de aprobar la exposición o exportación de datos personales.

## Actualización y trazabilidad pendientes

| Información | Estado |
|---|---|
| Última modificación de `eventos_IAPOL` en la definición recibida | 2026-10-13 12:04:35, hora Colombia |
| Última modificación de `User_Roles` en la definición recibida | 2026-10-13 01:06:37, hora Colombia |
| Programación SPICE | No incluida |
| Historial y última ingesta exitosa | No incluido |
| Frecuencia de las tablas fuente | No incluida |
| Responsables de los procesos | Pendiente por confirmar |

`LastUpdatedTime` es un metadato del dataset. No demuestra cuándo ingresaron los datos ni que una recarga SPICE haya terminado correctamente.

## Hallazgos prioritarios

1. **Posible sobreconteo:** los KPI y rankings de H2 suman campos `countOver(..., PRE_FILTER)` potencialmente repetidos por fila.
2. **Control de fecha sin consumidor en H2:** el control visible usa `User_Roles`, mientras los siete visuales usan `eventos_IAPOL`.
3. **Filtros fragmentados en H1:** Estado pertenece a `eventos_IAPOL`; Sigla, fecha y estado laboral pertenecen a `User_Roles`.
4. **Usuarios sin ingreso posiblemente excluidos:** F22 elimina fechas nulas antes de mostrar `estado_actividad`.
5. **Ranking y medida distintos:** H2-V02 ordena por `Interacciones totales` y muestra `eventos_usuarios_año`; H2-V01 ordena siglas por conteo de sigla y muestra otra medida.
6. **Multiplicación en `User_Roles`:** las uniones independientes de eventos y roles pueden producir combinaciones múltiples por usuario.
7. **Tratamiento horario diferente:** `eventos_IAPOL` resta cinco horas; `User_Roles` sólo parsea un texto de fecha en la definición disponible.
8. **Datos personales exportables:** las tablas contienen información identificable y CSV está habilitado; falta evidencia de permisos efectivos.

Estos hallazgos provienen de la configuración. No se registran como fallas confirmadas hasta reproducir su efecto con datos autorizados.

## Procedimiento de conciliación

1. Registrar el instante de corte, zona horaria y últimas ingestas exitosas de ambos datasets.
2. Obtener el conteo base de filas, usuarios distintos, eventos y roles por usuario antes y después de cada unión.
3. Aplicar la misma población: sigla informada, correo institucional y empleado `AC`.
4. Reproducir cada ventana temporal con límites concretos en vez de evaluar `now()` en momentos distintos.
5. Comparar el conteo directo de eventos con el resultado de sumar el `countOver` por usuario.
6. Ejecutar la prueba con y sin filtros de Sigla, Estado, dependencia y fecha.
7. Verificar los criterios de orden de los Top 10 por separado de la medida mostrada.
8. Registrar únicamente resultados agregados; no copiar nombres, correos, teléfonos, direcciones o usuarios.

### Consulta conceptual para detectar multiplicación

```sql
SELECT
    username,
    COUNT(*) AS filas_resultantes,
    COUNT(DISTINCT <id_evento>) AS eventos_distintos,
    COUNT(DISTINCT <id_rol>) AS roles_distintos
FROM <consulta_user_roles>
GROUP BY username
HAVING COUNT(*) > GREATEST(
    COUNT(DISTINCT <id_evento>),
    COUNT(DISTINCT <id_rol>)
);
```

Los identificadores de evento y rol no están expuestos en las columnas de salida recibidas. Deben confirmarse en las tablas fuente antes de convertir la consulta conceptual en una validación ejecutable.

### Comparación conceptual de eventos

```sql
WITH eventos_por_usuario AS (
    SELECT
        username,
        COUNT(name_item) AS eventos_directos
    FROM <fuente_equivalente_eventos_iapol>
    WHERE fecha_evento >= TIMESTAMP '<inicio>'
      AND fecha_evento < TIMESTAMP '<fin_exclusivo>'
    GROUP BY username
)
SELECT
    SUM(eventos_directos) AS eventos_directos,
    SUM(eventos_directos * eventos_directos) AS referencia_repeticion_cuadratica
FROM eventos_por_usuario;
```

La segunda cifra sólo ilustra el riesgo de repetir un conteo por cada fila. El resultado exacto de Quick depende de los filtros y del número de filas que llegan a cada visual.
