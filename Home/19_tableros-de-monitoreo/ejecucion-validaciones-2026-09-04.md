# Ejecución de validaciones — 2026-09-04

## Alcance

Validación funcional realizada sobre la interfaz autenticada de la aplicación y Amazon Quick. Se comprobaron navegación, carga, hojas, controles, respuesta de visuales y restablecimiento cuando fue posible. No se dispuso de consultas autorizadas a la fuente Policía ni a Athena; por tanto, ninguna conciliación de datos se declara aprobada.

| Campo | Valor |
|---|---|
| Fecha de ejecución | 2026-09-04, zona horaria America/Bogota |
| Fecha de corte | No suministrada |
| Módulo | Tableros de Monitoreo |
| Ejecutado por | Codex mediante la sesión autenticada del usuario |
| Cantidad Policía | No consultada |
| Cantidad Athena | No consultada |
| Evidencia | Metadatos, estados de carga y respuesta de controles; sin filas productivas |

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
| Valores sin clasificar | Fallido | En Historia aparecen categorías `null` y `Otro`; no se encontró una regla de negocio que las justifique. |
| Conciliación Policía–Athena | Bloqueado | No se proporcionaron consultas, partición, corte ni acceso a las fuentes. |
| Validación geográfica | Bloqueado | El mapa carga y usa latitud/longitud, pero no existe una fuente de referencia para demostrar ubicación y cobertura. |

### Métricas de Uso de la Plataforma

| Prueba | Resultado | Evidencia |
|---|---|---|
| Hojas publicadas | Aprobado | El dashboard publicado expone únicamente Información de usuarios y Uso mapa anticipacion. |
| Hojas internas | Aprobado | El análisis contiene además Información de usuarios (Anterior), Estadísticas de uso y Sheet 10; no aparecen en el dashboard publicado. |
| Filtro Estado | Aprobado | Se dejó únicamente `Con ingreso`; los KPI, gráficos y tabla reportaron actualización; se restableció a `Todo`. |
| Hoja Uso mapa anticipacion | Aprobado | Cargó sin error con controles de empleado, fecha inicial, fecha final y sigla. |
| Inclusividad y zona horaria | Bloqueado | La configuración del intervalo es visible, pero no se contó con eventos de frontera ni consulta Athena. |
| Alcance de usuarios | Bloqueado | Los filtros técnicos se confirmaron, pero no se contó con el padrón autorizado para demostrar exclusiones. |
| Conciliación de usuarios y eventos | Bloqueado | Sin acceso a Policía/Athena ni fecha de corte común. |

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
| Coherencia temporal y territorial | Bloqueado | No se conoce unidad del intervalo, zona horaria, lista completa de orígenes ni fuente de comparación. |
| Correspondencia de filas | Bloqueado | No se suministró una muestra anonimizada ni llave funcional para comprobar registros. |

### Última actualización de datos migrados

| Prueba | Resultado | Evidencia |
|---|---|---|
| Hojas publicadas | Aprobado | Se inventariaron CNP, DISEC, GEOPOL, SIVICC y TELEPOL. |
| Análisis y fórmula | Bloqueado | El análisis informado no apareció en el catálogo accesible; no se pudieron extraer fuente, cálculo de días ni umbrales. |
| Conciliación por dominio | Bloqueado | Sin inventario autorizado, fechas/particiones de Athena ni corte común. |
| Etiqueta accesible | Fallido | En hojas distintas de CNP se observó que la tabla conservaba la etiqueta accesible `CNP`; requiere revisión. |

### Control de ingesta de datos de planta nacional

| Prueba | Resultado | Evidencia |
|---|---|---|
| Activación de hojas | Aprobado | Cargaron Monitoreo de archivos recibidos y Monitoreo carga de datos IAPOL con contenido diferente y sin error visible. |
| Días a visualizar | Aprobado | Se cambió de 20 a 10; cuatro visuales reportaron actualización; se restableció a 20. |
| Estado | Aprobado | Se desmarcó temporalmente `OK`; nueve visuales reportaron actualización; se restableció a `Todo`. |
| Tablas y estados | Aprobado visualmente | Se mostraron los KPI, gauges, tablas de archivos/refresh y etiquetas de estado esperadas. |
| Conciliación de archivos y Athena | Bloqueado | No se proporcionaron inventario esperado, consulta Athena, corte ni reglas de duplicado. |
| Fórmulas de gauges y KPI | Bloqueado | El análisis informado no apareció en el catálogo accesible. |

## Resultado general

**Bloqueado para aceptación integral de datos.** Las pruebas funcionales ejecutadas resultaron mayoritariamente aprobadas, con dos hallazgos documentales/funcionales. Los criterios generales exigen conciliación con Policía y Athena; sin esas evidencias el módulo completo no puede declararse aprobado.

## Hallazgos que requieren seguimiento

| Código | Hallazgo | Prioridad sugerida |
|---|---|---|
| H-01 | Categorías `null` y `Otro` en sigla/origen de Historia sin regla documentada. | Media |
| H-02 | Etiqueta accesible `CNP` reutilizada en hojas de otros dominios del tablero de migrados. | Media |
| H-03 | UP y DOWN de Pedidos SECAD no comparten el mismo filtro de año actual. | Alta |
| H-04 | El análisis informado de Migrados no es localizable con el nombre suministrado. | Media |
| H-05 | El análisis informado de Planta Nacional no es localizable con el nombre suministrado. | Media |
| H-06 | En Estadísticas de uso, el título indica usuarios por día pero la medida es recuento, no conteo distinto. | Alta antes de publicar |
| H-07 | `Sheet 10` usa un intervalo fijo histórico y un nombre no funcional. | Baja mientras permanezca no publicada |

## Requisitos para desbloquear la validación de datos

1. Consultas autorizadas de Policía y Athena.
2. Fecha/hora de corte común, campo de fecha y zona horaria.
3. Partición de Athena y fecha del refresco de SPICE.
4. Llaves funcionales para pedidos, usuarios, eventos, tablas y archivos.
5. Reglas de exclusión, homologación, duplicado y tratamiento de nulos.
6. Muestra anonimizada con la cual comprobar detalle y coordenadas.

[Volver al módulo](README.md)
