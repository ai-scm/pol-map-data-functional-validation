# Documentación técnica — Tablero Aprendizaje IAPOL

## Alcance y evidencia

Revisión del proyecto local `capacitacion-iapol` y sus definiciones de QuickSight, 2026-10-21. La configuración versionada prueba la lógica de datasets y las frecuencias previstas; no equivale a una inspección en vivo del tablero publicado. La configuración local indica que el análisis recibió cambios posteriores a `dashboard.json`. Confirmar la versión publicada antes de atribuirle todos los visuales del análisis.

## Cadena de datos

```text
Curso HTML en Houndoc → API de progreso → DynamoDB
                                      ↓ exportación cada hora
                           CSV en S3 → Athena → SPICE → QuickSight → Houndoc
```

El HTML del curso obtiene la sesión de Keycloak; la API usa la identidad del JWT para guardar una fila por `user_id` y `course_id = iapol-v1` en DynamoDB `iapol-training-progress-prod`. El campo `active_seconds` mide tiempo activo aproximado, no tiempo transcurrido entre inicio y fin. El CSV exportado está en `current/progress.csv` del bucket de exportación del curso y se consulta en Athena como `iapol_training.progress`.

La consulta de cobertura agrega la cohorte institucional y hace `LEFT JOIN` por `persona_id = user_id` del curso. La cohorte selecciona usuarios Keycloak con actividad IAPOL durante 2026 y personal activo en `USR_MNVCC.VM_PERSONAL_AGRUPADO`, con unidad y correo institucional. Deduplica por ID de persona. Esta regla se copió del tablero de certificaciones; si cambia allí, ambos totales pueden diferir. La comparación histórica de 13.972 personas corresponde a una carga del 2026-10-19 y **no** es un total vigente.

La consulta también incorpora intentos de la evaluación desde el catálogo federado de certificaciones. `presento` exige un registro `ATTEMPT`; abrir el formulario no cuenta. Esos campos son auxiliares de la consulta de cobertura, aunque el propósito de este tablero es el curso.

## Datasets y análisis

| Activo lógico | Función | Modo |
|---|---|---|
| Cobertura institucional del curso | Una fila por persona; estado, tiempo, porcentaje y módulos. | SPICE |
| Finalización por módulo | Participantes, personas con el módulo al 100 % y porcentaje de finalización de cada uno de los 15 módulos, entre usuarios que iniciaron. | SPICE |
| Análisis editable | Hojas Resumen y Consulta por persona; incorpora el dataset de módulos. | Edición |
| Tablero publicado | Versión consumida por Houndoc. | Lectura |

La definición local del tablero contiene únicamente el dataset de cobertura y conserva rótulos y controles anteriores. El proyecto registra cambios hechos directamente en el análisis el 2026-10-19 que podrían no estar en esa definición. Por eso se deben verificar las hojas publicadas y sus controles antes de dar por vigente una lista exacta de visuales.

## Reglas de cálculo

| Indicador | Regla |
|---|---|
| Total de personas | Personas distintas de la cohorte institucional, con los filtros de la vista. |
| Sin iniciar | Persona de la cohorte sin fila del curso. |
| En curso | Tiene fila del curso, pero no cumple las tres condiciones de terminación. |
| Terminó | `status = 'terminado'`, `overall_pct = 100` y `completed_at` no vacío. |
| Porcentaje del curso | `overall_pct`, o 0 si no hay fila. |
| Tiempo activo | `active_seconds / 3600`, redondeado a dos decimales en el dataset. |
| Módulo completado | Porcentaje del módulo igual a 100. |
| Finalización por módulo | Personas con ese módulo al 100 % / participantes con registro del curso. |

El estado de una persona es excluyente. Los valores de módulo de quienes no iniciaron se presentan como 0 en la consulta por persona. Las notas del curso se calculan en el navegador y no deben tratarse como calificaciones oficiales.

## Filtros e interacción

La consulta por persona contiene nombre, correo institucional, unidad, estado, porcentaje, horas activas, fechas y porcentajes por módulo. El objetivo funcional acordado es buscar por nombre o correo institucional y elegir uno de los tres estados desde un control de selección. Confirmar en el tablero publicado que no sigan visibles controles de correo o usuario Keycloak ni textos técnicos de agregación.

## Actualización y latencia

| Etapa | Frecuencia configurada | Efecto |
|---|---|---|
| API → DynamoDB | Al sincronizar el curso | Guarda el progreso del usuario. |
| DynamoDB → CSV en S3 | Cada hora, minuto :05 UTC | Reemplaza la instantánea consultada por Athena. |
| Dataset de módulos → SPICE | Cada hora, alrededor del minuto :20 de Bogotá | Recalcula finalización por módulo. |
| Dataset de cobertura → SPICE | Cada hora, alrededor del minuto :35 de Bogotá | Actualiza personas, estados y tiempo en el tablero. |
| Exportación de usuarios y personal | Proceso diario del tablero de certificaciones | Actualiza la población de referencia; un refresh de SPICE no fuerza esta extracción. |

Las horas son de programación, no garantía de finalización. Un refresh manual de SPICE sin exportar antes DynamoDB relee el CSV anterior; para ver avances recientes se requiere primero una exportación exitosa y después la ingestión SPICE exitosa. Los datasets de módulos y cobertura pueden tener cortes distintos durante parte de la hora.

## Comprobaciones de datos

Usar un mismo corte de Athena y del dataset SPICE. Esta consulta verifica que los estados formen una partición; la cohorte exacta se define en la consulta del dataset de cobertura del proyecto:

```sql
SELECT
  count(*) AS registros_curso,
  count(DISTINCT user_id) AS personas_con_registro,
  count(DISTINCT CASE WHEN status = 'terminado'
    AND overall_pct = 100 AND nullif(completed_at, '') IS NOT NULL
    THEN user_id END) AS personas_terminaron
FROM "iapol_training"."progress"
WHERE course_id = 'iapol-v1';
```

Esta consulta sólo cuenta personas con registro: **no** calcula Sin iniciar. Ese valor requiere el cruce con la cohorte institucional. Para reproducir el total y el semáforo completos, consultar la SQL de cobertura del proyecto `capacitacion-iapol/quicksight/cohort-dataset.sql` y comparar con QuickSight usando la misma fecha de ingestión.

## Pendientes de verificación

- Confirmar ubicación exacta en el menú de Houndoc y versión del tablero publicada.
- Confirmar controles, títulos y visual de módulos en la versión publicada.
- Conciliar el total con el tablero de certificaciones después de que ambos datasets terminen su carga.
- Registrar fecha, responsable y resultado de una prueba funcional con datos anonimizados.
