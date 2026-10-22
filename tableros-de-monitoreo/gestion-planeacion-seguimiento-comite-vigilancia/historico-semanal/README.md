# Hoja: Histórico semanal

## Propósito

Cumplimiento de cada semana del año y consolidado del año hasta la semana de corte. Replica la página “Cumplimiento por semana planes preventivos y consolidado” del reporte semanal. Versión: sandbox.

## Controles observados

- `SEMANA DE CORTE (SELECCIONE UN DÍA)` (parámetro `FECHASEMANA`): se muestran las semanas del año de esa semana, hasta ella inclusive.
- `UNIDAD`.
- Recuadro `CORTE`.

## Componentes observados

- Tabla `CUMPLIMIENTO POR SEMANA`: mes, semana, cumplidos, no cumplidos, total planeado y % con semáforo; la fila de total es el consolidado del año.
- `SEMANAS CON MAYOR % DE CUMPLIMIENTO` (cuatro mejores).
- `SEMANAS CON BAJO CUMPLIMIENTO (MENOR A 90 %)`; queda vacía si ninguna semana baja del nivel Superior.
- `SEMANA CON MAYOR CUMPLIMIENTO DE PLANES` y `SEMANA CON MAYOR INCUMPLIMIENTO DE PLANES`.
- `TOTAL PLANES PROGRAMADOS - CONSOLIDADO`.
- `SEMANAS POR NIVEL DE CUMPLIMIENTO`.
- Línea del % de cumplimiento por semana con referencia en 90 % y barras apiladas de cumplidos y no cumplidos.

La columna `MES` muestra los meses que abarca cada semana de domingo a sábado (la semana 1 de 2026 es `DIC/ENE`). El reporte usa otras etiquetas que no siguen una regla consistente.

## Pruebas específicas

- [x] Las semanas 1 a 5 y 7 de 2026 coinciden con el reporte. — Aprobado el 2026-10-21; diferencias menores al 0,2 %.
- [ ] La semana 6 de 2026 coincide con el reporte. — Fallido: el reporte tiene cerca de 2.900 actividades no cumplidas que hoy no existen en GESCOV (hallazgo H01).
- [x] La semana 1 incluye del 2025-12-28 al 2025-12-31. — Aprobado el 2026-10-21: 69.813 frente a 69.810 del reporte.
- [ ] Las barras muestran cumplidos en lima y no cumplidos en navy. — No ejecutado: el color por serie quedó en la definición, falta verificarlo visualmente.
- [ ] Al cambiar de año, la tabla reinicia en la semana 1. — No ejecutado.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
