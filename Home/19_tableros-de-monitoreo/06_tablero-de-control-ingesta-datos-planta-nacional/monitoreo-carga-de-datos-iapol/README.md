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

- [x] Conciliar archivos procesados con los archivos recibidos de la hoja anterior. — Aprobado.
- [x] Verificar la regla y el denominador del avance semanal. — Bloqueado: fórmula del gauge no disponible.
- [x] Comparar el último refresh exitoso con la actualización y partición de Athena. — Aprobado: consulta en Athena.
- [x] Validar estados fallidos, en progreso, reintentados y completados. — Aprobado.
- [x] Conciliar registros cargados en IAPOL y crecimiento del dataset con Athena. — Aprobado:  consulta Athena.
- [x] Confirmar orden, criterio y manejo de empates del Top 5. — Aprobado.

Documentar reprocesos, exclusiones, cargas parciales y ventanas de mantenimiento. Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
