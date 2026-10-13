# DETALLE DE LA INFORMACIÓN

## Alcance

Hoja H2 de [Medidas de Protección Violencia Intrafamiliar (Operacional)](../README.md). Inventariada mediante la definición JSON el 2026-10-13; acceso, presentación y resultados en pantalla pendientes de verificar.

## Visuales definidos

Las referencias V corresponden al orden del JSON, no a la posición visible. La tabla incluye campos de configuración, incluso los que el visual puede ocultar.

| Referencia | Título | Tipo | Campos y agregaciones explícitas |
| --- | --- | --- | --- |
| H2-V01 | ACTIVIDADES POR CUADRANTE | Tabla | `cuadrante`, `ACTIVIDADES` (SUM) |
| H2-V02 | ACTIVIDADES POR ESTACIONES | Tabla | `descripcion_dependencia`, `ACTIVIDADES` (SUM) |
| H2-V03 | DETALLE INTERVINIENTES POR CANTIDAD DE ACTIVIDADES | Tabla | `interviniente_id`, `descripcion_tipo`, `descripcion_raza`, `descripcion_id_poblacion`, `descripcion_profesion`, `nombres`, `apellidos`, `descripcion_sexo`, `identificacion_interviniente`, `descripcion_tipo_identifica`, `ACTIVIDADES` (SUM), `medida_id` (DISTINCT_COUNT), `AUTOS` |
| H2-V04 | MEDIDAS OPCIONALES | Tabla | `descripcion_id_literal`, `medida_id` (DISTINCT_COUNT) |
| H2-V05 | Sin título explícito | Imagen | Contenido IMAGE; URL omitida |
| H2-V06 | AUTOS POR UNIDAD | Barras | `sigla_fisica`, `auto_id` (DISTINCT_COUNT) |
| H2-V07 | DETALLE ACTIVIDADES | Tabla dinámica | `medida_id`, `ACTIVIDADES`, `sigla_fisica`, `descripcion_dependencia`, `descripcion_tipo`, `cuadrante`, `apellidos`, `nombres`, `identificacion_interviniente` (MAX) |
| H2-V08 | CUADRANTE | Tabla | `cuadrante`, `medida_id` (DISTINCT_COUNT) |
| H2-V09 | ESTACIONES | Tabla | `descripcion_dependencia`, `medida_id` (DISTINCT_COUNT) |
| H2-V10 | Sin título explícito | Mapa | `latitud`, `longitud`, `medida_id` (DISTINCT_COUNT), `sigla_fisica` |
| H2-V11 | MEDIDAS DE PROTECCIÓN | Tabla | `descripcion_id_literal`, `medida_id` (DISTINCT_COUNT) |
| H2-V12 | ACTIVIDADES POR UNIDAD | Barras | `sigla_fisica`, `ACTIVIDADES` (SUM) |

## Controles declarados

| Etiqueta | Control | Selección | Parámetro o filtro |
| --- | --- | --- | --- |
| FECHA INICIO | DateTimePicker | — | Fechainicio |
| FECHA FIN | DateTimePicker | — | Fechafin |
| CONDUCTA | Dropdown | MULTI_SELECT | conducta |
| POBLACIÓN | Dropdown | MULTI_SELECT | poblacion |
| ZONA | Dropdown | MULTI_SELECT | Zona |
| Cuadrante | Dropdown | MULTI_SELECT | cuadrante |
| DELITO | Dropdown | MULTI_SELECT | Delito |
| estacion | Dropdown | MULTI_SELECT | estaciones |
| Unidad | Dropdown | MULTI_SELECT | Unidad |
| IDENTIFICACIÓN | TextField | — | identificacion |
| CANTIDAD DE ACTIVIDADES POR MEDIDA | TextArea | — | Actividades |
| NÚMERO EXPEDIENTE | Dropdown | MULTI_SELECT | F26 |
| TIPO INTERVINIENTE | Dropdown | MULTI_SELECT | F33 |

## Reglas e interacciones

Los cuatro visuales de actividades usan `SUM(ACTIVIDADES)`; confirmar su grano antes de sumar cifras. El detalle de intervinientes incluye campos ocultos de agrupación: ocultarlos no elimina su efecto sobre la granularidad.

El mapa usa latitud y longitud, medidas distintas y color por unidad; su tooltip incorpora nombre, teléfono y dirección de comisaría. No se documentan valores reales ni coordenadas. El pivote `DETALLE ACTIVIDADES` tiene una acción de filtrado hacia todos los visuales de esta hoja.

`MEDIDAS DE PROTECCIÓN` aplica F23 con tres variantes de texto del artículo 5; `MEDIDAS OPCIONALES` aplica F24. Son configuraciones de clasificación del visual, no una verificación normativa.

El control `NÚMERO EXPEDIENTE` está enlazado a `counting`, no al número de expediente. El control `DELITO` modifica un parámetro cuyo filtro sólo alcanza H1. Ambos requieren revisión funcional.

Se combinan filtros globales y específicos del visual. El inventario íntegro, sus estados y los dos errores reportados están en [documentacion-tecnica.md](../documentacion-tecnica.md). No inferir alcance global a partir del nombre de un control.

