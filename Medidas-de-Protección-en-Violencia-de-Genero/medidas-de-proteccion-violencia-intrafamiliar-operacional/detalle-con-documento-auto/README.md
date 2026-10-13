# DETALLE CON DOCUMENTO AUTO

## Alcance

Hoja H3 de [Medidas de Protección Violencia Intrafamiliar (Operacional)](../README.md). Inventariada mediante la definición JSON el 2026-10-13; acceso, presentación y resultados en pantalla pendientes de verificar.

## Visuales definidos

Las referencias V corresponden al orden del JSON, no a la posición visible. La tabla incluye campos de configuración, incluso los que el visual puede ocultar.

| Referencia | Título | Tipo | Campos y agregaciones explícitas |
| --- | --- | --- | --- |
| H3-V01 | Sin título explícito | Tabla dinámica | `auto_id`, `numero_expediente`, `fecha_medida`, `sigla_fisica`, `descripcion_dependencia`, `ACTIVIDADES`, `descripcion_tipo_identifica`, `estado_auto`, `tipo_medida`, `estado_medida`, `ruta`, `identificacion_interviniente` (MAX) |

## Controles declarados

| Etiqueta | Control | Selección | Parámetro o filtro |
| --- | --- | --- | --- |
| Fecha Inicio | DateTimePicker | — | Fechainicio |
| Fecha Fin | DateTimePicker | — | Fechafin |
| Estación | Dropdown | MULTI_SELECT | estaciones |
| Identificación | TextField | — | identificacion |
| Estado Auto | CrossSheet | — | F44 |
| Tipo Medida | CrossSheet | — | F45 |
| Estado Medida | CrossSheet | — | F43 |

## Reglas e interacciones

La clasificación se basa en F41: `ruta_null = 1`, con `NullOption = ALL_VALUES`. La fórmula `ifelse(ruta='',0,1)` sólo compara con cadena vacía. El nombre “con documento” no demuestra existencia ni acceso al archivo.

La tabla dinámica agrupa por auto, expediente, fecha, unidad, estación, actividades, tipo de identificación, estado de auto, tipo/estado de medida y ruta. Usa `MAX(identificacion_interviniente)` como medida; verificar que la agrupación no oculte otras personas. La fecha se presenta como `DD/MM/YYYY` y el rótulo de identificación contiene la errata `Idnetificación`.

Se combinan filtros globales y específicos del visual. El inventario íntegro, sus estados y los dos errores reportados están en [documentacion-tecnica.md](../documentacion-tecnica.md). No inferir alcance global a partir del nombre de un control.

