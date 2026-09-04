# Información de usuarios (Anterior)

## Estado de publicación

Hoja interna **no publicada** del análisis `eventos_IAPOL_metricas_uso analysis`. Se documenta para trazabilidad y mantenimiento, pero no forma parte del dashboard productivo visible al usuario final.

## Propósito observado

Es una versión anterior de la hoja de seguimiento de usuarios. Resume usuarios registrados, usuarios que han ingresado, usuarios sin ingreso y usuarios activos en los últimos diez días; además presenta una tabla de seguimiento y distribuciones por sigla y usuario.

## Filtros

Hereda los filtros generales del análisis:

| Campo | Regla confirmada |
|---|---|
| `usuarios_policia` | Igual a `1`. |
| `estado_empleado` | Incluye `AC`. |
| `sigla_laborando` | Igual a `sigla`, según la condición configurada en el análisis. |

Se observó además un filtro personalizado de hoja sobre `descripcion_dependencia`, inicialmente en `Todo`, y controles visibles para `SIGLA` y `estado_empleado = AC`. Debe comprobarse el alcance exacto de cada control sobre los visuales antiguos.

## Visuales inventariados

| Visual | Configuración observada |
|---|---|
| Total usuarios | KPI de usuarios totales. |
| Han ingresado | KPI de usuarios con ingreso. |
| Usuarios sin ingreso | KPI de usuarios sin ingreso. |
| Usuarios activos 10 días | KPI de actividad reciente. |
| Tabla de seguimiento | Máximo de `fecha_evento` y suma de `Interacciones Totales`, desglosados por atributos de usuario, sigla, dependencia, fecha de creación y días sin interacción. |
| Usuarios activos por sigla | Conteo distinto de `username` por `SIgla_laborando_ME_DE`. |
| Top 10 usuarios con más acciones | Gráfico apilado que muestra recuento de `Interacciones Totales` por `username`. |

Los KPI parecen utilizar los mismos campos calculados documentados en la hoja vigente, pero no deben darse por equivalentes sin comparar sus campos de valor uno a uno.

## Riesgos técnicos

- La tabla contiene identificadores y atributos personales; no se deben copiar filas reales a la documentación.
- El visual denominado “Top 10” debe conservar su orden y límite; sus barras no representan el universo completo.
- El rótulo indica “más acciones”, mientras la configuración accesible muestra recuento de un campo ya calculado. Se debe comprobar si la agregación correcta debería ser suma, máximo o un conteo de eventos.
- Al ser una versión anterior, puede contener reglas obsoletas y no debe usarse para conciliar el dashboard publicado.

## Validaciones

1. Comparar KPI y filtros con la hoja vigente usando el mismo corte.
2. Verificar si existen diferencias intencionales o si la hoja es únicamente un respaldo.
3. Confirmar que permanece no publicada y que no recibe cambios funcionales por error.
4. Anonimizar `username`, correo, nombre y demás atributos en cualquier evidencia.

[Volver a Métricas de Uso](../README.md)
