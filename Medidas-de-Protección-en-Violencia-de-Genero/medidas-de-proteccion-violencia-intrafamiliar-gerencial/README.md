# Medidas de Protección Violencia Intrafamiliar (Gerencial)

## Objetivo

Documentar el seguimiento de medidas de protección, autos, intervinientes y actividades, con desagregación territorial y consulta de detalle. El encabezado del tablero menciona la Estrategia de Atención a Mujer, Familia y Género. El alcance exacto del universo de violencia intrafamiliar está pendiente de confirmar con el responsable funcional.

## Identificación y alcance

| Campo | Valor |
|---|---|
| Nombre funcional | Medidas de Protección Violencia Intrafamiliar (Gerencial) |
| Nombre en Quick | `pon-prod-mpvg-medidas-proteccion-violencia-genero` |
| Estado | En construcción |
| Fecha de documentación | 2026-10-13 |
| Responsable | Pendiente por confirmar |
| Evidencia | `dashboard-definition2.json` y `dataset-definition.json` entregados por el usuario |
| Validación en pantalla y conciliación de cifras | No ejecutado |

Ubicación documental: `Medidas de Protección en Violencia de Género`. La ruta propuesta es `Home > Medidas de Protección en Violencia de Género > Medidas de Protección Violencia Intrafamiliar (Gerencial)`; su etiqueta y disponibilidad en la aplicación están pendientes de confirmar. El nombre funcional fue proporcionado por el usuario.

La definición exportada contiene cuatro hojas y 34 visuales. No se recibió la definición del análisis ni se verificó cuáles pestañas son accesibles para cada perfil en la aplicación.

## Hojas incluidas en la definición

| Hoja en Quick | Visuales definidos | Documento |
| --- | --- | --- |
| INFORMACIÓN ESTADISTICA NACIONAL | 20 | [informacion-estadistica-nacional](informacion-estadistica-nacional/README.md) |
| DETALLE DE LA INFORMACIÓN | 12 | [detalle-de-la-informacion](detalle-de-la-informacion/README.md) |
| DETALLE CON DOCUMENTO AUTO | 1 | [detalle-con-documento-auto](detalle-con-documento-auto/README.md) |
| DETALLE SIN DOCUMENTO AUTO | 1 | [detalle-sin-documento-auto](detalle-sin-documento-auto/README.md) |

## Documentación técnica

En [documentacion-tecnica.md](documentacion-tecnica.md) se registran la fuente del dataset, transformaciones, diccionario de campos, fórmulas, parámetros, los 46 grupos de filtros y hallazgos de configuración.

## Diferencias frente al operacional

Comparte el dataset `medidas_autos_s3` con el [tablero operacional](../medidas-de-proteccion-violencia-intrafamiliar-operacional/README.md). Se confirmó la correspondencia de las referencias en los archivos recibidos.

El visual `MEDIDAS DE PROTECCIÓN` usa `COUNT(medida_id)`; en el operacional usa `DISTINCT_COUNT`. También agrega controles de región y unidad y opciones en cascada. La comparación detallada está en la documentación técnica. La etiqueta “Gerencial” no demuestra por sí sola un nivel distinto de acceso o anonimización: la definición incluye tablas de personas y documentos.


## Aceptación y resultados

Aplican las pautas de [validaciones.md](../../tableros-de-monitoreo/validaciones.md). La inspección documental confirma configuraciones; no acredita que los controles funcionen ni que las cifras sean correctas. La ejecución funcional y de datos permanece `No ejecutado`.

## Evidencia e información sensible

La documentación registra nombres de campos y reglas, sin valores de personas ni registros operacionales. Las evidencias deben anonimizar nombres, identificaciones, teléfonos, expedientes, rutas de documentos y ubicaciones. Los JSON originales se mantienen fuera del repositorio; contienen ARN, identificadores técnicos y URL de recursos.
