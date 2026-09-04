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

- [ ] Verificar inclusividad de las fechas inicial y final y su zona horaria.
- [ ] Confirmar que solo empleados activos (`AC`) participan del cálculo.
- [ ] Conciliar usuarios únicos e interacciones con Athena.
- [ ] Validar el Top 10, incluidos orden, empates y unidades nulas.
- [ ] Comprobar que fecha y sigla modifican todos los visuales.
- [ ] Detectar eventos duplicados o generados por cuentas técnicas.

Registrar únicamente resultados agregados mediante la [plantilla común](../../registro-resultados.md).
