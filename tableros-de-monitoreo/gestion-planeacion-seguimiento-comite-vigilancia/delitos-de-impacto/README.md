# Hoja: Delitos de impacto

## Propósito

Compara los delitos de impacto registrados en SIEDCO desde el 1 de enero hasta una fecha de corte con el mismo periodo del año anterior. Replica la página “Delitos de impacto – comparativo” del reporte semanal. Versión: sandbox.

## Fuente

Conjunto de datos `vw_delitos_corregido_schema_temporal` (SPICE, recarga diaria a las 04:00), el mismo de [`02. Comparativo Delictivo (Datos crudos)`](../../../informacion-estadistica-delictiva/comparativo-delictivo-datos-crudos/README.md). Cada registro de SIEDCO cuenta como un caso; la columna `cantidad` no se usa.

## Controles observados

- `FECHA DE CORTE` (parámetro `FECHACORTEDELITOS`): por defecto, hace 2 días.
- `METROPOLITANA / DEPARTAMENTO` (parámetro `DELITOSMETDEPTO`) sobre `juris.metropolitana / depto`, es decir, el lugar del hecho.

## Componentes observados

- Resumen: total de delitos de impacto del año anterior, del año actual y variación.
- Tablas con año anterior, año actual, diferencia y variación %:
  - `HOMICIDIO INTENCIONAL`: urbano, rural y total.
  - `FEMINICIDIOS`.
  - `HURTO GENERAL`: personas, residencias, comercio, automotores, motocicletas, entidades financieras, abigeato, celulares y bicicletas, con total.
  - `SECUESTRO`: simple y extorsivo, con total.
  - `OTROS DELITOS DE IMPACTO`: lesiones personales, extorsión, delitos sexuales, violencia intrafamiliar, piratería, acciones subversivas y terrorismo.
  - `SEGURIDAD VIAL`: homicidios y lesiones en accidente de tránsito, con total.
- Barras de año anterior frente a año actual por delito.
- Nota de fuente y de subregistro reciente.

Variación en navy: aumento de casos. Variación en lima: disminución.

## Pruebas específicas

- [x] Las cifras de 2025 coinciden con el reporte (corte 18 de febrero). — Aprobado el 2026-10-21: homicidios en accidente de tránsito 903, abigeato 160, secuestro extorsivo 30, feminicidios 26, hurto a personas 38.179 (reporte 38.194).
- [ ] Las cifras de 2026 coinciden con el reporte. — Fallido por subregistro: el reporte se extrajo dos días después del corte; por ejemplo, hurto a personas 35.410 en el reporte y 41.761 hoy (hallazgo H02).
- [ ] La agrupación de hurto general suma lo mismo que el total del reporte. — No ejecutado en el dashboard; en Athena el total de 2025 es 65.570 frente a 65.365.
- [ ] El filtro de metropolitana o departamento afecta todas las tablas. — No ejecutado.
- [ ] Permiso formal del equipo dueño del conjunto de datos. — Pendiente antes de publicar.

Las reglas y cifras de referencia están en [`documentacion-tecnica.md`](../documentacion-tecnica.md).
