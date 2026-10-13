# Hoja: Mapa por delito

## Propósito

Ubica geográficamente los hechos del rango de fechas y permite filtrarlos por territorio y por características del hecho.

## Controles observados

- Fechas: `Fecha inicio` y `Fecha fin`.
- Territorio: `Región`, `Tipo de unidad`, `Unidad`, `Municipio`, `Estación`, `CAI` y `Cuadrante`.
- Hecho: `Delito de análisis`, `Modalidad`, `Arma`, `Sitio`, `Causas`, `Mes`, `Día de la semana`, `Día`, `Hora` y `Turno`.
- Persona: `Género` y `Nacionalidad`.

Todos los controles de lista muestran solo los valores relevantes según los demás, salvo `Género` y `Tipo de unidad`, que tienen valores fijos.

## Componentes observados

- Encabezado.
- `Mapa por delito`.

## Pruebas específicas

- [x] Con `Unidad = M. BOGOTÁ`, `Estación`, `CAI` y `Municipio` listan solo valores de esa unidad. — Aprobado el 2026-10-07.
- [x] `CAI` lista nombres de CAI y la opción `SIN CAI`; no aparece `NULL`. — Aprobado el 2026-10-07.
- [x] `Tipo de unidad = METROPOLITANA` deja en `Unidad` solo las que empiezan por `M.`; `DEPARTAMENTO`, las demás. — Aprobado el 2026-10-07.
- [x] Las selecciones de territorio hechas en la hoja principal se conservan en esta hoja. — Aprobado el 2026-10-07.
- [ ] Conciliar los puntos del mapa con el total de la hoja principal para el mismo filtro, descontando los registros con latitud en cero. — No ejecutado.
- [ ] En unidades distintas de Bogotá, `CAI` lista solo CAI. — Fallido: la fuente trae subestaciones, estaciones y códigos de cuadrante en esa columna (novedad N09).

Un valor ya seleccionado permanece visible en su lista aunque deje de ser relevante: si se elige una metropolitana y luego `Tipo de unidad = DEPARTAMENTO`, la metropolitana sigue marcada hasta que se desmarque. Es el comportamiento estándar de Quick.

No almacenar coordenadas puntuales en evidencias. Las reglas están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
