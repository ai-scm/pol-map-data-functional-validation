# Convenciones del repositorio

Este documento define las reglas de organización, documentación y nomenclatura del repositorio `pol-map-validation`.

## 1. Estructura funcional

Las capas deben organizarse según la estructura real de la aplicación:

```text
Módulo → Submódulo → Capa
```

Cada capa tendrá su propia carpeta:

```text
modulos/
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

🚩🚩🚩 No se deben crear módulos, submódulos o capas que no existan en la aplicación 🚩🚩🚩.

## 2. Nombres de carpetas

Los nombres de las carpetas deben:

- Escribirse en minúsculas.
- Utilizar guiones medios para separar palabras.
- Evitar espacios.
- Evitar tildes.
- Evitar la letra `ñ`.
- Evitar caracteres especiales.
- Corresponder al nombre funcional mostrado en la aplicación.

### Ejemplos correctos

```text
seguridad-ciudadana
delitos-materializados
policia-comunitaria
consulta-integrada
```

### Ejemplos incorrectos

```text
Seguridad Ciudadana
delitos_materializados
Policía-Comunitaria
ConsultaIntegrada
```

## 3. Nombres de archivos

Cada capa debe utilizar los siguientes nombres:

| Archivo | Propósito |
|---|---|
| `README.md` | Documentación y caso de prueba de la capa. |
| `athena.sql` | Consulta de validación en Athena. |
| `policia.sql` | Consulta de validación en la base de datos de la Policía. |
| `evidencias/README.md` | Registro de resultados y hallazgos. |

No se deben utilizar nombres como:

```text
consulta-final.sql
consulta-nueva.sql
consulta-corregida.sql
prueba2.sql
readme-nuevo.md
```

Los cambios deben controlarse mediante Git.

## 4. Identificación de las capas

Cada capa debe tener un identificador único con el siguiente formato:

```text
POL-MAPA-###
```

Ejemplos:

```text
POL-MAPA-001
POL-MAPA-002
POL-MAPA-003
```

El identificador debe registrarse en el `README.md` de la capa y en `catalogo-capas.md`.

Un identificador asignado no debe reutilizarse para otra capa.

## 5. Formato de fechas

Las fechas deben registrarse utilizando el formato:

```text
AAAA-MM-DD
```

Ejemplo:

```text
2026-08-11
```

Cuando se requiera fecha y hora, se utilizará:

```text
AAAA-MM-DD HH:mm
```

Ejemplo:

```text
2026-08-11 04:00
```

La hora debe interpretarse según la zona horaria utilizada por el proyecto.

## 6. Estados permitidos

### Estado de una capa

| Estado | Descripción |
|---|---|
| `Pendiente` | La documentación o las consultas no han sido creadas. |
| `En construcción` | El caso de prueba está siendo documentado. |
| `En revisión` | La documentación está pendiente de validación. |
| `Implementada` | La capa tiene documentación y consultas completas. |
| `Inactiva` | La capa no se encuentra disponible actualmente. |

### Resultado de una prueba

| Resultado | Descripción |
|---|---|
| `Aprobado` | Todas las validaciones cumplen los criterios definidos. |
| `Fallido` | Se encontró al menos una diferencia o error. |
| `Bloqueado` | La prueba no pudo completarse por una dependencia o problema externo. |
| `No ejecutado` | La prueba todavía no se ha realizado. |

## 7. Documentación de las capas

El `README.md` de cada capa debe contener como mínimo:

1. Identificación.
2. Descripción.
3. Ruta de acceso.
4. Pasos para activar la capa.
5. Parámetros y filtros.
6. Fuente de datos de la Policía.
7. Fuente de datos en Athena.
8. Reglas de transformación.
9. Validaciones funcionales.
10. Validaciones de datos.
11. Criterios de aceptación.
12. Resultado de la última ejecución.
13. Hallazgos.

Los campos desconocidos deben marcarse como:

```text
Pendiente por confirmar
```

No se debe completar información mediante suposiciones.

## 8. Consultas SQL

Cada capa debe tener dos consultas:

```text
sql/athena.sql
sql/policia.sql
```

Ambas consultas deben:

- Utilizar el mismo periodo de validación.
- Aplicar filtros de negocio equivalentes.
- Indicar el campo de fecha utilizado.
- Permitir comparar los resultados.
- Evitar modificaciones sobre las fuentes de datos.
- Contener únicamente operaciones de lectura.

Cada archivo debe comenzar con el siguiente encabezado:

```sql
-- ============================================================
-- Fecha de Creación: 2023-10-01
-- Campo de fecha utilizado: 
-- Reglas aplicadas:
============================================================
```


## 9. Fecha de corte

La comparación entre la base de datos de la Policía y Athena debe realizarse utilizando la misma fecha de corte.

La carga diaria del Data Lake se ejecuta alrededor de las `04:00 a. m.`. La base de datos de la Policía puede continuar recibiendo información después de esa hora.

Por cada ejecución se debe registrar:

- Fecha y hora de carga de Athena.
- Partición o periodo consultado.
- Fecha y hora de ejecución en la base de datos de la Policía.
- Campo utilizado para limitar el periodo.
- Filtros aplicados.
- Transformaciones realizadas durante la carga.

Una diferencia de cantidades no debe clasificarse automáticamente como error sin revisar primero estas condiciones.

## 10. Registro de resultados

Cada ejecución debe registrar:

| Campo | Valor |
|---|---|
| Fecha de ejecución | `AAAA-MM-DD HH:mm` |
| Fecha de corte | `AAAA-MM-DD HH:mm` |
| Cantidad Policía | Valor numérico |
| Cantidad Athena | Valor numérico |
| Cantidad mapa | Valor numérico |
| Diferencia Policía vs. Athena | Valor numérico |
| Diferencia Athena vs. mapa | Valor numérico |
| Resultado | Aprobado, Fallido, Bloqueado o No ejecutado |
| Ejecutado por | Nombre del responsable |
| Ticket relacionado | Número o `No aplica` |

Las diferencias deben acompañarse de una explicación o hallazgo.

## 11. Ejemplos de muestra

Las evidencias deben guardarse dentro de la carpeta correspondiente a la capa:

```text
evidencias/
```

Los nombres deben utilizar el siguiente formato:

```text
AAAA-MM-DD-descripcion.ext
```

Ejemplos:

```text
2026-08-11-cantidad-athena.png
2026-08-11-cantidad-policia.png
2026-08-11-visualizacion-mapa.png
```

No se deben almacenar imágenes o archivos que expongan información sensible.

## 12. Información sensible

No se debe incluir en el repositorio:

- Usuarios o contraseñas.
- Tokens de acceso.
- Cadenas de conexión.
- Credenciales de AWS.
- Direcciones internas sensibles.
- Datos personales.
- Resultados completos de producción.
- Archivos con información reservada.

Los scripts deben utilizar parámetros o valores de ejemplo cuando sea necesario.

## 13. Principio de trazabilidad

Toda validación debe permitir identificar:

```text
Fuente Policía → Athena → Capa del mapa
```

Cuando exista una diferencia, se debe establecer en cuál de los siguientes puntos se origina:

1. Consulta en la base de datos de la Policía.
2. Extracción o transformación hacia el Data Lake.
3. Información almacenada en Athena.
4. Consulta utilizada por la aplicación.
5. Representación de la información en el mapa.
