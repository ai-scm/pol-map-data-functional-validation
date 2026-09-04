# Hoja: CNP

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio CNP.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle `CNP`.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Conciliar el inventario de tablas CNP con el catálogo autorizado.
- [ ] Comparar la última partición o actualización de Athena con la fecha mostrada.
- [ ] Validar el cálculo de días, zona horaria y tratamiento de fines de semana.
- [ ] Comprobar que el filtro `Tabla` actualiza tabla y gráfico.
- [ ] Justificar tablas nulas, excluidas o con periodicidad no diaria.

Registrar con la [plantilla común](../../registro-resultados.md).
