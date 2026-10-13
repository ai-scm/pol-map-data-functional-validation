# Métricas de Uso de la Plataforma

## Objetivo

Documenta el dashboard vigente `Actividad de usuarios en IAPOL`, orientado al seguimiento de usuarios con actividad y al volumen de eventos registrados en la plataforma.

La documentación anterior fue retirada porque correspondía a un dashboard que ya no existe. Las hojas `Información de usuarios`, `Uso mapa anticipacion`, `Información de usuarios (Anterior)`, `Estadísticas de uso` y `Sheet 10` no pertenecen a la definición vigente recibida.

## Ruta funcional

`Home > Tableros de Monitoreo > Métricas de Uso de la Plataforma`

La ruta debe confirmarse en la aplicación. El JSON acredita el nombre del dashboard en Amazon Quick, pero no la etiqueta del menú ni los permisos de acceso.

## Identificación y alcance

| Elemento | Valor confirmado |
|---|---|
| Dashboard en Amazon Quick | `Actividad de usuarios en IAPOL` |
| Estado de la definición | `CREATION_SUCCESSFUL` |
| Errores reportados por la exportación | Ninguno |
| Hojas | 2 |
| Visuales | 16 |
| Datasets | `eventos_IAPOL` y `User_Roles` |
| Modo | SPICE en ambos datasets |
| Campos calculados del dashboard | 48 |
| Parámetros | 3 |
| Grupos de filtros | 23: 18 habilitados y 5 deshabilitados |
| Fecha de revisión documental | 2026-10-13 |
| Validación en pantalla y de cifras | No ejecutada con esta definición |

## Hojas vigentes

| Hoja | Visuales | Propósito | Documento |
|---|---:|---|---|
| Actividad de usuarios en IAPOL | 9 | Seguimiento de actividad diaria, mensual, semestral y anual; estado de actividad y roles de ExpertoPol. | [actividad-de-usuarios-en-iapol](actividad-de-usuarios-en-iapol/README.md) |
| Eventos de usuarios en IAPOL | 7 | Volumen de eventos por periodo, sigla, usuario y tipo de evento. | [eventos-de-usuarios-en-iapol](eventos-de-usuarios-en-iapol/README.md) |

## Fuente de datos resumida

Los dos datasets usan consultas SQL personalizadas sobre Athena:

```text
eventos_IAPOL
    users_keycloak
        LEFT JOIN personal agrupado
        LEFT JOIN event_table

User_Roles
    users_keycloak
        LEFT JOIN personal agrupado
        LEFT JOIN event_table
        LEFT JOIN eventos
        LEFT JOIN usuarios_roles
```

Ambas consultas conservan únicamente usuarios con `sigla_laborando` informada. La definición completa, fórmulas, filtros y riesgos de agregación están en [documentacion-tecnica.md](documentacion-tecnica.md).

## Validaciones funcionales pendientes

- [ ] Confirmar la ruta del menú y el acceso de los perfiles autorizados.
- [ ] Verificar que las dos hojas y sus 16 visuales carguen sin errores.
- [ ] Comprobar el alcance real de cada control cuando la hoja mezcla datasets.
- [ ] Verificar que el control de fecha mostrado en la hoja de eventos afecte algún visual de esa hoja.
- [ ] Comprobar los KPI de hoy, mes, seis meses y año usando fechas en los límites.
- [ ] Validar el Top 10 de siglas y usuarios, incluido su criterio de orden.
- [ ] Verificar la exportación CSV y el acceso a tablas con atributos personales.

## Validaciones de datos pendientes

- Conciliar usuarios distintos y eventos con Athena usando el mismo instante de corte.
- Confirmar si las sumas de campos `countOver(..., PRE_FILTER)` representan eventos sin duplicación.
- Medir la multiplicación de filas producida por las uniones de eventos y roles en `User_Roles`.
- Confirmar el tratamiento horario: `eventos_IAPOL` resta cinco horas, mientras `User_Roles` analiza una fecha parseada sin ajuste visible.
- Verificar nulos, fechas futuras, usuarios sin eventos y usuarios con varias siglas, roles o registros de personal.
- Confirmar la programación y la última ingesta exitosa de cada dataset SPICE.

## Manejo de información sensible

Los datasets contienen `username`, nombres, apellidos, correo, teléfono, dirección y atributos institucionales. La hoja de actividad incluye tablas con datos de usuario y la exportación CSV está habilitada. No se deben guardar filas reales, identificadores personales ni exportaciones productivas en este repositorio.

Las definiciones recibidas no declaran seguridad por fila o columna. Esto no demuestra acceso abierto: los permisos del dashboard no forman parte de los archivos entregados y deben revisarse por separado.

## Estado documental

La estructura y configuración de Amazon Quick están documentadas con la evidencia disponible. El estado permanece **En verificación** hasta comprobar controles, permisos y cifras en la aplicación.
