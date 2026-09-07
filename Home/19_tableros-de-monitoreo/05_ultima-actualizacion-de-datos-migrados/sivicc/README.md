# Hoja: SIVICC

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio SIVICC.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [x] Confirmar que solo aparecen tablas SIVICC. — Aprobado
- [x] Comparar fechas y particiones con Athena para el mismo corte. — Aprobado: consulta Athena.
- [x] Validar tablas sin actualización, fechas nulas y antigüedad negativa. — Aprobado
- [x] Comprobar que el filtro afecta tabla y gráfico. — Pendiente: no fue posible repetir la interacción embebida.


Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
