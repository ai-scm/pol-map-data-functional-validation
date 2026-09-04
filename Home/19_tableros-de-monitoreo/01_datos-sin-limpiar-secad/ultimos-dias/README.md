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

- [ ] Cambiar `Días` y verificar los límites inferior y superior de la ventana.
- [ ] Filtrar una sigla y conciliar el total con Athena.
- [ ] Confirmar que todos los visuales responden a ambos filtros.
- [ ] Verificar que el máximo pertenece al periodo seleccionado.
- [ ] Validar el comportamiento cuando el periodo no tiene registros.

Documentar zona horaria, definición de “últimos días” y tratamiento del día en curso. Registrar con la [plantilla común](../../registro-resultados.md).
