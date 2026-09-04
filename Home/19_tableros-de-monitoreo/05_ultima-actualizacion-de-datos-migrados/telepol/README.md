# Hoja: TELEPOL

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio TELEPOL.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Confirmar que solo aparecen tablas TELEPOL. — Bloqueado: falta inventario autorizado.
- [ ] Conciliar el inventario y las fechas con Athena. — Bloqueado: sin consulta Athena.
- [ ] Validar la antigüedad según zona horaria, calendario y periodicidad esperada. — Bloqueado: fórmula y reglas no disponibles.
- [ ] Comprobar filtro, colores, umbrales y restablecimiento. — Pendiente: no fue posible repetir la interacción embebida.
- [ ] Confirmar la etiqueta accesible de la tabla; durante el inventario se observó `CNP`. — Fallido: la etiqueta `CNP` no corresponde a la hoja TELEPOL.

Registrar con la [plantilla común](../../registro-resultados.md).
