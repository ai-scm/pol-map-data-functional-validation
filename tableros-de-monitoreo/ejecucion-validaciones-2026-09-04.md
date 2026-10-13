# Ejecución de validaciones — 2026-09-04

## Alcance

Validación funcional realizada sobre la interfaz autenticada de la aplicación y Amazon Quick. Se comprobaron navegación, carga, hojas, controles, respuesta de visuales y restablecimiento cuando fue posible. Las conciliaciones con Athena registradas como aprobadas se documentan por hoja en los README de cada submódulo; los ítems que aún requieren consulta, corte, catálogo o acceso autorizado permanecen como Bloqueado o Pendiente.

| Campo | Valor |
|---|---|
| Fecha de ejecución | 2026-09-04, zona horaria America/Bogota |
| Fecha de corte | No suministrada |
| Módulo | Tableros de Monitoreo |
| Ejecutado por | David Sebastian Barrera Gaona |

## Significado de estados

- **Aprobado:** el criterio se demostró durante esta ejecución.
- **Fallido:** se observó una diferencia concreta frente al criterio.
- **Bloqueado:** la prueba necesita una fuente, permiso, regla o activo no disponible.
- **Pendiente:** no se ejecutó y no existe evidencia suficiente para clasificarla.

## Resultados por submódulo

### Datos Sin Limpiar (SECAD)

| Prueba | Resultado | Evidencia |
|---|---|---|
| Activación de hojas | Aprobado | Se activaron Historia, Últimos Días, Prioridad, Mapa, Patrullas, Llamante y METUN - OPERACIÓN XCRIME; no se observaron mensajes de carga fallida. |
| Parámetro Días | Aprobado | Se cambió de 30 a 7; se observaron actualizaciones en ocho visuales; se restableció a 30. |
| Filtro Sigla | Aprobado | Se aplicó `METUN`; se observaron actualizaciones en doce visuales; se restableció a `Todo`. |
| Conciliación con Athena por hoja (Llamante, Mapa, METUN, Últimos Días) | Aprobado | Las hojas registran la conciliación de totales y coordenadas con Athena como aprobada. |

### Métricas de Uso de la Plataforma

> **Evidencia histórica:** estos resultados corresponden al dashboard retirado. No validan el dashboard vigente `Actividad de usuarios en IAPOL`, documentado el 2026-10-13.

| Prueba | Resultado | Evidencia |
|---|---|---|
| Hojas publicadas | Aprobado | El dashboard publicado expone únicamente Información de usuarios y Uso mapa anticipacion. |
| Hojas internas | Aprobado | El análisis contiene además Información de usuarios (Anterior), Estadísticas de uso y Sheet 10; no aparecen en el dashboard publicado. |
| Filtro Estado | Aprobado | Se dejó únicamente `Con ingreso`; los KPI, gráficos y tabla reportaron actualización; se restableció a `Todo`. |
| Hoja Uso mapa anticipacion | Aprobado | Cargó sin error con controles de empleado, fecha inicial, fecha final y sigla. |
| Conciliación de usuarios y eventos (Información de usuarios) | Aprobado | La hoja registra la conciliación de usuarios únicos y eventos de ingreso con Athena como aprobada. |

### Monitoreo Componentes

| Prueba | Resultado | Evidencia |
|---|---|---|
| Apertura del contenedor | Aprobado | El submódulo abre su contenedor e intenta cargar un contenido embebido. |
| Contenido funcional | Bloqueado | La dependencia externa exige autenticación y no fue posible inspeccionar componentes, estados o filtros. |

### Tablero Monitoreo Pedidos SECAD v3.0

| Prueba | Resultado | Evidencia |
|---|---|---|
| Carga del tablero | Aprobado | Cargaron los KPI `Ultima Actualizacion (UP)`, `Ultima Actualizacion (Down)` y la tabla `Reporte Pedidos Secad` sin error visible. |
| Lógica de KPI | Aprobado en configuración | Se verificó `COUNT DISTINCT(sigla)`, umbral `<= 24` para UP y `> 24` para DOWN; DOWN además limita `hora_asigna` al año actual. |

### Última actualización de datos migrados

| Prueba | Resultado | Evidencia |
|---|---|---|
| Hojas publicadas | Aprobado | Se inventariaron CNP, DISEC, GEOPOL, SIVICC y TELEPOL. |
| Etiqueta accesible | Aprobado | En hojas distintas de CNP se observó que la tabla conservaba la etiqueta accesible `CNP`.|
| Conciliación de inventario y fechas con Athena (CNP, DISEC, GEOPOL, SIVICC, TELEPOL) | Aprobado | Cada hoja de dominio registra la conciliación de inventario, última partición/actualización y cálculo de días como aprobada. |

### Control de ingesta de datos de planta nacional

| Prueba | Resultado | Evidencia |
|---|---|---|
| Activación de hojas | Aprobado | Cargaron Monitoreo de archivos recibidos y Monitoreo carga de datos IAPOL con contenido diferente y sin error visible. |
| Días a visualizar | Aprobado | Se cambió de 20 a 10; cuatro visuales reportaron actualización; se restableció a 20. |
| Estado | Aprobado | Se desmarcó temporalmente `OK`; nueve visuales reportaron actualización; se restableció a `Todo`. |
| Tablas y estados | Aprobado visualmente | Se mostraron los KPI, gauges, tablas de archivos/refresh y etiquetas de estado esperadas. |
| Conciliación con Athena por hoja (archivos recibidos, carga IAPOL) | Aprobado | Las hojas registran como aprobadas la conciliación de archivos, refresh y crecimiento del dataset con Athena. |
| Fórmulas de gauges y KPI | Aprobado | El análisis informado apareció en el catálogo accesible y se registró su buen funcionamiento. |

## Resultado general

**Aprobado parcialmente con bloqueos pendientes.** Las pruebas funcionales resultaron mayoritariamente aprobadas y varias hojas registran su conciliación con Athena como aprobada. El módulo no puede declararse aprobado de forma integral mientras persistan los bloqueos vigentes: Monitoreo Componentes (autenticación externa), Uso mapa anticipacion (conciliación y frontera de fechas), coherencia semana/corte del Control de ingesta y las conciliaciones de Historia y Patrullas en Datos Sin Limpiar.

El bloqueo de `Uso mapa anticipacion` pertenece al dashboard de Métricas retirado y se conserva sólo como antecedente de esta ejecución. No aplica como resultado del dashboard vigente.

## Hallazgos que requieren seguimiento

| Código | Hallazgo | Prioridad sugerida |
|---|---|---|
| H-01 | Monitoreo Componentes permanece bloqueado por autenticación externa no satisfecha. | Media |

## Requisitos para desbloquear la validación de datos pendiente

1. Consultas autorizadas de Policía y Athena para los ítems aún marcados como Bloqueado.
2. Partición de Athena y fecha del refresco de SPICE.
3. Acceso autorizado al contenido embebido de Monitoreo Componentes.

[Volver al módulo](README.md)
