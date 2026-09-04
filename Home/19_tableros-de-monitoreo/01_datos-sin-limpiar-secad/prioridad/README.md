# Hoja: Prioridad

## Propósito

Analiza la distribución de registros recientes por código de prioridad y dimensión temporal.

## Control observado

- `Días`, con valor observado `30`.

## Componentes observados

- `Prioridad por Día`.
- `Prioridad Total`.
- `Cuenta por Prioridad`.
- `Prioridad por Día de la Semana`.
- `Prioridad por Semana`.
- `Prioridad por Hora`.
- Sección `Barrios`.

## Pruebas específicas

- [ ] Conciliar el total por cada código de prioridad. — Bloqueado: sin consulta Athena.
- [ ] Validar homologación, orden y descripción de los códigos. — Bloqueado: falta catálogo autorizado.
- [ ] Comprobar que las agregaciones temporales usan el mismo campo de fecha y zona horaria. — Bloqueado: zona horaria no documentada.
- [ ] Confirmar que cambiar `Días` actualiza todos los visuales. — Pendiente de prueba específica en esta hoja; el parámetro y filtro sí fueron confirmados en configuración.
- [ ] Identificar prioridades nulas, desconocidas o fuera del catálogo. — Bloqueado: falta catálogo y consulta de datos.

Registrar con la [plantilla común](../../registro-resultados.md).
