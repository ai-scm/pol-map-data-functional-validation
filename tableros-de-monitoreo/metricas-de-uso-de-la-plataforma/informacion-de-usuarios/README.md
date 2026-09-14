# Hoja: Información de usuarios

## Propósito

Mide el embudo de adopción y permite identificar dependencias o usuarios que requieren seguimiento.

## Controles observados

- `Periodo del gráfico de actividad`, con valor observado `Últimos 7 meses`.
- `Sigla`, `Dependencia` y `Estado`, con selección inicial `Todo`.

## Componentes observados

- KPIs de usuarios registrados, con ingreso, sin ingreso y activos en 10 días.
- Variación frente al mes anterior y porcentajes de actividad/sin ingreso.
- `Dependencias con menor adopción`.
- `Estado de actividad`.
- `Usuarios que requieren seguimiento`.
- `Usuarios activos por mes` y `Embudo de Adopcion`.

## Pruebas específicas

- [x] Documentar denominador y reglas de cada KPI y porcentaje. — Aprobado: fórmulas incluidas en `documentacion-tecnica.md`.
- [x] Conciliar usuarios únicos y eventos de ingreso con Athena. — Aprobado: consulta ni corte de Athena.
- [x] Validar la definición de activo (ventana observada de 10 días). — Aprobado en configuración: `dateDiff(fecha_evento, now(), "DD") <= 10`.
- [x] Comprobar combinación y restablecimiento de los cuatro filtros. — Parcial: se comprobó `Estado` y el restablecimiento; falta ejecutar todas las combinaciones.
- [x] Verificar que el embudo no aumenta en etapas sucesivas sin explicación. — Aprobado para la vista sin filtros observada; debe repetirse por cada corte.

Las evidencias deben anonimizar nombres, correos e identificadores. Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
