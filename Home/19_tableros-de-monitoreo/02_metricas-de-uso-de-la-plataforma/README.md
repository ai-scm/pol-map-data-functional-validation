# Métricas de Uso de la Plataforma

## Objetivo

Mide adopción de la plataforma y uso de la herramienta de mapa de anticipación mediante usuarios, actividad e interacciones.

## Ruta funcional

`Home > Tableros de Monitoreo > Métricas de Uso de la Plataforma`

## Documentación técnica

Las fórmulas verificadas, filtros compartidos, parámetros y particularidades de las ventanas temporales están en [`documentacion-tecnica.md`](documentacion-tecnica.md).

## Hojas

| Hoja del análisis | Publicación | Propósito | Documento |
|---|---|---|---|
| Información de usuarios | Publicada | Adopción, actividad y seguimiento de usuarios. | [`informacion-de-usuarios`](informacion-de-usuarios/README.md) |
| Uso mapa anticipacion | Publicada | Usuarios e interacciones con el mapa de anticipación. | [`uso-mapa-anticipacion`](uso-mapa-anticipacion/README.md) |
| Información de usuarios (Anterior) | No publicada | Versión anterior del seguimiento de usuarios y actividad. | [`informacion-de-usuarios-anterior`](informacion-de-usuarios-anterior/README.md) |
| Estadísticas de uso | No publicada | Tendencia de usuarios e interacciones por tablero. | [`estadisticas-de-uso`](estadisticas-de-uso/README.md) |
| Sheet 10 | No publicada | Serie técnica de usuarios distintos del mapa de anticipación. | [`sheet-10`](sheet-10/README.md) |

## Validaciones funcionales del submódulo

- [x] Las dos hojas publicadas son accesibles y cambian los controles y visuales. — Aprobado el 2026-09-04.
- [x] Las tres hojas no publicadas están identificadas y no aparecen accidentalmente en el dashboard de producción. — Aprobado el 2026-09-04.
- [x] Los filtros de periodo, sigla, dependencia y estado actualizan KPIs, gráficos y tablas. — Aprobado por configuración; `Estado` se ejecutó y refrescó los visuales.
- [x] Los filtros de fecha de uso del mapa incluyen los extremos esperados. — Aprobado: Eventos controlados en ambos extremos y zona horaria confirmada.
- [x] Las selecciones pueden restablecerse sin conservar filtros residuales. — Aprobado para la prueba de `Estado` mediante `Restablecer al original`.
- [x] Las tablas de seguimiento no exponen usuarios fuera del alcance autorizado. — Aprobado: Se verifica con el estado de los 5 grados que se muestran.

## Validaciones de datos del submódulo

- Conciliar usuarios registrados, con ingreso, sin ingreso y activos.
- Documentar la definición exacta de “activo” y la ventana temporal utilizada.
- Conciliar interacciones por fecha y sigla con Athena.
- Validar duplicados de eventos de uso y la llave de usuario anonimizada.
- Verificar la exclusión o inclusión de usuarios inactivos y cuentas técnicas.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md) y [`registro-resultados.md`](../registro-resultados.md). Los resultados de la ejecución realizada están en [`ejecucion-validaciones-2026-09-04.md`](../ejecucion-validaciones-2026-09-04.md). Cualquier evidencia de usuarios debe anonimizar nombres, correos e identificadores.
