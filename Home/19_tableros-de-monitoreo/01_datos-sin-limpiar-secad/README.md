# Datos Sin Limpiar (SECAD)

## Objetivo

Presenta datos SECAD sin modificación en el Data Lake para analizar volumen histórico y reciente, prioridad, ubicación, patrullas, llamantes y métricas operativas de METUN.

## Ruta funcional

`Home > Tableros de Monitoreo > Datos Sin Limpiar (SECAD)`

## Documentación técnica

Los filtros, campos, agregaciones y asuntos pendientes están descritos en [`documentacion-tecnica.md`](documentacion-tecnica.md).

## Hojas

| Hoja visible | Propósito | Documento |
|---|---|---|
| Historia | Perfil histórico de volumen y origen. | [`historia`](historia/README.md) |
| Últimos Días | Seguimiento reciente parametrizado por días y sigla. | [`ultimos-dias`](ultimos-dias/README.md) |
| Prioridad | Distribución temporal de prioridades. | [`prioridad`](prioridad/README.md) |
| Mapa | Distribución geográfica y detalle. | [`mapa`](mapa/README.md) |
| Patrullas | Llamadas y tiempos o distribución por patrulla y sigla. | [`patrullas`](patrullas/README.md) |
| Llamante | Agregación por número de teléfono y origen. | [`llamante`](llamante/README.md) |
| METUN - OPERACIÓN XCRIME | Tiempos de atención y llegada, patrullas y calidad geográfica. | [`metun-operacion-xcrime`](metun-operacion-xcrime/README.md) |

## Validaciones funcionales del submódulo

- [x] El submódulo aparece en la ruta indicada y abre la hoja `Historia`. — Aprobado el 2026-09-04.
- [x] Las siete pestañas pueden activarse y muestran contenido distinto. — Aprobado el 2026-09-04.
- [x] Los controles `Días` y `Sigla` afectan únicamente el alcance esperado. — Aprobado: se probaron 30→7→30 y Todo→METUN→Todo, con refresco de visuales.
- [ ] Restablecer el dashboard elimina selecciones y filtros cruzados. — Pendiente: se restablecieron los controles probados, pero no todas las selecciones cruzadas posibles.
- [x] Los títulos, leyendas y unidades coinciden con la hoja activa. — Aprobado visualmente; la exactitud de las unidades calculadas requiere la fuente.
- [ ] Las tablas de detalle corresponden a la selección efectuada. — Bloqueado: requiere llave funcional y muestra anonimizada.

## Validaciones de datos del submódulo

- Conciliar totales por fecha, sigla y base de datos de origen.
- Validar duplicados con la llave funcional SECAD autorizada.
- Controlar nulos en fecha, código final, sigla y base de origen.
- Validar latitud/longitud, coordenadas cero y registros sin coordenadas.
- Para tiempos de llegada y atención, verificar unidad, zona horaria y tratamiento de valores negativos o extremos.

## Transformaciones que deben declararse

Aunque el tablero se denomina “sin limpiar”, se debe confirmar si la ingesta aplica conversión de tipos, normalización de fechas, particionamiento, exclusión de archivos, deduplicación técnica o reemplazo de nulos.

## Aceptación y resultados

Aplican los criterios de [`validaciones.md`](../validaciones.md). Registrar cada hoja mediante [`registro-resultados.md`](../registro-resultados.md). No almacenar teléfonos, narrativas de llamadas ni filas completas de producción.
