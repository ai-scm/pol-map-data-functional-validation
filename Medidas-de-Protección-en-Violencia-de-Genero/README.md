# Medidas de Protección en Violencia de Género

## Objetivo y alcance

Reúne la documentación de los tableros operacional y gerencial de medidas de protección en violencia intrafamiliar. La ubicación del módulo y los nombres funcionales fueron indicados por el usuario; las rutas y el acceso por perfil en la aplicación están pendientes de verificar.

Fecha de actualización documental: 2026-10-13. Responsable: pendiente por confirmar.

## Tableros documentados

| Tablero | Nombre en Quick | Hojas / visuales en definición | Documentación | Estado |
|---|---|---|---|---|
| Medidas de Protección Violencia Intrafamiliar (Operacional) | `Medidas-protección-Momet-Operativo` | 4 / 34 | [Operacional](medidas-de-proteccion-violencia-intrafamiliar-operacional/README.md) | En construcción |
| Medidas de Protección Violencia Intrafamiliar (Gerencial) | `pon-prod-mpvg-medidas-proteccion-violencia-genero` | 4 / 34 | [Gerencial](medidas-de-proteccion-violencia-intrafamiliar-gerencial/README.md) | En construcción |

## Fuente compartida y diferencias

Las referencias de ambos dashboards corresponden al dataset exportado `medidas_autos_s3`, en modo SPICE. La fuente declarada es la tabla del mismo nombre, catálogo `AwsDataCatalog`, esquema `pon-prod-raw-disec`. Motor de conexión, proceso de ingesta, programación y corte de datos pendientes de confirmar.

Ambos dashboards tienen las mismas cuatro hojas, fórmulas calculadas y errores reportados en los archivos. Hay diferencias de controles, presentación y de agregación: `MEDIDAS DE PROTECCIÓN` cuenta medidas distintas en el operacional y ocurrencias de `medida_id` en el gerencial. La [comparación técnica](medidas-de-proteccion-violencia-intrafamiliar-gerencial/documentacion-tecnica.md) detalla estas diferencias.

## Progreso y pendientes

- [x] Inventariar las cuatro hojas de cada tablero y documentar su configuración exportada.
- [x] Verificar la correspondencia del dataset compartido y comparar ambos dashboards.
- [ ] Confirmar ruta funcional, responsables y permisos de acceso de cada tablero.
- [ ] Revisar los dos errores de filtros y los controles discordantes en pantalla.
- [ ] Confirmar grano, actualización de SPICE y reglas de negocio.
- [ ] Ejecutar validaciones funcionales y conciliación de datos para cada tablero.

La validación funcional y de cifras permanece `No ejecutado`. Como referencia de procedimiento se utilizan las [pautas de validación](../tableros-de-monitoreo/validaciones.md). No se incluyen valores de personas, ARN ni URL de recursos en esta documentación.
