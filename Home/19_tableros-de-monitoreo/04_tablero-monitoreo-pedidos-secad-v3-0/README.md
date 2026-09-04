# Tablero Monitoreo Pedidos SECAD v3.0

## Objetivo

Permite vigilar la actualización de pedidos SECAD y consultar un reporte de registros operativos.

## Ruta funcional

`Home > Tableros de Monitoreo > Tablero Monitoreo Pedidos SECAD v3.0`

## Estructura observada

No se expusieron pestañas de hojas. La vista única contiene:

- KPI `Ultima Actualizacion (UP)`.
- KPI `Ultima Actualizacion (Down)`.
- Tabla `Reporte Pedidos Secad`.

## Validaciones funcionales

- [ ] El tablero carga los dos KPI y la tabla sin errores.
- [ ] Las fechas de actualización usan zona horaria y formato definidos.
- [ ] La tabla corresponde al estado o periodo representado por los KPI.
- [ ] La selección de una fila no mezcla datos de otro pedido.
- [ ] El alcance territorial y temporal es el autorizado.

## Validaciones de datos

- Comparar la última actualización ascendente y descendente con la ejecución de ingesta correspondiente.
- Conciliar el total de pedidos entre Policía, Athena y la tabla.
- Validar duplicados, fechas nulas, unidad/sigla, estado y coordenadas.
- Confirmar tratamiento de coordenadas en cero y valores fuera del rango de Colombia.
- Documentar exclusiones, homologaciones y deduplicación aplicadas al reporte.

## Manejo de información sensible

La tabla puede contener detalle operativo, ubicación, teléfonos o narrativas. No incluir filas, capturas sin recortar ni textos de llamadas en el repositorio. Las muestras deben anonimizarse.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md) y [`registro-resultados.md`](../registro-resultados.md). La vista se aprueba únicamente cuando los KPI y la tabla comparten el mismo corte y las diferencias están justificadas.
