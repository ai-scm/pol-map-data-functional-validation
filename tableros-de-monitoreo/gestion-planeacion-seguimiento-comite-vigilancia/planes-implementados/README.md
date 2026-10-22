# Hoja: Planes implementados

## Propósito

Ranking nacional de los planes preventivos según las actividades cumplidas en la semana. Replica la página “Planes preventivos implementados nacional” del reporte semanal. Versión: sandbox.

## Controles observados

- `SELECCIONE UN DÍA DE LA SEMANA` (parámetro `FECHASEMANA`) y `UNIDAD`.
- Recuadro `CORTE`.

## Componentes observados

- `RANKING DE PLANES PREVENTIVOS CUMPLIDOS`: N°, plan con su duración (por ejemplo `Plan Motos (30 min)`), cantidad y % con un decimal; fila de total. Solo planes con al menos una actividad cumplida.
- `PLANES PREVENTIVOS DISTINTOS IMPLEMENTADOS` y `TOTAL ACTIVIDADES CUMPLIDAS`.
- `PLAN MÁS IMPLEMENTADO NACIONAL`.
- `TOP 15 PLANES MÁS IMPLEMENTADOS` en barras.

## Pruebas específicas

- [x] Cantidad de planes con cumplidos coincide con el reporte. — Aprobado el 2026-10-21: 59.
- [x] Los cinco primeros coinciden. — Aprobado el 2026-10-21: Motos 14.105 (reporte 14.108), Baliza, Segmentos de Vida, Puesto de Control y Bancos.
- [x] Los últimos de la lista coinciden. — Aprobado el 2026-10-21: Control Fronterizo, Apoyo Plana Mayor y Pactos de Convivencia (1) y Control Pólvora (2).
- [ ] Horas de servicio por plan. — No aplica: `total_minutos` no corresponde a la duración del plan (hallazgo H09).

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
