# Hoja: CNP

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio CNP.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle `CNP`.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [x] Conciliar el inventario de tablas CNP con el catálogo autorizado. — Aprobado
- [x] Comparar la última partición o actualización de Athena con la fecha mostrada. — Aprobado
- [x] Validar el cálculo de días, zona horaria y tratamiento de fines de semana. — Aprobado
- [x] Comprobar que el filtro `Tabla` actualiza tabla y gráfico. — Aprobado

Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
