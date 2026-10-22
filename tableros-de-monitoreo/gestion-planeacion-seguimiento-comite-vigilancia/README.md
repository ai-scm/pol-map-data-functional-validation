# Gestión para la planeación y seguimiento al comité de vigilancia

## Objetivo

Mide el cumplimiento de los planes preventivos GESCOV que las estaciones de Policía concertan en los comités de vigilancia: qué se planeó, qué se cumplió, dónde y cuándo. Desde octubre de 2026 existe una versión rediseñada que replica el reporte semanal de la Jefatura Nacional del Servicio de Policía (GUVIP) y agrega el comparativo de delitos de impacto de SIEDCO.

## Ruta funcional

`Home > Gestión para la planeación y seguimiento al comité de vigilancia`

El tablero es un módulo propio del menú principal (posición 9), con un único acceso del mismo nombre. No pertenece al menú `Tableros de Monitoreo`; se documenta en esta carpeta por su función de seguimiento.

## Documentación técnica

Los activos, la cadena de datos, las reglas del reporte semanal, los filtros, los campos calculados, los cambios de octubre de 2026 y los asuntos pendientes están en [`documentacion-tecnica.md`](documentacion-tecnica.md).

Las consultas usadas para validar el tablero contra Athena están en [`sql/athena.sql`](sql/athena.sql).

## Estado

| Versión | Hojas | Situación al 2026-10-21 |
|---|---|---|
| Producción (publicada en IAPOL) | Control y disuasión; Microgerencia territorio | Sin cambios. Conserva la lógica, colores y banner anteriores. |
| Sandbox (copia de trabajo) | Las siete hojas nuevas y las dos originales ajustadas | Construida y validada contra Athena. No publicada en IAPOL. |

## Hojas

| Hoja visible | Versión | Propósito | Documento |
|---|---|---|---|
| Contexto semanal | Sandbox | Resumen ejecutivo de la semana: planeado, cumplido, zona, tipo de plan, día, planes más implementados. | [`contexto-semanal`](contexto-semanal/README.md) |
| Cumplimiento por unidades | Sandbox | Cumplimiento de las 53 unidades, rankings y plan mínimo de la guía GESCOV. | [`cumplimiento-por-unidades`](cumplimiento-por-unidades/README.md) |
| Histórico semanal | Sandbox | Cumplimiento por semana del año y consolidado hasta la semana de corte. | [`historico-semanal`](historico-semanal/README.md) |
| Metropolitanas, departamentos y regiones | Sandbox | Cumplimiento por tipo de unidad y por las ocho regiones de Policía. | [`metropolitanas-departamentos-y-regiones`](metropolitanas-departamentos-y-regiones/README.md) |
| Reconocimiento Top 5 | Sandbox | Distritos, estaciones, subestaciones, CAI y patrullas con 100 % de cumplimiento. | [`reconocimiento-top-5`](reconocimiento-top-5/README.md) |
| Planes implementados | Sandbox | Ranking nacional de planes preventivos cumplidos. | [`planes-implementados`](planes-implementados/README.md) |
| Delitos de impacto | Sandbox | Comparativo de delitos SIEDCO, año actual frente al anterior. | [`delitos-de-impacto`](delitos-de-impacto/README.md) |
| Control y disuasión | Producción y sandbox | Cumplimiento por unidad, top y bottom 3 y planes más usados. | [`control-y-disuasion`](control-y-disuasion/README.md) |
| Microgerencia territorio | Producción y sandbox | Cumplimiento por estación, CAI y cuadrante; días, horas y mapa. | [`microgerencia-territorio`](microgerencia-territorio/README.md) |

El análisis tiene además la hoja `Biblioteca virtual`, que no se publica. La hoja `Hoja 2` del análisis de producción no se copió al sandbox porque está rota (ver documentación técnica).

## Validaciones funcionales del submódulo

- [ ] El módulo aparece en el menú principal y abre la hoja `Control y disuasión`. — No ejecutado en esta revisión.
- [ ] Las nueve pestañas del sandbox pueden activarse y muestran contenido distinto. — No ejecutado: la construcción se verificó por definición (sin errores en Quick), no visualmente.
- [ ] El selector de semana muestra la semana de domingo a sábado que contiene la fecha elegida. — No ejecutado.
- [ ] El filtro `UNIDAD` aplica en todas las hojas que lo muestran. — No ejecutado.
- [ ] Solo se ven los cuatro colores institucionales (`#002349`, `#0051A3`, `#BEEA01`, `#DFF0FC`). — Aprobado por definición el 2026-10-21; pendiente revisión visual.
- [ ] El tablero carga con un usuario lector. — No ejecutado.

## Validaciones de datos del submódulo

- [x] Las cifras de la semana 7 de 2026 (08 al 14 de febrero) se reproducen desde Athena con las reglas del reporte semanal. — Aprobado el 2026-10-21; diferencias menores al 0,2 % atribuibles a la fecha de corte.
- [x] Totales por unidad, metropolitanas, departamentos y regiones coinciden con el reporte. — Aprobado el 2026-10-21; las diferencias de la Región 1 se explican por DESAB.
- [x] Top 5 de distritos, estaciones, subestaciones, CAI y patrullas coinciden con el reporte. — Aprobado el 2026-10-21, en el mismo orden.
- [x] Delitos de impacto de 2025 coinciden con el reporte. — Aprobado el 2026-10-21.
- [ ] Semana 6 de 2026 coincide con el reporte. — Fallido: el reporte tiene cerca de 2.900 actividades no cumplidas que hoy no existen en GESCOV.
- [ ] Delitos de impacto de 2026 coinciden con el reporte. — Fallido por subregistro: el reporte se extrajo dos días después del corte.
- [ ] Policía (Oracle DISEC) frente a Athena. — No ejecutado: no se tuvo acceso a Oracle.

## Transformaciones que deben declararse

- La vista `USR_DISEC.V_GESCOV_DDHH` se copia completa a Athena cada dos días; el tablero lee una copia en SPICE que se recarga a diario.
- Cada fila es una actividad (punto) de un plan, no un plan: los indicadores llamados “planes” cuentan actividades, igual que el reporte semanal.
- En el sandbox solo cuentan los planes aprobados; los “Elaborados” se muestran aparte.
- El cumplimiento se calcula sobre actividades evaluadas: las pendientes de evaluación no se cuentan como incumplidas.
- La región de Policía no existe en la fuente: se asigna con un mapeo fijo tomado del reporte semanal.

## Aceptación y resultados

Aplican los criterios de [`validaciones.md`](../validaciones.md). Los resultados de la validación de octubre de 2026 están en la sección “Validaciones ejecutadas” de [`documentacion-tecnica.md`](documentacion-tecnica.md). No almacenar identificadores de planes o puntos, coordenadas ni filas completas de producción.
