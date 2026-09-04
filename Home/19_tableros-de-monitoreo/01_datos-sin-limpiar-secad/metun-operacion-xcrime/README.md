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

- [ ] Confirmar fórmula, unidad y redondeo de los tiempos. — Bloqueado: fórmula fuente no disponible.
- [ ] Excluir o justificar tiempos negativos, nulos y extremos. — Bloqueado: requiere consulta completa.
- [ ] Conciliar llamadas registradas con Athena para el mismo corte. — Bloqueado: sin consulta ni corte de Athena.
- [ ] Validar el ranking de patrullas y su mínimo de observaciones. — Bloqueado: criterio mínimo no documentado.
- [ ] Conciliar latitud cero y otros errores geográficos. — Bloqueado: sin consulta Athena.
- [ ] Verificar que la tabla de detalle corresponde al punto o patrulla seleccionados. — Bloqueado: falta muestra anonimizada.

No almacenar narrativas, teléfonos, coordenadas puntuales ni identificadores operativos. Registrar con la [plantilla común](../../registro-resultados.md).
