# Nombre de la capa

## 1. Identificación

| Campo | Valor |
|---|---|
| ID | POL-MAPA-001 |
| Módulo | Nombre del módulo |
| Capa | Nombre visible de la capa |
| Frecuencia de actualización | Diaria |
| Hora de carga del Data Lake | 04:00 a. m. |
| Última actualización del caso | AAAA-MM-DD |

## 2. Descripción

Explicación corta de la información que representa la capa y cuál es
su propósito dentro del mapa.

## 3. Ruta de acceso

1. Ingresar al sistema.
2. Abrir el módulo `[nombre]`.
3. Seleccionar el submódulo `[nombre]`.
4. Ingresar a `[opción]`.

Ruta resumida:

`Menú principal > Módulo > Submódulo > Mapa`

## 4. Activación de la capa

1. Abrir el panel de capas.
2. Localizar la categoría `[nombre]`.
3. Activar la capa `[nombre]`.
4. Aplicar los filtros requeridos.

## 5. Parámetros y filtros de prueba

| Parámetro | Valor utilizado | Obligatorio |
|---|---|---|
| Fecha inicial | AAAA-MM-DD | Sí |
| Fecha final | AAAA-MM-DD | Sí |
| Departamento | Todos | No |
| Municipio | Todos | No |

## 6. Fuente de datos

### Base de datos de la Policía

- Sistema o base de datos:
- Esquema:
- Tabla o vista:
- Campo de fecha:
- Llave del registro:

### Data Lake en Athena

- Catálogo:
- Base de datos:
- Tabla o vista:
- Partición utilizada:
- Campo de fecha:
- Llave del registro:
- Consulta Athena: [athena.sql](sql/1.Athena.sql)
- Consulta a DB Policia: [Oracle.sql](sql/2.Oracle.sql)


## 7. Validaciones funcionales

- [ ] La capa puede activarse y desactivarse.
- [ ] El detalle del punto muestra los campos definidos.
- [ ] El nombre y la descripción son correctos.
- [ ] Los filtros modifican la información mostrada.
- [ ] Los puntos aparecen en el área geográfica esperada.

- [ ] La leyenda y los colores corresponden a la capa.
- [ ] No se presentan errores al cargar la información.

## 8. Validaciones de datos

- [ ] La fecha de actualización de Athena es la esperada.
- [ ] Los filtros de negocio son equivalentes.
- [ ] La cantidad total coincide.
- [ ] No existen identificadores duplicados.
- [ ] Una muestra de registros coincide entre ambas fuentes.
- [ ] La cantidad mostrada en el mapa coincide con Athena.

## 9. Criterios de aceptación

La prueba es exitosa cuando:

1. La capa carga sin errores.
2. La información corresponde al periodo seleccionado.
3. Athena y la fuente de Policía coinciden después de aplicar las reglas
   de transformación.
4. La cantidad del mapa coincide con el resultado esperado en Athena.
5. No existen diferencias sin justificación documentada.


## 10. Imagen guia de visualizacion 

