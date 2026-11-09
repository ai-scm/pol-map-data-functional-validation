# Mapa de Anticipación a Fenómenos de Seguridad — documentación funcional

Fecha de revisión: **2026-11-03**, zona horaria America/Bogota. Estado de documentación: **Verificación**.

Esta documentación cubre los nombres facilitados por el usuario y los controles encontrados en el código de XCrime publicado en AWS. El frontend se identificó mediante el manifiesto de `ponal-prod-xcrimeapp/XCrimeApp/`, actualizado el 2026-10-29.

## 1. Acceso

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Las fichas describen herramientas dentro del mapa. El submódulo Anticipación por Demanda del menú principal mantiene su propia documentación fuera de esta carpeta.

## 2. Catálogo funcional

| # | Nombre indicado | Documento | Correspondencia verificada |
|---|---|---|---|
| 01 | Consulta integrada | [Consulta integrada](<01-consulta-integrada/README.md>) | Título del panel abierto por Actores Potenciales. |
| 02 | Ataque con drones | [Ataque con drones](<02-ataque-con-drones/validacion-2026-11-03.md>) | Consulta nacional; documentación anterior conservada. |
| 03 | Actores potenciales | [Actores potenciales](<03-actores-potenciales/README.md>) | Nombre del acceso a Consulta integrada; misma herramienta. |
| 04 | Botón de Pánico | [Botón de Pánico](<04-boton-de-panico/README.md>) | Visualización APPPOL con actualización de 20 segundos. |
| 05 | Filtros | [Filtros](<05-filtros/README.md>) | Nombre del acceso: Capas de anticipación; ocho fichas solicitadas. |
| 06 | Capas | [Capas](<06-capas/README.md>) | Acceso Filtro por Fechas; 16 capas estáticas configuradas. |
| 07 | Homicidios | [Homicidios](<07-homicidios/README.md>) | Día y análisis por rango; prueba histórica enlazada. |
| 08 | Microterritorios | [Microterritorios](<08-microterritorios/README.md>) | Consulta, dibujo y gestión de polígonos. |
| 09 | Planes Gescov | [Planes Gescov](<09-planes-gescov/README.md>) | Programados y en ejecución; actualización de 10 minutos. |
| 10 | Anticipación por demanda | [Anticipación por demanda](<10-anticipacion-por-demanda/README.md>) | Catálogo por unidad/fecha y selección de anticipación. |
| 11 | Tipos de Minuta | [Tipos de Minuta](<11-tipos-de-minuta/README.md>) | Personal completo, cuatro minutas y Plan Democracia. |
| 12 | Servicios Extraordinarios | [Servicios Extraordinarios](<12-servicios-extraordinarios/README.md>) | Lista por descripción y unidad. |
| 13 | Fuentes Internas | [Fuentes Internas](<13-fuentes-internas/README.md>) | Nueve entradas en el catálogo global de AWS. |
| 14 | Fuentes Externas | [Fuentes Externas](<14-fuentes-externas/README.md>) | 60 entradas en el catálogo global, más controles específicos del frontend. |
| 15 | Policía Comunitaria | [Policía Comunitaria](<15-policia-comunitaria/README.md>) | Zonas del mes anterior por tipos territoriales. |


**Hallazgo de nomenclatura:** Consulta integrada y Actores Potenciales son el título del panel y el nombre del botón de una misma herramienta. No deben contarse como dos accesos independientes en esta versión.

El código contiene además [Top RNMC](16-top-rnmc/README.md), asociado al icono de tarjeta. El botón naranja de **Información planes preventivos** abre un mensaje condicionado por unidad y turno, relacionado con [Planes Preventivos](05-filtros/07-planes-preventivos/README.md). Por eso el número de iconos visibles depende del contexto y no permite deducir por sí solo el catálogo.

## 3. Controles de Capas de anticipación

1. [Anticipación](05-filtros/01-anticipacion/README.md).
2. [Porcentaje permanencia](05-filtros/02-porcentaje-permanencia/README.md).
3. [Zonas de atención actuales](05-filtros/03-zonas-de-atencion-actuales/README.md).
4. [Zonas de atención por Fusión](05-filtros/04-zonas-de-atencion-por-fusion/README.md).
5. [Patrullas](05-filtros/05-patrullas/README.md).
6. [Sugerencia Personal de Apoyo](05-filtros/06-sugerencia-personal-de-apoyo/README.md).
7. [Planes Preventivos](05-filtros/07-planes-preventivos/README.md).
8. [Delitos materializados](05-filtros/08-delitos-materializados/README.md).


El panel incluye otros controles condicionales: Hechos reales, Instituciones, Microterritorios, Alertas Iris P1 y Demanda - Zonas por Fusión. Se registran en [la ficha del panel](05-filtros/README.md).

## 4. Evidencia y alcance

- [Versión publicada, comprobaciones de AWS y límites de validación](evidencia-validacion-2026-11-03.md).
- [Catálogo externo leído en AWS](14-fuentes-externas/catalogo-2026-11-03.md).
- Confirmado: presencia y comportamiento en el código, catálogo de categorías/capas y ejecución del job de fuentes internas.
- No ejecutado: navegación autenticada, consultas con datos personales, escrituras operativas y reconciliación de registros entre Policía, Athena, servicios y mapa.
- Las listas de validación de cada ficha permanecen pendientes hasta su ejecución funcional.

## 5. Documentación existente

Las carpetas se numeraron el **2026-11-04** según el orden indicado por el usuario: del `01-` al `15-`. Top RNMC, encontrado durante la validación anterior, queda como `16-top-rnmc`. Los ocho controles dentro de `05-filtros` siguen también el orden indicado, del `01-` al `08-`. Los nombres usan minúsculas y guiones. Esta numeración corresponde a la organización documental solicitada y no atribuye un orden distinto a los accesos de la aplicación. Se conservan los documentos, capturas y consultas existentes; los enlaces se actualizan a las nuevas rutas.

Estas son fichas de funcionalidades y controles; no se asignan nuevos identificadores POL-MAPA de capas ni se alteran los identificadores existentes.
