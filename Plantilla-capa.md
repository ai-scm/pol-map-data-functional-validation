# Nombre de la capa

## 1. Identificación

| Campo | Valor |
|---|---|
| ID | POL-MAPA-001 |
| Módulo | Nombre del módulo |
| Submódulo | Nombre del submódulo |
| Capa | Nombre visible de la capa |
| Estado | Activa / Inactiva / En revisión |
| Responsable | Nombre o equipo |
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
- Consulta: [policia.sql](sql/policia.sql)

### Data Lake en Athena

- Catálogo:
- Base de datos:
- Tabla o vista:
- Partición utilizada:
- Campo de fecha:
- Llave del registro:
- Consulta: [athena.sql](sql/athena.sql)

## 7. Reglas de transformación

Documentar filtros, exclusiones, agrupaciones o transformaciones aplicadas
durante la carga al Data Lake.

Ejemplos:

- Se excluyen registros anulados.
- Se conserva el registro más reciente por identificador.
- Las coordenadas inválidas se almacenan como NULL.
- La fecha utilizada corresponde a la fecha del hecho.

## 8. Validaciones funcionales

- [ ] La capa aparece en el módulo y submódulo correctos.
- [ ] La capa puede activarse y desactivarse.
- [ ] El nombre y la descripción son correctos.
- [ ] Los filtros modifican la información mostrada.
- [ ] Los puntos aparecen en el área geográfica esperada.
- [ ] El detalle del punto muestra los campos definidos.
- [ ] La leyenda y los colores corresponden a la capa.
- [ ] No se presentan errores al cargar la información.

## 9. Validaciones de datos

- [ ] La fecha de actualización de Athena es la esperada.
- [ ] Ambas consultas utilizan el mismo periodo de corte.
- [ ] Los filtros de negocio son equivalentes.
- [ ] La cantidad total coincide.
- [ ] Las cantidades coinciden por departamento.
- [ ] Las cantidades coinciden por municipio.
- [ ] No existen identificadores duplicados.
- [ ] Los campos obligatorios no contienen valores nulos inesperados.
- [ ] Las coordenadas cumplen el formato esperado.
- [ ] Una muestra de registros coincide entre ambas fuentes.
- [ ] La cantidad mostrada en el mapa coincide con Athena.

## 10. Criterios de aceptación

La prueba es exitosa cuando:

1. La capa carga sin errores.
2. La información corresponde al periodo seleccionado.
3. Athena y la fuente de Policía coinciden después de aplicar las reglas
   de transformación.
4. La cantidad del mapa coincide con el resultado esperado en Athena.
5. No existen diferencias sin justificación documentada.

## 11. Resultado de la última ejecución

| Campo | Resultado |
|---|---|
| Fecha de ejecución | AAAA-MM-DD HH:mm |
| Fecha de corte validada | AAAA-MM-DD |
| Cantidad Policía | 0 |
| Cantidad Athena | 0 |
| Cantidad mostrada en el mapa | 0 |
| Diferencia Policía vs. Athena | 0 |
| Diferencia Athena vs. mapa | 0 |
| Resultado | Aprobado / Fallido |
| Ejecutado por | Nombre |

## 12. Hallazgos

Describir las diferencias encontradas, su posible causa y el ticket
relacionado, cuando corresponda.