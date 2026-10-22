# Hoja: Control y disuasión

## Propósito

Vista gerencial del cumplimiento de los planes preventivos por unidad en un rango de fechas. Es la hoja de inicio del dashboard publicado. Versión: producción y sandbox.

## Controles observados

- `FECHA INCIAL` y `FECHA FINAL` (parámetros `FECHAINICIAL`, por defecto inicio del año, y `FECHAFINAL`, por defecto fin del día actual), sobre `fecha_inicio_act`.
- `UNIDAD`, `ESTACIÓN`, `CUADRANTE` y `CLASE ACTIVIDAD` (sobre `plan_descripcion`).

## Componentes observados

- Título `REPORTE PLANES PREVENTIVOS – CONTROL Y DISUASIÓN` y fecha de actualización.
- Tabla de unidades: N° estaciones, cumple, no cumple, total y % de cumplimiento con semáforo.
- Top 3 unidades con mayor y con menor % de cumplimiento.
- Textos con cifras incrustadas: total de planes de la vigencia y nivel de cumplimiento nacional.
- `Planes más implementados por unidad`: plan con más actividades en cada unidad (filtro `COMPARATIVO_MAXIMO = 1`).

## Diferencias entre producción y sandbox

| Aspecto | Producción | Sandbox |
|---|---|---|
| Planes que cuentan | Incluye `Elaborado` | Solo aprobados |
| No cumple y % | Cuentan las actividades sin evaluar como no cumplidas | Solo evaluadas |
| Semáforo | Seis colores, cortes 90/75/60/50/40 | Cuatro niveles del manual: 90/70/50 |
| Presentación | Verdes, banner externo, encabezados solapados | Colores institucionales, banner en Quick, solapamientos corregidos |

## Pruebas específicas

- [ ] La fecha de actualización corresponde a la última carga. — Fallido: `FECHA_ACTUALIZACION` es un cálculo de ciclos de dos días, no lee los datos (hallazgo H07).
- [ ] Top 3 de mayor y menor cumplimiento con un rango de una semana coinciden con el reporte. — No ejecutado en el dashboard.
- [ ] Las cifras incrustadas en los textos quedan en su posición tras el ajuste de diseño. — No ejecutado: se movieron en bloque; verificar visualmente.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
