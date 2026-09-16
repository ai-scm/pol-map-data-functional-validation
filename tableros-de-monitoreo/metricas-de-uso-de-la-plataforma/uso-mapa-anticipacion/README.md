# Hoja: Uso mapa anticipacion

## Propósito

Mide usuarios e interacciones de la herramienta de mapa de anticipación por fecha y sigla.

## Controles observados

- Condición visible `estado_empleado es igual a AC`.
- `Fecha Inicio` y `Fecha Fin`.
- `SIGLA`, con selección inicial `Todo`.

## Componentes observados

- `Número de usuarios`.
- Cantidad de interacciones al mapa.
- Top 10 de unidades con mayor interacción.
- Interacciones por sigla y fecha.
- Sección `Interacciones diarias`.

## Pruebas específicas

- [x] Confirmar que solo empleados activos (`AC`) participan del cálculo. — Aprobado en configuración por filtro global y control visible.
- [ ] Conciliar usuarios únicos e interacciones con Athena. — Bloqueado: sin consulta ni corte de Athena.
- [x] Comprobar que fecha y sigla modifican todos los visuales. — Parcial: los controles y filtros están configurados; no se ejecutaron todos los valores de combinación.


Registrar únicamente resultados agregados mediante la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
