# Hoja: Últimos Días

## Propósito

Permite seguir el volumen reciente de SECAD dentro de una ventana móvil.

## Controles observados

- `Días`, con valor observado `30`.
- `Sigla`, con selección inicial `Todo`.

## Componentes observados

- Máximo del periodo, cuenta total y número de bases de origen.
- Conteos por fecha, día/sigla, base de origen, día de semana, semana del año y hora.

## Pruebas específicas

- [x] Cambiar `Días` y verificar los límites inferior y superior de la ventana. — Aprobado
- [x] Filtrar una sigla y conciliar el total con Athena. — Aprobado
- [x] Confirmar que todos los visuales responden a ambos filtros. — Aprobado el 2026-09-04; se observaron refrescos y se restablecieron ambos controles.
- [x] Verificar que el máximo pertenece al periodo seleccionado. — Aprobado

Documentar zona horaria, definición de “últimos días” y tratamiento del día en curso. Registrar con la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
