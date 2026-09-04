# Monitoreo Componentes

## Objetivo

Concentrar el estado operativo de componentes mediante un contenido visual personalizado embebido en el dashboard.

## Ruta funcional

`Home > Tableros de Monitoreo > Monitoreo Componentes`

## Estructura observada

No se expusieron pestañas de hojas. La vista contiene un único visual personalizado dentro de QuickSight.

## Dependencia observada

Durante el inventario del 2026-09-04, el contenedor de QuickSight cargó, pero el contenido personalizado mostró una solicitud de inicio de sesión de Google. Por ello, la inspección funcional del contenido quedó `Bloqueada`.

## Validaciones funcionales

- [ ] El submódulo abre el contenedor sin errores.
- [ ] La sesión autorizada para el contenido externo está disponible.
- [ ] El visual personalizado carga sin solicitar credenciales inesperadas.
- [ ] Los componentes, estados, colores y marcas de tiempo son legibles.
- [ ] Un componente puede activarse o seleccionarse y muestra el detalle correcto, si esa interacción existe.
- [ ] No se muestran componentes ajenos al entorno o alcance seleccionado.

## Validaciones de datos

- Conciliar la fecha/hora del último estado con la fuente de monitoreo y Athena cuando corresponda.
- Confirmar cantidad de componentes esperados, disponibles, degradados y fallidos.
- Validar reglas de clasificación de estado y tolerancia de antigüedad.
- Documentar componentes excluidos, ventanas de mantenimiento y estados homologados.

## Criterio de aceptación

No puede aprobarse mientras el contenido principal requiera una autenticación no satisfecha o no sea posible contrastar sus estados. Registrar el bloqueo, dependencia y responsable en [`registro-resultados.md`](../registro-resultados.md), aplicando [`validaciones.md`](../validaciones.md).
