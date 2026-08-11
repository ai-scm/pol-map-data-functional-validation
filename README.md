# POL Map Validation

Repositorio de validación de datos para las capas del mapa del proyecto Policía.

## Objetivo

Centralizar  los casos de prueba necesarios para validar los datos de la policia vs los mostrados en los componentes:

- La navegación hasta cada funcionalidad del mapa.
- La activación y visualización de las capas.
- validacion de filtros y controles.
- La información representada por cada capa.
- La consistencia entre la base de datos de la Policía, el Data Lake en Athena y los datos mostrados en el mapa.

## Flujo de validación

Cada capa debe validarse en los siguientes niveles:

```text
Base de datos de la Policía → Data Lake en Athena → Capa del mapa
```

1. **Base de datos de la Policía:** fuente de origen de la información.
2. **Athena:** información cargada diariamente en el Data Lake.
3. **Mapa:** datos finalmente consultados y representados por la aplicación.


## Alcance

El repositorio contiene, para cada capa:

- Módulo y submódulo al que pertenece.
- Descripción funcional.
- Ruta de acceso desde el menú.
- Pasos para activar la capa.
- Filtros y parámetros disponibles.
- Validaciones funcionales.
- Validaciones de calidad de datos.
- Consulta SQL para Athena.
- Consulta SQL para la base de datos de la Policía.
- Criterios de aceptación.
- Imagen guia de visualizacion de las capas.

## Estructura del repositorio

```text
pol-map-validation/
├── README.md
├── catalogo-capas.md
├── convenciones.md
│
├── modulos/
│   └── nombre-modulo/
│       └── nombre-submodulo/
│           └── nombre-capa/
│               ├── README.md
│               └── sql/
│                   ├── athena.sql
│                   └── policia.sql
│               
│
└── plantilla-capa.md
```

## Organización

La documentación sigue la jerarquía funcional de la aplicación:

```text
Módulo → Submódulo → Capa
```

Cada carpeta de capa representa un caso de prueba independiente.

### Ejemplo

```text
modulos/
└── mapa/
    └── seguridad-ciudadana/
        └── homicidios/
            ├── README.md
            ├── sql/
            │   ├── athena.sql
            │   └── policia.sql
            └── evidencias/
                └── README.md
```

## Archivos de una capa

| Archivo | Descripción |
|---|---|
| `README.md` | Documentación y caso de prueba de la capa. |
| `sql/athena.sql` | Consulta para validar la información disponible en Athena. |
| `sql/policia.sql` | Consulta equivalente sobre la base de datos de la Policía. |
| `evidencias/README.md` | Resultados, diferencias y hallazgos de las ejecuciones. |

## Validaciones funcionales

Como mínimo, cada capa debe comprobar:

- Que aparece en el módulo y submódulo correctos.
- Que puede activarse y desactivarse.
- Que carga sin errores.
- Que los filtros modifican los resultados.
- Que los puntos o elementos aparecen en la ubicación esperada.
- Que la leyenda, colores y símbolos son correctos.
- Que la información mostrada en el detalle corresponde al registro seleccionado.
- Que no aparecen registros fuera del alcance definido.

## Validaciones de datos

Como mínimo, se debe validar:

- Fecha de actualización de Athena.
- Fecha de corte utilizada en ambas fuentes.
- Cantidad total de registros.
- Cantidades agrupadas por departamento y municipio.
- Registros duplicados.
- Campos obligatorios con valores nulos.
- Registros sin coordenadas.
- Formato y validez de las coordenadas.
- Muestra de registros entre Policía y Athena.
- Cantidad consultada en Athena frente a la mostrada en el mapa.

## Consideraciones para comparar las fuentes

La base de datos de la Policía puede continuar recibiendo información después de la carga diaria del Data Lake. Por lo tanto, una diferencia de cantidades no implica necesariamente un error.

Antes de comparar se debe verificar:

1. Que las consultas utilicen el mismo periodo.
2. Que tengan los mismos filtros de negocio.
3. Que utilicen el mismo campo de fecha.
4. Que se consideren las transformaciones realizadas durante la carga.
5. Que Athena tenga disponible la partición correspondiente.
6. Que se conozca la fecha y hora de corte de la extracción.

Si la carga aplica exclusiones, agrupaciones, homologaciones o eliminación de duplicados, estas reglas deben documentarse en el `README.md` de la capa.

## Criterios generales de aceptación

Una capa se considera aprobada cuando:

1. Es posible acceder y activarla correctamente.
2. Carga la información sin errores.
3. Los filtros funcionan según lo esperado.
4. La información corresponde al periodo seleccionado.
5. Athena contiene los datos esperados de acuerdo con la fuente de Policía.
6. El mapa representa correctamente la información consultada en Athena.
7. No existen diferencias sin justificación documentada.

## Registro de resultados

Cada ejecución debe registrar como mínimo:

| Campo | Descripción |
|---|---|
| Fecha de ejecución | Momento en que se realizó la prueba. |
| Fecha de corte | Periodo de información validado. |
| Cantidad Policía | Resultado de la consulta en la fuente de origen. |
| Cantidad Athena | Resultado de la consulta en el Data Lake. |
| Cantidad mapa | Información mostrada por la aplicación. |
| Resultado | Aprobado, fallido o bloqueado. |
| Ejecutado por | Persona responsable de la validación. |
| Hallazgos | Diferencias, errores u observaciones encontradas. |
| Ticket relacionado | Incidente, problema o RFC asociado, si aplica. |

## Convenciones de nombres

Los nombres de carpetas y archivos deben:

- Escribirse en minúsculas.
- Usar guiones medios para separar palabras.
- Evitar espacios, tildes y caracteres especiales.
- Utilizar el nombre funcional visible en la aplicación.

Ejemplos:

```text
seguridad-ciudadana
delitos-materializados
policia-comunitaria
consulta-integrada
```

## Manejo de información sensible

Este repositorio no debe contener:

- Credenciales.
- Contraseñas.
- Cadenas de conexión.
- Tokens de acceso.
- Datos personales.
- Exportaciones completas de información productiva.
- Direcciones internas que no deban quedar versionadas.

Los valores sensibles deberán manejarse mediante los mecanismos de configuración autorizados para el proyecto.

## Estado del repositorio

Repositorio en construcción. Las capas se incorporarán progresivamente de acuerdo con los módulos y submódulos disponibles en el proyecto Policía.
