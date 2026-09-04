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

- [ ] Conciliar archivos procesados con los archivos recibidos de la hoja anterior. — Bloqueado: falta llave de archivo y corte común.
- [ ] Verificar la regla y el denominador del avance semanal. — Bloqueado: fórmula del gauge no disponible.
- [ ] Comparar el último refresh exitoso con la actualización y partición de Athena. — Bloqueado: sin consulta ni partición Athena.
- [ ] Validar estados fallidos, en progreso, reintentados y completados. — Parcial: la hoja carga estados, pero no se dispuso de casos de todos los tipos.
- [ ] Conciliar registros cargados en IAPOL y crecimiento del dataset con Athena. — Bloqueado: sin consulta Athena.
- [ ] Confirmar orden, criterio y manejo de empates del Top 5. — Bloqueado: configuración completa no disponible.

Documentar reprocesos, exclusiones, cargas parciales y ventanas de mantenimiento. Registrar con la [plantilla común](../../registro-resultados.md).
