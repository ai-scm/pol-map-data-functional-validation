# Hoja: Contexto semanal

## Propósito

Resumen ejecutivo de una semana de domingo a sábado: actividades planeadas, cumplidas y no cumplidas, con su distribución por zona, tipo de plan y día. Replica la página “Contexto semanal planes preventivos” del reporte semanal GESCOV. Versión: sandbox.

## Controles observados

- `SELECCIONE UN DÍA DE LA SEMANA` (parámetro `FECHASEMANA`): se muestra la semana que contiene la fecha. Por defecto, hace 7 días (última semana completa).
- `UNIDAD` (parámetro `UNIDAD`, múltiple).
- Recuadro `CORTE`: número de semana, fecha desde y fecha hasta.

## Componentes observados

### Comité local convivencia

- `TOTAL PLANEADO`, `PLANES CUMPLIDOS` (recuadro lima) y `PLANES NO CUMPLIDOS` (recuadro navy).
- `ZONA PLAN`: urbana y rural, con total, cumple y no cumple.
- `PLANES ELABORADOS (SIN APROBAR)` y `ELABORADOS POR UNIDAD`.
- `DÍA MAYOR CANTIDAD DE PLANES CUMPLIDOS`.

### Proyección planes

- `TIPO PLAN`: planeación semanal y extraordinaria, con total, cumple, no cumple y % con semáforo.
- `TOP 5 PLANES MÁS IMPLEMENTADOS`, con participación sobre los cumplidos.
- `CANTIDAD DE PLANES CUMPLIDOS POR DÍA`, de domingo a sábado.
- `PENDIENTES POR EVALUAR`: actividades sin evaluación (útil en la semana en curso).

### Indicadores de la semana

- % de planes cumplidos, % de no cumplidos, plan más implementado, unidad con mayor cumplimiento y unidad con menor cumplimiento.

## Pruebas específicas

- [x] Total, cumplidos y no cumplidos de la semana 7 de 2026 se reproducen en Athena. — Aprobado el 2026-10-21: 68.265 / 66.096 / 2.169 frente a 68.307 / 66.015 / 2.292 del reporte.
- [x] Elaborados por unidad coinciden con el reporte. — Aprobado el 2026-10-21: 79, con el mismo detalle por unidad.
- [x] Zona rural y tipo de plan coinciden. — Aprobado el 2026-10-21: rural 1.565 en ambos; semanal 60.990 y extraordinaria 7.275.
- [x] Día con más cumplidos y cumplidos por día coinciden. — Aprobado el 2026-10-21: lunes 9.810 (reporte 9.796).
- [x] Top 5 de planes coincide. — Aprobado el 2026-10-21: Motos, Baliza, Segmentos de Vida, Puesto de Control y Bancos.
- [x] Unidad con mayor cumplimiento desempata por volumen. — Aprobado el 2026-10-21 en Athena: DECAS, como en el reporte.
- [ ] El selector muestra la semana de domingo a sábado que contiene la fecha. — No ejecutado.
- [ ] Los visuales muestran las cifras anteriores en el dashboard. — No ejecutado: verificado por definición, no visualmente.
- [ ] Turno con mayor cumplimiento. — Bloqueado: falta la definición de horarios de los turnos.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
