# Hoja: Patrullas

## Propósito

Compara actividad por patrulla y sigla e identifica su distribución geográfica.

## Componentes observados

- `Numero de Llamadas por Patrulla y Sigla (Top 30)`.
- `Informe de Registros por Sigla`.
- `Reporte de Registros de Bse de Datos de Origen por Coordenadas`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [x] Validar el criterio de orden y desempate del Top 30. — Aprobado
- [x] Conciliar llamadas por patrulla y sigla con Athena. — Bloqueado: sin consulta Athena.
- [x] Validar registros sin patrulla, con patrulla no homologada o duplicada. — Aprobado
- [x] Verificar coordenadas y correspondencia territorial de la dispersión. — Aprobado

Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
