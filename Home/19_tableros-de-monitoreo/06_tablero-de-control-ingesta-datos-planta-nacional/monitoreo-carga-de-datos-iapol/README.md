# Hoja: Monitoreo carga de datos IAPOL

## Propósito

Supervisa el procesamiento ETL, el refresh y la carga de datos hacia IAPOL.

## Componentes observados

- `Archivos procesados semana actual`.
- Medidor `Avance semanal`.
- Tabla `Estado actual refresh`.
- `Ultimo refresh exitoso`.
- Tabla `Dashboard de control archivos procesados (ETL)`.
- Tabla `Dashboard de control carga de datos en IAPOL`.
- `Estado procesado top 5`.
- `Visual de crecimiento dataset`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [ ] Conciliar archivos procesados con los archivos recibidos de la hoja anterior.
- [ ] Verificar la regla y el denominador del avance semanal.
- [ ] Comparar el último refresh exitoso con la actualización y partición de Athena.
- [ ] Validar estados fallidos, en progreso, reintentados y completados.
- [ ] Conciliar registros cargados en IAPOL y crecimiento del dataset con Athena.
- [ ] Confirmar orden, criterio y manejo de empates del Top 5.

Documentar reprocesos, exclusiones, cargas parciales y ventanas de mantenimiento. Registrar con la [plantilla común](../../registro-resultados.md).
