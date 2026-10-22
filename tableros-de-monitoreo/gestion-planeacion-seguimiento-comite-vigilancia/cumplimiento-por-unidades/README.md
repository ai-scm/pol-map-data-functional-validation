# Hoja: Cumplimiento por unidades

## Propósito

Cumplimiento de la semana para cada una de las 53 unidades (metropolitanas y departamentos), con rankings y la verificación del plan mínimo de la guía GESCOV. Replica las páginas “Cumplimiento por unidades” y “Planes cumplidos por unidad” del reporte semanal. Versión: sandbox.

## Controles observados

- `SELECCIONE UN DÍA DE LA SEMANA` (parámetro `FECHASEMANA`) y `UNIDAD`.
- Recuadro `CORTE`.

## Componentes observados

### Cumplimiento por unidades

- Tabla de unidades: N°, unidad, N° estaciones, planes cumplidos, planes no cumplidos, total planeado, plan más implementado de la unidad y % de cumplimiento con semáforo; fila de total. Orden: % y, a igual %, volumen.
- `TOP 3 UNIDADES CON MAYOR % DE CUMPLIMIENTO` y `UNIDADES CON MENOR % DE CUMPLIMIENTO`.
- `PLAN MÁS IMPLEMENTADO NACIONAL`, `NIVEL DE CUMPLIMIENTO NACIONAL GESCOV` y `PLANES ELABORADOS SIN APROBACIÓN`.
- Leyenda de semaforización.

### Planes cumplidos por unidad

- Barras horizontales con los cumplidos de las 53 unidades.
- Top 3 con mayor y con menor cantidad de cumplidos y total de cumplidos de la semana.
- Texto de la guía GESCOV sobre planes mínimos.

### Cumplimiento del plan mínimo semanal (nuevo)

- Tabla por unidad: cuadrantes con planeación, plan mínimo de la semana, total planeado y % del mínimo con semáforo (100 % o más = cumple la guía). Las unidades que no lo alcanzan aparecen primero.
- Nota con el cálculo y su limitación.

## Pruebas específicas

- [x] La fila de MEBOG coincide con el reporte. — Aprobado el 2026-10-21: 19 estaciones, 4.824 / 204 / 5.028, Plan Segmentos de Vida, 96 %.
- [x] Top 3 por % coincide. — Aprobado el 2026-10-21: DECAS, METUN y DEGUN al 100 %.
- [x] Top 3 por cantidad coincide. — Aprobado el 2026-10-21: MEBOG 4.824, DEANT 4.718 y DEBOY (4.510; reporte 4.474).
- [ ] Unidad con menor % coincide. — Fallido por fecha de corte: DESAB figuraba con 0 % en el reporte y hoy tiene 88 %.
- [x] Plan mínimo calculado para todas las unidades. — Aprobado el 2026-10-21: 22 de 53 unidades alcanzan el mínimo en la semana 7.
- [ ] La columna `PLAN MÁS IMPLEMENTADO UNIDAD` muestra un solo plan por unidad sin duplicar filas. — No ejecutado.
- [ ] El plan mínimo usa el catálogo oficial de cuadrantes. — Bloqueado: no hay catálogo; se usan los cuadrantes con planeación.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
