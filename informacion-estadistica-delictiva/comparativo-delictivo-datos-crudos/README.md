# 02. Comparativo Delictivo (Datos crudos)

## Objetivo

Compara el comportamiento delictivo registrado en SIEDCO entre un rango de fechas y el mismo rango del año anterior, por región, unidad, municipio, estación y cuadrante, con caracterización del delito y de la víctima. Desde octubre de 2026 incluye además la actividad operativa: capturas e incautaciones.

## Ruta funcional

`Home > Información Estadística Delictiva > 02. Comparativo Delictivo (Datos crudos)`

## Documentación técnica

Los activos, la fuente, los filtros, las medidas, los cambios aplicados en octubre de 2026 y los asuntos pendientes están descritos en [`documentacion-tecnica.md`](documentacion-tecnica.md).

Las consultas para medir las novedades de calidad de datos en la fuente de la Policía están en [`sql/policia.sql`](sql/policia.sql).

## Hojas

| Hoja visible | Propósito | Documento |
|---|---|---|
| Comparativo Delictivo (Datos crudos) | Indicadores y comparativos de delitos, capturas e incautaciones. | [`comparativo-delictivo`](comparativo-delictivo/README.md) |
| Mapa por delito | Ubicación geográfica de los hechos del periodo, con filtros por territorio y características del hecho. | [`mapa-por-delito`](mapa-por-delito/README.md) |

## Validaciones funcionales del submódulo

- [x] El submódulo aparece en la ruta indicada y abre la hoja `Comparativo Delictivo (Datos crudos)`. — Aprobado el 2026-10-07.
- [x] Las dos pestañas pueden activarse y muestran contenido distinto. — Aprobado el 2026-10-07.
- [x] Los controles de la fila superior (`Región`, `Unidad`, `Ciudad-Municipio`, `Estación`, `Cuadrantes`, `Zona`, `Género`) filtran todos los visuales de la hoja. — Aprobado el 2026-10-07.
- [x] En `Mapa por delito`, cada control muestra solo los valores relevantes según los demás (cascada). — Aprobado el 2026-10-07 con `Unidad = M. BOGOTÁ`.
- [x] El control `CAI` lista CAI y la opción `SIN CAI`; el control `Cuadrante` lista cuadrantes. — Aprobado el 2026-10-07 en `M. BOGOTÁ` y `M. SOACHA`.
- [x] El control `Tipo de unidad` restringe la lista de `Unidad` a metropolitanas o departamentos. — Aprobado el 2026-10-07.
- [x] `Delito de análisis` conserva la selección al cambiar de hoja y no afecta las secciones de capturas e incautaciones. — Aprobado el 2026-10-07.
- [x] El tablero publicado abre con todos los controles en `Todo`. — Aprobado el 2026-10-07 al desplegar.
- [ ] El tablero carga con un usuario lector (no editor) usando el tema `IAPOL · azul y lima`. — No ejecutado.
- [ ] Tiempo de carga aceptable de la hoja principal (62 visuales). — No ejecutado.

## Validaciones de datos del submódulo

- [x] La fuente de la Policía (Oracle) y Athena coinciden en total y por tipo de conducta. — Aprobado el 2026-10-07: 2.442.444 registros en ambas.
- [x] Las cifras de los indicadores se reproducen desde la fuente con los filtros del tablero. — Aprobado el 2026-10-07 con dos casos (ver documentación técnica).
- [x] Las cifras de capturas e incautaciones coinciden con la referencia entregada por la Policía. — Aprobado el 2026-10-07; las diferencias corresponden a la fecha de corte.
- [x] Conciliación del tablero contra las capas SIEDCO del mapa para una unidad. — Aprobado el 2026-10-09 con `M. SOACHA`: todas las diferencias quedaron explicadas.
- [ ] Regla oficial de conteo cuando `Delito de análisis = Todo`. — Bloqueado: requiere definición de la Policía.
- [ ] Jerarquía oficial unidad–municipio. — Bloqueado: requiere tabla de referencia de la Policía.

## Transformaciones que deben declararse

Aunque el tablero se denomina “datos crudos”, entre la fuente y la visualización ocurren estas transformaciones:

- La carga convierte todas las columnas a texto y la vista de Athena las vuelve a tipar (fecha, edad, cantidad, coordenadas).
- La vista agrega columnas derivadas: semana, turno clasificado por hora, grupo de edad y lugar clasificado.
- El conjunto de datos agrega dos columnas calculadas: `tipo_unidad` y `cai`.
- Los visuales de delitos aplican el filtro fijo `tipo_lista_conducta = 'DE'`.

## Aceptación y resultados

Aplican los criterios de [`validaciones.md`](../../tableros-de-monitoreo/validaciones.md). Los resultados de las validaciones de octubre de 2026 están en la sección “Validaciones ejecutadas” de [`documentacion-tecnica.md`](documentacion-tecnica.md). No almacenar identificadores de hechos, coordenadas puntuales ni filas completas de producción.
