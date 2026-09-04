# Hoja: SIVICC

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio SIVICC.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Confirmar que solo aparecen tablas SIVICC.
- [ ] Comparar fechas y particiones con Athena para el mismo corte.
- [ ] Validar tablas sin actualización, fechas nulas y antigüedad negativa.
- [ ] Comprobar que el filtro afecta tabla y gráfico.
- [ ] Confirmar la etiqueta accesible de la tabla; durante el inventario se observó `CNP`.

Registrar con la [plantilla común](../../registro-resultados.md).
