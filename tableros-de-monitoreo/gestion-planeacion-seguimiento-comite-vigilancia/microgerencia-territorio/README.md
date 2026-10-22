# Hoja: Microgerencia territorio

## Propósito

Detalle territorial y operativo del cumplimiento: por estación, CAI y cuadrante, por plan, mes, día y hora, con mapa de puntos. Versión: producción y sandbox.

## Controles observados

- `FECHA INCIAL`, `FECHA FINAL`, `UNIDAD`, `ESTACIÓN`, `CUADRANTE` y `CLASE ACTIVIDAD`, iguales a los de `Control y disuasión`.
- `Estado de cumplimiento` y `Seleccione el día de la semana`, junto a las gráficas por hora.

## Componentes observados

- Encabezado: `MICROGERENCIA TERRITORIO`, `COMITE DE VIGILANCIA`, `CORTE` y `PROYECCIÓN PLANES`.
- KPIs: planearon, planes cumplidos y planes no cumplidos.
- Tablas: tipo de plan, plan semanal, plan extraordinario, zona, cantidad de planes por mes y por día, plan más implementado, mes y día con más planes.
- Porcentajes: planes cumplidos, no cumplidos y plan más implementado; estación de Policía con mayor y con menor cumplimiento.
- Tablas por estación, por CAI, por cuadrante y de planes preventivos implementados, con semáforo.
- `MAPA DE PLANES PREVENTIVOS`.
- Mapa de calor día × hora y barras por hora, coloreadas por estado de cumplimiento.

## Diferencias entre producción y sandbox

| Aspecto | Producción | Sandbox |
|---|---|---|
| Días de la semana | Desplazados un día (el domingo aparece como LUNES) | Correctos |
| Filtro de día de la gráfica por hora | `1 - LUNES`, que es domingo | `2 - LUNES` |
| Semáforo de las tablas por estación, CAI y cuadrante | Degradado de rojo a verde | Cuatro niveles del manual |
| Mapa de calor y barras | Verdes | Celeste a lima; cumple en lima y no cumple en navy |
| Diseño | Columnas de 700 y 704 px, recuadros solapados | Márgenes y columnas alineados |

## Pruebas específicas

- [ ] La tabla `CANTIDAD PLANES POR DÍA` nombra correctamente los días. — Fallido en producción por el error de `DIA`; corregido en el sandbox, pendiente verificación visual.
- [ ] El mapa colorea los puntos de forma legible. — Fallido: colorea por `plan_descripcion` (74 valores) y con cuatro colores la leyenda no distingue los planes. Se propuso colorear por estado de cumplimiento.
- [ ] Mapa de calor y barras por hora usan solo la paleta institucional. — No ejecutado visualmente.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
