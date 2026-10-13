# POL Map Validation

Repositorio de documentación y validación de la aplicación del proyecto Policía.

El repositorio tiene dos frentes de trabajo:

1. **Documentación funcional de los módulos** de la aplicación, con una carpeta por módulo en la raíz del repositorio.
2. **Validación de datos de las capas del mapa**, organizada en la carpeta `Modulos/`.

## 1. Documentación de módulos

Cada módulo de la aplicación se documenta en su propia carpeta ubicada en la raíz del repositorio. La documentación se incorpora de forma incremental, de modo que la lista de módulos es abierta y puede crecer a medida que se documentan nuevos módulos del menú.

### Objetivo

Documentar cada módulo y submódulo de la aplicación y llevar el control de avance mediante una checklist con estado, responsable y fecha de actualización.

### Estructura de un módulo

```text
<nombre-modulo>/
├── README.md                 # Documentación y checklist del módulo
└── <nombre-submodulo>/
    └── README.md
```

Ejemplo con los módulos documentados actualmente:

```text
plantilla-modulo.md           # Plantilla base para documentar un módulo
│
├── anticipacion-a-fenomenos-de-seguridad/
│   └── README.md
├── expertopol/
│   └── README.md
├── informacion-estadistica-delictiva/
│   └── README.md
└── tableros-de-monitoreo/
    └── README.md
```

- Cada carpeta de módulo usa el nombre funcional del módulo, sin prefijos numéricos.
- Cada módulo documenta sus submódulos en su propio `README.md`.
- Se pueden agregar nuevos módulos creando una carpeta adicional en la raíz, siguiendo la misma estructura.

### Estados de documentación

| Estado | Descripción |
|---|---|
| `Faltante` | La documentación aún no se ha iniciado. |
| `En progreso` | La documentación se está redactando. |
| `Verificación` | La documentación está redactada y pendiente de revisión. |
| `Terminado` | La documentación está completa y verificada. |

### Contenido mínimo de cada módulo

1. Identificación (orden en el menú, nombre, ruta de acceso, estado, responsable, fecha).
2. Descripción.
3. Lista de submódulos.
4. Checklist de submódulos con estado, responsable, fecha de actualización y casilla de documentado.
5. Progreso del módulo.
6. Hallazgos y notas.

## 2. Validación de capas del mapa (`Modulos/`)

La carpeta `Modulos/` centraliza los casos de prueba para validar los datos de la Policía frente a los mostrados en las capas del mapa.

### Objetivo

Validar:

- La navegación hasta cada funcionalidad del mapa.
- La activación y visualización de las capas.
- Los filtros y controles.
- La información representada por cada capa.
- La consistencia entre la base de datos de la Policía, el Data Lake en Athena y los datos mostrados en el mapa.

### Flujo de validación

```text
Base de datos de la Policía → Data Lake en Athena → Capa del mapa
```

1. **Base de datos de la Policía:** fuente de origen de la información.
2. **Athena:** información cargada diariamente en el Data Lake.
3. **Mapa:** datos finalmente consultados y representados por la aplicación.

### Estructura de una capa

```text
Modulos/
└── nombre-modulo/
    └── nombre-submodulo/
        └── nombre-capa/
            ├── README.md
            ├── sql/
            │   ├── athena.sql
            │   └── policia.sql
            └── evidencias/
                └── README.md
```

Cada carpeta de capa representa un caso de prueba independiente.

### Archivos de una capa

| Archivo | Descripción |
|---|---|
| `README.md` | Documentación y caso de prueba de la capa. |
| `sql/athena.sql` | Consulta para validar la información disponible en Athena. |
| `sql/policia.sql` | Consulta equivalente sobre la base de datos de la Policía. |
| `evidencias/README.md` | Resultados, diferencias y hallazgos de las ejecuciones. |

### Validaciones funcionales

Como mínimo, cada capa debe comprobar:

- Que aparece en el módulo y submódulo correctos.
- Que puede activarse y desactivarse.
- Que carga sin errores.
- Que los filtros modifican los resultados.
- Que los puntos o elementos aparecen en la ubicación esperada.
- Que la leyenda, colores y símbolos son correctos.
- Que la información mostrada en el detalle corresponde al registro seleccionado.
- Que no aparecen registros fuera del alcance definido.

### Validaciones de datos

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

### Consideraciones para comparar las fuentes

La base de datos de la Policía puede continuar recibiendo información después de la carga diaria del Data Lake. Por lo tanto, una diferencia de cantidades no implica necesariamente un error.

Antes de comparar se debe verificar:

1. Que las consultas utilicen el mismo periodo.
2. Que tengan los mismos filtros de negocio.
3. Que utilicen el mismo campo de fecha.
4. Que se consideren las transformaciones realizadas durante la carga.
5. Que Athena tenga disponible la partición correspondiente.
6. Que se conozca la fecha y hora de corte de la extracción.

Si la carga aplica exclusiones, agrupaciones, homologaciones o eliminación de duplicados, estas reglas deben documentarse en el `README.md` de la capa.

### Criterios generales de aceptación

Una capa se considera aprobada cuando:

1. Es posible acceder y activarla correctamente.
2. Carga la información sin errores.
3. Los filtros funcionan según lo esperado.
4. La información corresponde al periodo seleccionado.
5. Athena contiene los datos esperados de acuerdo con la fuente de Policía.
6. El mapa representa correctamente la información consultada en Athena.
7. No existen diferencias sin justificación documentada.

### Registro de resultados

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
- No usar prefijos numéricos en las carpetas de módulo ni de submódulo.

Ejemplos:

```text
seguridad-ciudadana
delitos-materializados
policia-comunitaria
consulta-integrada
anticipacion-a-fenomenos-de-seguridad
tableros-de-monitoreo
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

Repositorio en construcción. La documentación de módulos y las capas del mapa en `Modulos/` se incorporarán progresivamente de acuerdo con los módulos y submódulos disponibles en el proyecto Policía. La lista de módulos es abierta y seguirá creciendo a medida que se documenten nuevos módulos del menú.
