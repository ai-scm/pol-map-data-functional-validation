# Hoja: SIVICC

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio SIVICC.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Confirmar que solo aparecen tablas SIVICC. — Bloqueado: falta inventario autorizado.
- [ ] Comparar fechas y particiones con Athena para el mismo corte. — Bloqueado: sin consulta Athena.
- [ ] Validar tablas sin actualización, fechas nulas y antigüedad negativa. — Bloqueado: requiere consulta completa.
- [ ] Comprobar que el filtro afecta tabla y gráfico. — Pendiente: no fue posible repetir la interacción embebida.
- [ ] Confirmar la etiqueta accesible de la tabla; durante el inventario se observó `CNP`. — Fallido: la etiqueta `CNP` no corresponde a la hoja SIVICC.

Registrar con la [plantilla común](../../registro-resultados.md).
