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

- [ ] Confirmar fórmula, unidad y redondeo de los tiempos.
- [ ] Excluir o justificar tiempos negativos, nulos y extremos.
- [ ] Conciliar llamadas registradas con Athena para el mismo corte.
- [ ] Validar el ranking de patrullas y su mínimo de observaciones.
- [ ] Conciliar latitud cero y otros errores geográficos.
- [ ] Verificar que la tabla de detalle corresponde al punto o patrulla seleccionados.

No almacenar narrativas, teléfonos, coordenadas puntuales ni identificadores operativos. Registrar con la [plantilla común](../../registro-resultados.md).
