# Hoja: Patrullas

## Propósito

Compara actividad por patrulla y sigla e identifica su distribución geográfica.

## Componentes observados

- `Numero de Llamadas por Patrulla y Sigla (Top 30)`.
- `Informe de Registros por Sigla`.
- `Reporte de Registros de Bse de Datos de Origen por Coordenadas`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [ ] Validar el criterio de orden y desempate del Top 30. — Bloqueado: configuración de desempate no disponible.
- [ ] Conciliar llamadas por patrulla y sigla con Athena. — Bloqueado: sin consulta Athena.
- [ ] Comprobar que la selección de una patrulla filtra las demás visuales. — Pendiente de interacción específica.
- [ ] Validar registros sin patrulla, con patrulla no homologada o duplicada. — Bloqueado: falta catálogo y consulta de calidad.
- [ ] Verificar coordenadas y correspondencia territorial de la dispersión. — Bloqueado: falta fuente geográfica de referencia.

Registrar con la [plantilla común](../../registro-resultados.md).
