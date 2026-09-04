# Hoja: CNP

## Propósito

Controla la última actualización y la antigüedad de las tablas del dominio CNP.

## Componentes observados

- Filtro `Tabla`, con selección inicial `Todo`.
- Tabla de detalle `CNP`.
- `Cantidad de tablas por días sin actualizar`.

## Pruebas específicas

- [ ] Conciliar el inventario de tablas CNP con el catálogo autorizado. — Bloqueado: catálogo no suministrado.
- [ ] Comparar la última partición o actualización de Athena con la fecha mostrada. — Bloqueado: sin consulta Athena.
- [ ] Validar el cálculo de días, zona horaria y tratamiento de fines de semana. — Bloqueado: análisis y fórmula no localizados.
- [ ] Comprobar que el filtro `Tabla` actualiza tabla y gráfico. — Pendiente: no fue posible repetir la interacción en el contenido embebido.
- [ ] Justificar tablas nulas, excluidas o con periodicidad no diaria. — Bloqueado: reglas no suministradas.

Registrar con la [plantilla común](../../registro-resultados.md).
