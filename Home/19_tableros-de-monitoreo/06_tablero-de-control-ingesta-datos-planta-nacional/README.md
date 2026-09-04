# Tablero de control ingesta datos planta nacional

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

- [ ] Las dos hojas cargan y muestran contenido diferente.
- [ ] Los filtros de estado y días actualizan la hoja de archivos recibidos.
- [ ] Los estados de procesamiento, refresh y carga usan colores y etiquetas coherentes.
- [ ] Las tablas y KPIs corresponden a la misma semana y corte.
- [ ] No aparecen archivos o procesos fuera del alcance definido.

## Validaciones de datos del submódulo

- Conciliar archivos esperados, recibidos, duplicados y procesados.
- Validar unicidad por nombre lógico, fecha de información y checksum si está disponible.
- Comparar último refresh exitoso con la actualización de Athena.
- Verificar crecimiento del dataset y cantidad cargada en IAPOL frente al origen.
- Documentar reprocesos, archivos tardíos, exclusiones y fallos de ETL.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md) y [`registro-resultados.md`](../registro-resultados.md). Las dos hojas deben compartir una semana/corte comparable y toda diferencia debe tener causa documentada.
