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

- [ ] Conciliar el total histórico y el número de bases de origen con Athena.
- [ ] Verificar que el máximo identifica la fecha y cantidad correctas.
- [ ] Comprobar que las agregaciones por fecha, día, semana, hora y sigla suman el total esperado.
- [ ] Validar que seleccionar una categoría filtra los demás visuales y que el restablecimiento recupera el total.
- [ ] Confirmar que valores nulos o `Otro` en sigla/origen están explicados por una regla de negocio.

Registrar el resultado con la [plantilla común](../../registro-resultados.md).
