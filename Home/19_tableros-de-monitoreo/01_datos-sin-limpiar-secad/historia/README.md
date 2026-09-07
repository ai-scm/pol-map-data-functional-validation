# Hoja: Historia

## Propósito

Resume el comportamiento histórico de los registros SECAD sin modificación, sus fuentes de origen y su distribución temporal.

## Componentes observados

- Indicadores `Cuenta Total`, `Número de bases de datos origen` y `Máximo`.
- `Cuenta por Fecha`.
- `Cuenta por Día Sigla`.
- `Cuenta por BD Origen`.
- `Cuenta por Día Semana`.
- `Cuenta por Semana del Año`.
- `Cuenta por Hora`.

No se observaron controles de filtro propios en esta hoja.

## Pruebas específicas

- [x] Conciliar el total histórico y el número de bases de origen con Athena. — Bloqueado: sin consulta ni corte de Athena.
- [x] Validar que seleccionar una categoría filtra los demás visuales y que el restablecimiento recupera el total. — Interacción cruzada específica.

Registrar el resultado con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).