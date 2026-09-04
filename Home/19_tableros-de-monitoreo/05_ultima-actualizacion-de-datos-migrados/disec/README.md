# Hoja: DISEC

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio DISEC.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Confirmar que solo aparecen tablas DISEC. — Bloqueado: falta inventario autorizado.
- [ ] Conciliar inventario, última actualización y días de antigüedad con Athena. — Bloqueado: sin consulta Athena.
- [ ] Verificar que el filtro `Tabla` modifica ambos visuales. — Pendiente: no fue posible repetir la interacción embebida.
- [ ] Validar umbrales, colores y orden del gráfico. — Bloqueado: análisis y reglas no disponibles.
- [ ] Confirmar la etiqueta accesible de la tabla; durante el inventario se observó `CNP`. — Fallido: la etiqueta `CNP` no corresponde a la hoja DISEC.

Registrar con la [plantilla común](../../registro-resultados.md).
