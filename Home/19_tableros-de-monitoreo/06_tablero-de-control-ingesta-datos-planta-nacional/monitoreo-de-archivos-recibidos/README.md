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

- [ ] Conciliar archivos esperados y recibidos para la misma ventana.
- [ ] Validar la definición de duplicado y su llave: nombre lógico, fecha y/o checksum.
- [ ] Comprobar que `Estado` y `Días a visualizar` actualizan todos los visuales.
- [ ] Verificar que el medidor semanal usa el calendario operativo correcto.
- [ ] Identificar archivos tardíos, faltantes, reprocesados o con error.

No conservar archivos productivos ni nombres que revelen información sensible. Registrar con la [plantilla común](../../registro-resultados.md).
