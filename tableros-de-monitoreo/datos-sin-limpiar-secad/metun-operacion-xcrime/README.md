# Hoja: METUN - OPERACIÓN XCRIME

## Propósito

Monitorea tiempos de atención y llegada, desempeño de patrullas, volumen de llamadas y calidad de coordenadas para METUN.

## Componentes observados

- `Tiempo Promedio de Llegada por Fecha`.
- `Promedio de Atención por Fecha`.
- `Promedio de Minutos de Llegada por Patrulla`.
- Patrullas con tiempo de llegada más bajo y más alto.
- `Llamadas Registradas SECAD`.
- `Llamadas con Latitud Cero`.
- Tabla `Detalle Llamadas`.

## Pruebas específicas

- [x] Confirmar fórmula, unidad y redondeo de los tiempos. — Aprobado
- [x] Conciliar llamadas registradas con Athena para el mismo corte. — Aprobado: consulta ni corte de Athena.
- [x] Validar el ranking de patrullas y su mínimo de observaciones. — Aprobado
- [x] Conciliar latitud cero y otros errores geográficos. — Aprobado: consulta Athena.

No almacenar narrativas, teléfonos, coordenadas puntuales ni identificadores operativos. Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
