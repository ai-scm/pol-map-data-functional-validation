# INFORMACIÓN ESTADISTICA NACIONAL

## Alcance

Hoja H1 de [Medidas de Protección Violencia Intrafamiliar (Operacional)](../README.md). Inventariada mediante la definición JSON el 2026-10-13; acceso, presentación y resultados en pantalla pendientes de verificar.

## Visuales definidos

Las referencias V corresponden al orden del JSON, no a la posición visible. La tabla incluye campos de configuración, incluso los que el visual puede ocultar.

| Referencia | Título | Tipo | Campos y agregaciones explícitas |
| --- | --- | --- | --- |
| H1-V01 | Detalle interviniente Policia | Tabla | `Nombres Policia`, `Apellidos Policia`, `Grado Policia`, `Identificación` |
| H1-V02 | ¿Es Policia? | Barras | `verificacion_policia` |
| H1-V03 | MEDIDAS POR REGIÓN | Barras | `REGION`, `medida_id` (DISTINCT_COUNT) |
| H1-V04 | TOTAL MEDIDAS | KPI | `medida_id` (DISTINCT_COUNT) |
| H1-V05 | Sin título explícito | Imagen | Contenido IMAGE; URL omitida |
| H1-V06 | CIFRA DE ACTORES | Circular | `descripcion_tipo`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V07 | ACTORES POR EDAD | Barras | `descripcion_id_r_edad`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V08 | ACTORES POR SEXO | Circular | `descripcion_sexo`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V09 | ACTORES POR POBLACIÓN | Barras | `descripcion_id_poblacion`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V10 | ACTORES POR PROFESIÓN | Barras | `descripcion_profesion`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V11 | ACTORES POR RAZA | Tabla | `descripcion_raza`, `interviniente_id` (DISTINCT_COUNT) |
| H1-V12 | TOTAL AUTOS | KPI | `auto_id` (DISTINCT_COUNT) |
| H1-V13 | MEDIDAS POR UNIDAD | Barras | `sigla_fisica`, `medida_id` (DISTINCT_COUNT) |
| H1-V14 | MEDIDAS POR CONDUCTA | Circular | `tipo_conducta_descripcion`, `medida_id` (DISTINCT_COUNT) |
| H1-V15 | MEDIDAS POR DELITO | Tabla | `delito_descripcion`, `medida_id` (DISTINCT_COUNT) |
| H1-V16 | MEDIDAS POR ZONA | Circular | `zona_descripcion`, `medida_id` (DISTINCT_COUNT) |
| H1-V17 | TIPO DE MEDIDA | Tabla | `descripcion_articulo`, `medida_id` (DISTINCT_COUNT) |
| H1-V18 | Sin título explícito | Imagen | Contenido IMAGE; URL omitida |
| H1-V19 | Sin título explícito | Imagen | Contenido IMAGE; URL omitida |
| H1-V20 | Sin título explícito | Imagen | Contenido IMAGE; URL omitida |

## Controles declarados

| Etiqueta | Control | Selección | Parámetro o filtro |
| --- | --- | --- | --- |
| Fecha inicio | DateTimePicker | — | Fechainicio |
| Fecha fin | DateTimePicker | — | Fechafin |
| CONDUCTA | Dropdown | MULTI_SELECT | conducta |
| POBLACIÓN | Dropdown | MULTI_SELECT | poblacion |
| ZONA | Dropdown | MULTI_SELECT | Zona |
| EDAD | Dropdown | MULTI_SELECT | EDAD |
| Genero | Dropdown | MULTI_SELECT | genero |
| DELITO | Dropdown | MULTI_SELECT | Delito |
| PROFESIÓN | Dropdown | MULTI_SELECT | Profesion |
| Estado Medida | CrossSheet | — | F43 |
| Estado Auto | CrossSheet | — | F44 |
| Tipo Medida | CrossSheet | — | F45 |

## Reglas e interacciones

`TOTAL MEDIDAS` cuenta medidas distintas y `TOTAL AUTOS` autos distintos. Los actores se cuentan por `interviniente_id`. La tabla de policías usa nombres y apellidos de policía, pero la identificación calculada referencia al interviniente; confirmar esa correspondencia. `¿Es Policia?` no declara una medida explícita en `FieldWells`; la agregación efectiva debe confirmarse.

Hay cuatro visuales de imagen y 14 acciones de filtrado al hacer clic hacia todos los visuales de esta hoja. El gráfico de edad se ordena por el promedio del calculado `EDAD`, ascendente. Edad y género sólo alcanzan sus respectivos gráficos, no todos los KPI.

Se combinan filtros globales y específicos del visual. El inventario íntegro, sus estados y los dos errores reportados están en [documentacion-tecnica.md](../documentacion-tecnica.md). No inferir alcance global a partir del nombre de un control.

## Validaciones pendientes

- [ ] Confirmar acceso a la hoja con el perfil autorizado y carga de todos los visuales.
- [ ] Cambiar filtros y comprobar su alcance según la definición.
- [ ] Comparar cifras o agrupaciones con la fuente usando el mismo corte.
- [ ] Probar campos nulos, vacíos y selecciones sin resultados.
- [ ] Restablecer controles y selecciones; registrar diferencias justificadas.

Resultado funcional y de datos: `No ejecutado`. Las evidencias deben anonimizar identificaciones, nombres, expedientes, rutas de documentos y ubicaciones.
