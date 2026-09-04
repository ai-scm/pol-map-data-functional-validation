# Métricas de Uso de la Plataforma

## Objetivo

Mide adopción de la plataforma y uso de la herramienta de mapa de anticipación mediante usuarios, actividad e interacciones.

## Ruta funcional

`Home > Tableros de Monitoreo > Métricas de Uso de la Plataforma`

## Hojas

| Hoja visible | Propósito | Documento |
|---|---|---|
| Información de usuarios | Adopción, actividad y seguimiento de usuarios. | [`informacion-de-usuarios`](informacion-de-usuarios/README.md) |
| Uso mapa anticipacion | Usuarios e interacciones con el mapa de anticipación. | [`uso-mapa-anticipacion`](uso-mapa-anticipacion/README.md) |

## Validaciones funcionales del submódulo

- [ ] Las dos hojas son accesibles y cambian los controles y visuales.
- [ ] Los filtros de periodo, sigla, dependencia y estado actualizan KPIs, gráficos y tablas.
- [ ] Los filtros de fecha de uso del mapa incluyen los extremos esperados.
- [ ] Las selecciones pueden restablecerse sin conservar filtros residuales.
- [ ] Las tablas de seguimiento no exponen usuarios fuera del alcance autorizado.

## Validaciones de datos del submódulo

- Conciliar usuarios registrados, con ingreso, sin ingreso y activos.
- Documentar la definición exacta de “activo” y la ventana temporal utilizada.
- Conciliar interacciones por fecha y sigla con Athena.
- Validar duplicados de eventos de uso y la llave de usuario anonimizada.
- Verificar la exclusión o inclusión de usuarios inactivos y cuentas técnicas.

## Aceptación y resultados

Aplican [`validaciones.md`](../validaciones.md) y [`registro-resultados.md`](../registro-resultados.md). Cualquier evidencia de usuarios debe anonimizar nombres, correos e identificadores.
