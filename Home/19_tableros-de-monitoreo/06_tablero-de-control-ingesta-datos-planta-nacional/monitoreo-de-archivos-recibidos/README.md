# Hoja: Monitoreo de archivos recibidos

## Propósito

Supervisa la llegada de reportes, su estado, duplicidad y frecuencia diaria.

## Controles observados

- `Estado`, con selección inicial `Todo`.
- `Días a visualizar`, con valor observado `20`.

## Componentes observados

- Tabla `Registro de control`.
- KPI `Cantidad de reportes duplicados recibidos`.
- Medidor `Reportes recibidos semana actual`.
- Gráfico `Frecuencia diaria`.

## Pruebas específicas

- [x] Conciliar archivos esperados y recibidos para la misma ventana. — Aprobado.
- [x] Comprobar que `Estado` y `Días a visualizar` actualizan todos los visuales. — Aprobado el 2026-09-04; ambos filtros refrescaron la hoja y se restablecieron.
- [x] Verificar que el medidor semanal usa el calendario operativo correcto. — Aprobado.

No conservar archivos productivos ni nombres que revelen información sensible. Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
