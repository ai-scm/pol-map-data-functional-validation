# Sheet 10

## Estado de publicación

Hoja interna **no publicada** del análisis `eventos_IAPOL_metricas_uso analysis`. El nombre es técnico y no describe una función de negocio; debería renombrarse si la hoja se conserva.

## Contenido

La hoja contiene un único gráfico de líneas titulado `Cantidad usuarios mapa de anticipación`.

| Propiedad | Configuración confirmada |
|---|---|
| Dimensión | `fecha_evento` |
| Medida | `username` con conteo distinto |
| Elemento filtrado | `name_item` incluye `Mapa de Anticipación a Fenómenos de Seguridad` |
| Periodo fijo | Entre el 2026-01-01 y el 2026-06-10 |

También hereda los filtros generales `usuarios_policia = 1`, `estado_empleado` incluye `AC` y `sigla_laborando = sigla`.

## Interpretación

Cada punto representa la cantidad de usuarios distintos con eventos del mapa de anticipación en la fecha correspondiente, dentro del periodo fijo configurado. No equivale al total de interacciones: un usuario se cuenta una vez por grupo temporal aunque genere varios eventos.

## Riesgos y validaciones

- El periodo está fijado a fechas históricas y quedará obsoleto si la hoja se publica sin parametrizarlo.
- No se observaron controles; modificar el rango requiere editar el análisis.
- Debe compararse con la hoja publicada `Uso mapa anticipacion`, que emplea parámetros de fecha y puede producir un alcance distinto.
- Confirmar la granularidad exacta de `fecha_evento` en el eje y la inclusión de ambos extremos.
- Revisar si el nombre exacto de `name_item` puede cambiar por homologación o renombramiento del producto.

## Recomendación de mantenimiento

Si es una prueba temporal, documentar responsable y fecha de retiro. Si se convierte en funcional, renombrarla, reemplazar el rango fijo por parámetros y publicar sólo después de conciliarla con la hoja oficial.

[Volver a Métricas de Uso](../README.md)
