# Tablero de control ingesta datos planta nacional

## Documentación técnica

Los conjuntos de datos observados, controles, campos de las tablas, lógica disponible y asuntos pendientes están en [`documentacion-tecnica.md`](documentacion-tecnica.md).

## Objetivo

Supervisa la recepción de archivos y la carga de datos en IAPOL para el proceso de planta nacional.

## Ruta funcional

`Home > Tableros de Monitoreo > Tablero de control ingesta datos planta nacional`

## Hojas

| Hoja visible | Propósito | Documento |
|---|---|---|
| Monitoreo de archivos recibidos | Recepción, duplicados, frecuencia y estado de reportes. | [`monitoreo-de-archivos-recibidos`](monitoreo-de-archivos-recibidos/README.md) |
| Monitoreo carga de datos IAPOL | Procesamiento ETL, refresh y crecimiento del dataset. | [`monitoreo-carga-de-datos-iapol`](monitoreo-carga-de-datos-iapol/README.md) |

## Validaciones funcionales del submódulo

- [x] Las dos hojas cargan y muestran contenido diferente. — Aprobado el 2026-09-04.
- [x] Los filtros de estado y días actualizan la hoja de archivos recibidos. — Aprobado: 20→10→20 y selección de estado con posterior restablecimiento.
- [x] Los estados de procesamiento, refresh y carga usan colores y etiquetas coherentes. — Aprobado visualmente; la regla de colores permanece pendiente.

## Validaciones de datos del submódulo

- Conciliar archivos esperados, recibidos, duplicados y procesados.
- Validar unicidad por nombre lógico, fecha de información y checksum si está disponible.
- Comparar último refresh exitoso con la actualización de Athena.
- Verificar crecimiento del dataset y cantidad cargada en IAPOL frente al origen.
- Documentar reprocesos, archivos tardíos, exclusiones y fallos de ETL.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md). Los resultados de la ejecución realizada están en [`ejecucion-validaciones-2026-09-04.md`](../ejecucion-validaciones-2026-09-04.md). Las dos hojas deben compartir una semana/corte comparable y toda diferencia debe tener causa documentada.
