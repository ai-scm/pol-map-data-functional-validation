# Hoja: Metropolitanas, departamentos y regiones

## Propósito

Cumplimiento de la semana separado por metropolitanas, departamentos y las ocho regiones de Policía. Replica las páginas “Cumplimiento en metropolitanas”, “Cumplimiento en departamentos” y “Cumplimiento por regiones” del reporte semanal. Versión: sandbox.

## Controles observados

- `SELECCIONE UN DÍA DE LA SEMANA` (parámetro `FECHASEMANA`) y `UNIDAD`.
- Recuadro `CORTE`.

## Componentes observados

- Metropolitanas: fila de totales y tabla de las 19 metropolitanas.
- Departamentos: fila de totales y tabla de los 34 departamentos.
- Columnas de las tablas: N°, unidad, N° estaciones, N° patrullas, cumplidos, no cumplidos, total, plan más implementado y % con semáforo; fila de total.
- `RESUMEN POR REGIÓN`: una fila por región con N° de unidades, estaciones, patrullas, cumplidos, no cumplidos, total y %.
- Ocho tablas, una por región, con la misma estructura de las tablas de unidades.

La región se asigna con el campo `REGION`, que reproduce el mapeo del reporte semanal. `REMSA`, sigla de DESAB hasta el 2026-01-19, está en la Región 1.

## Pruebas específicas

- [x] Totales de metropolitanas coinciden con el reporte. — Aprobado el 2026-10-21: 192 estaciones y 2.141 patrullas idénticas; 26.747 / 749 / 27.496 frente a 26.755 / 753 / 27.508.
- [x] Totales de departamentos coinciden. — Aprobado el 2026-10-21: 947 / 1.693 / 40.769 frente a 948 / 1.673 / 40.799; la diferencia es DESAB.
- [x] Regiones 5, 6 y 7 coinciden exactamente. — Aprobado el 2026-10-21.
- [x] Región 1 coincide al descontar DESAB. — Aprobado el 2026-10-21.
- [ ] DEVAU aparece en la Región 7 aunque no tenga actividades. — No aplica en esta versión: la tabla muestra solo unidades con actividades.
- [ ] Mapeo de regiones confirmado con una tabla oficial. — Bloqueado: no existe en las fuentes cargadas.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
