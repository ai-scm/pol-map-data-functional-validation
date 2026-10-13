# Hoja: Comparativo Delictivo (Datos crudos)

## Propósito

Compara los delitos de un rango de fechas con el mismo rango del año anterior, por territorio y por características del hecho y de la víctima. Incluye las secciones de capturas e incautaciones.

## Controles observados

- Fila superior: `Región`, `Unidad`, `Ciudad-Municipio`, `Estación`, `Cuadrantes`, `Zona` y `Género`.
- Panel del comparativo: `Delito de análisis`, `Desde` y `Hasta`.
- Junto a sus secciones: `Modalidad`, `Tipo de arma`, `Lugar`, `Causa`, `Nacionalidad`, `Día de la semana`, `Turno`, `Hora`, `Mes` y `Día`.
- En las tres gráficas de homicidio: un control de año por gráfica.

## Componentes observados

### Delitos

- Indicadores: `TOTAL AÑO ANTERIOR`, año anterior y año actual, `DIFERENCIA`, porcentaje de variación, `PRONÓSTICO ANUAL` y `PROMEDIO DIARIO`.
- `Estadística por regiones`.
- `Estadística por Unidad`, `Estadística por Ciudad`, `Estadística por Estación` y `Estadística por CAI'S - Subestaciones`.
- Tipología del delito: `Modalidad`, `Tipo de arma`, `Tipo de lugar` y `Posible causa`.
- Caracterización del delito: zona (urbana y rural), género, `Nacionalidad` y `Rango de edad víctimas`.
- Comportamiento frecuencial: días de la semana, `Turno de servicio`, 24 horas del día, meses del año y comportamiento diario.
- Homicidio: por días de la semana, variación semanal y variación cada 3 semanas.

### Capturas

- Indicadores: capturas del periodo con variación frente al año anterior, en flagrancia, por orden judicial y porcentaje en flagrancia.
- `Capturas por mes`.
- `Capturas por rango de edad`.
- `Capturas por región o dirección que captura`.
- `Capturas por unidad que captura`.
- `Capturas por unidad: flagrancia y orden judicial`.
- `Capturas por estación`.
- `Capturas por CAI – cuadrante – dependencia que captura`.

### Caracterización de las capturas

- `Capturas por delito`.
- `Capturas por género` y `Capturas por zona`.
- `Situación jurídica de los capturados`.

### Detalle de las incautaciones

- Panel de droga con imagen: cocaína, marihuana, base de coca, basuco y heroína.
- `Droga incautada por mes (kg), por tipo de droga`.
- `Droga incautada por unidad (kg)`.
- `Armas de fuego incautadas por tipo de arma`.
- `Incautaciones por tipo de bien`.
- `Detalle por clase de bien incautado`.

## Pruebas específicas

- [x] Reproducir año anterior, año actual y diferencia desde la fuente para una unidad y un delito. — Aprobado el 2026-10-07 (`M. BOGOTÁ`, homicidio doloso: 883 y 818).
- [x] Combinar unidad, estación, género y delito y reproducir la cifra desde la fuente. — Aprobado el 2026-10-07 (2.290 y 2.263).
- [x] Al elegir una unidad, la lista de `Estación` muestra solo las de esa unidad. — Aprobado el 2026-10-07.
- [x] `Delito de análisis` no cambia las cifras de capturas ni de incautaciones. — Aprobado el 2026-10-07.
- [x] Las cifras de capturas por estación coinciden con la referencia de la Policía. — Aprobado el 2026-10-07; diferencias atribuibles a la fecha de corte.
- [x] El panel de droga muestra cada cifra junto a su ícono. — Aprobado visualmente el 2026-10-07 tras ajustar la altura de las filas.
- [ ] Al elegir una unidad, la lista de `Ciudad-Municipio` muestra solo municipios de esa unidad. — Fallido: aparecen municipios de otras unidades por registros inconsistentes en la fuente (novedad N06). Con un delito sin esos registros la lista sí queda correcta.
- [ ] El total con `Delito de análisis = Todo` corresponde a hechos únicos. — Fallido: un hecho registrado en varias temáticas se cuenta una vez por cada una (novedad N12).

No almacenar identificadores de hechos ni filas completas en evidencias. Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
