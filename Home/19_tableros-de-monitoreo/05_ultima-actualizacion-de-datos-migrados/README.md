# Última actualización de datos migrados

## Objetivo

Controla la antigüedad de actualización de tablas migradas, agrupadas por dominio o sistema.

## Ruta funcional

`Home > Tableros de Monitoreo > Última actualización de datos migrados`

## Hojas

| Hoja visible | Documento |
|---|---|
| CNP | [`cnp`](cnp/README.md) |
| DISEC | [`disec`](disec/README.md) |
| GEOPOL | [`geopol`](geopol/README.md) |
| SIVICC | [`sivicc`](sivicc/README.md) |
| TELEPOL | [`telepol`](telepol/README.md) |

Todas las hojas observadas incluyen el filtro `Tabla`, una tabla de detalle y el gráfico `Cantidad de tablas por días sin actualizar`.

## Validaciones funcionales del submódulo

- [ ] Las cinco hojas pueden activarse y conservan el contexto de dominio correcto.
- [ ] El filtro `Tabla` restringe la tabla y el gráfico.
- [ ] La antigüedad se actualiza de forma coherente con la fecha/hora actual y la zona horaria definida.
- [ ] Los colores y umbrales de antigüedad coinciden con las reglas operativas.
- [ ] No aparecen tablas pertenecientes a otro dominio.

## Validaciones de datos del submódulo

- Conciliar cantidad de tablas esperadas por dominio.
- Comparar última partición/actualización en Athena con la fecha mostrada.
- Validar tablas sin actualización, fechas nulas y antigüedad negativa.
- Documentar exclusiones de tablas, periodicidades no diarias y ventanas de mantenimiento.

## Hallazgo de accesibilidad a revisar

En la inspección, la etiqueta accesible de la tabla permaneció como `CNP` al cambiar entre las cinco hojas. Verificar si es solo una etiqueta reutilizada o un título incorrecto y corregirlo si afecta accesibilidad o interpretación.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md) y [`registro-resultados.md`](../registro-resultados.md). Una hoja no se aprueba si mezcla tablas de otro dominio o si la antigüedad no puede reconciliarse con Athena.
