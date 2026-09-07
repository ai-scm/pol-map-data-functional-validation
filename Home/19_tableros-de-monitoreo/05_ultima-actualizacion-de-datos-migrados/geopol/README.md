# Hoja: GEOPOL

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio GEOPOL.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [x] Confirmar que solo aparecen tablas GEOPOL. — Aprobado
- [x] Conciliar inventario y última partición disponible con Athena. — Aprobado: consulta Athena.
- [x] Validar el cálculo de días y periodicidades especiales. — Aprobado
- [x] Comprobar el filtro `Tabla` y el restablecimiento de selecciones. — Aprobado

Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
