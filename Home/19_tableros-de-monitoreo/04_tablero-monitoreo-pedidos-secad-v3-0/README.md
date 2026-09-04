# Tablero Monitoreo Pedidos SECAD v3.0

## Documentación técnica

La lógica confirmada de los KPI `UP` y `DOWN`, los campos del reporte y los hallazgos de filtros están en [`documentacion-tecnica.md`](documentacion-tecnica.md).

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

- [x] El tablero carga los dos KPI y la tabla sin errores. — Aprobado el 2026-09-04.
- [ ] Las fechas de actualización usan zona horaria y formato definidos. — Bloqueado: zona horaria y unidad de `intervalo_fecha_hora` no están documentadas.
- [ ] La tabla corresponde al estado o periodo representado por los KPI. — Bloqueado: UP y DOWN no comparten el filtro de año actual y falta una muestra de conciliación.
- [ ] La selección de una fila no mezcla datos de otro pedido. — Bloqueado: falta llave funcional y muestra anonimizada.
- [ ] El alcance territorial y temporal es el autorizado. — Bloqueado: falta lista completa de orígenes y regla de alcance.

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
