# Hoja: GEOPOL

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio GEOPOL.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Confirmar que solo aparecen tablas GEOPOL. — Bloqueado: falta inventario autorizado.
- [ ] Conciliar inventario y última partición disponible con Athena. — Bloqueado: sin consulta Athena.
- [ ] Validar el cálculo de días y periodicidades especiales. — Bloqueado: fórmula y calendario no disponibles.
- [ ] Comprobar el filtro `Tabla` y el restablecimiento de selecciones. — Pendiente: no fue posible repetir la interacción embebida.
- [ ] Confirmar la etiqueta accesible de la tabla; durante el inventario se observó `CNP`. — Fallido: la etiqueta `CNP` no corresponde a la hoja GEOPOL.

Registrar con la [plantilla común](../../registro-resultados.md).
