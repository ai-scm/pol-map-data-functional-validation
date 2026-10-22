# Hoja: Reconocimiento Top 5

## Propósito

Reconoce las dependencias con nivel de cumplimiento Superior en la semana. Replica la página “Top 5 nacional cumplimiento GESCOV” del reporte semanal. Versión: sandbox.

## Controles observados

- `SELECCIONE UN DÍA DE LA SEMANA` (parámetro `FECHASEMANA`) y `UNIDAD`.
- Recuadro `CORTE`.

## Componentes observados

- Texto de gestión de reconocimiento con el criterio aplicado.
- Cinco tablas Top 5, con unidad, nombre, actividades y % con semáforo:
  1. Distritos de Policía (`cosec_distrito`).
  2. Estaciones de Policía (`unidad` que empieza por `ESTACION`).
  3. Subestaciones (`cai` de tipo subestación).
  4. CAI (`cai` de tipo CAI).
  5. Patrullas de vigilancia (`cuadrante`), con la estación a la que pertenecen.
- `PRIMER LUGAR POR CATEGORÍA`: cinco tarjetas con el ganador de cada lista.

Criterio: mayor % de cumplimiento y, a igual %, mayor cantidad de actividades planeadas.

## Pruebas específicas

- [x] Las cinco listas de la semana 7 coinciden con el reporte, en el mismo orden. — Aprobado el 2026-10-21 en Athena.
- [x] El criterio de desempate por volumen reproduce el orden del reporte. — Aprobado el 2026-10-21.
- [ ] Cada tabla muestra cinco filas ordenadas por % y por volumen. — No ejecutado: primer uso de Top 5 con dos criterios; verificar visualmente.
- [ ] Empates en la quinta posición. — No ejecutado: Quick puede mostrar cualquiera de los empatados (en la semana 7, CAI Catama y CAI Gobernación tienen 108).

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
