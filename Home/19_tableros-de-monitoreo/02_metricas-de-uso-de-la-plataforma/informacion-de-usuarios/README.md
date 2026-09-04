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

- [ ] Documentar denominador y reglas de cada KPI y porcentaje.
- [ ] Conciliar usuarios únicos y eventos de ingreso con Athena.
- [ ] Validar la definición de activo (ventana observada de 10 días).
- [ ] Comprobar combinación y restablecimiento de los cuatro filtros.
- [ ] Verificar que el embudo no aumenta en etapas sucesivas sin explicación.
- [ ] Confirmar que el seguimiento respeta el alcance autorizado.

Las evidencias deben anonimizar nombres, correos e identificadores. Registrar con la [plantilla común](../../registro-resultados.md).
