# Actividad de usuarios en IAPOL

## Propósito

Presenta usuarios con actividad reciente, evolución mensual, estado de actividad y distribución de usuarios por roles asociados a Chatbot y ExpertoPol.

La hoja contiene nueve visuales. Siete consumen `User_Roles` y dos consumen `eventos_IAPOL`, por lo que los controles no necesariamente afectan a toda la hoja de la misma forma.

## Visuales definidos

Las referencias H1-V01 a H1-V09 siguen el orden de la definición JSON y no representan la posición física en pantalla.

| Referencia | Tipo | Título o medida principal | Dataset | Configuración |
|---|---|---|---|---|
| H1-V01 | KPI | Usuarios con actividad durante el mes | `User_Roles` | Campo calculado `usuarios_actividad_mes`. |
| H1-V02 | KPI | Usuarios activos en seis meses | `User_Roles` | Campo calculado `usuarios_activos_6_meses`. |
| H1-V03 | Tabla | Usuarios con actividad hoy | `eventos_IAPOL` | Usuario, nombre, apellido, sigla, correo, grado, última actividad y conteo distinto de usuario. |
| H1-V04 | KPI | Usuarios con ingreso en el día actual | `eventos_IAPOL` | Campo `Usuarios_ingreso_dia_actual`. |
| H1-V05 | KPI | Usuarios con actividad en el año | `User_Roles` | Campo `usuarios_actividad_año`; su alcance anual también depende del filtro F22. |
| H1-V06 | Barras | Estado de actividad | `User_Roles` | Conteo distinto de `username` por `estado_actividad`; filtro adicional del año actual. |
| H1-V07 | Línea | Usuarios activos por mes | `User_Roles` | Conteo distinto de `username` por `fecha_evento_eve`. |
| H1-V08 | Tabla | Usuarios por rol - Chatbot - ExpertoPol | `User_Roles` | Conteo distinto de `username` por `grupos_chatbot`. |
| H1-V09 | Tabla | Estado y correo del usuario | `User_Roles` | Dimensiones `estado_user` y `correo_electronico`; no tiene título explícito. |

Los KPI H1-V01, H1-V02, H1-V04 y H1-V05 tienen el título oculto en la definición. Los nombres anteriores describen el campo usado; deben confirmarse contra el texto visible en pantalla.

## Controles visibles

| Control | Dataset | Campo | Alcance técnico |
|---|---|---|---|
| Estado | `eventos_IAPOL` | `estado_user` | Sólo visuales que consumen `eventos_IAPOL`. |
| Sigla | `User_Roles` | `sigla_laborando` | Visuales de `User_Roles`; excluye nulos. |
| fecha_evento_eve | `User_Roles` | `fecha_evento_eve` | Filtro relativo al año actual; excluye nulos. |
| Estado Empleado | `User_Roles` | `estado_empleado` | Visuales de `User_Roles`; la configuración incluye `AC`. |

No hay acciones de filtrado por clic configuradas en los nueve visuales.

## Lógica principal

### Actividad del mes

```text
distinctCountIf(
  username,
  truncDate("MM", parseDate(fecha_evento_ev, "yyyy-MM-dd HH:mm:ss"))
    = truncDate("MM", now())
)
```

### Actividad en seis meses

```text
distinctCountIf(
  username,
  dateDiff(parseDate(fecha_evento_ev, "yyyy-MM-dd HH:mm:ss"), now(), "MM") <= 6
)
```

La fórmula no declara un límite inferior. Una fecha futura también puede cumplir `<= 6`; debe probarse con datos controlados.

### Actividad en el año

```text
distinctCountIf(username, isNotNull(fecha_evento_ev))
```

La fórmula no contiene por sí misma una condición de año. El alcance anual proviene del filtro relativo F22 sobre `fecha_evento_eve`. Si se retira o modifica ese filtro, el nombre del indicador dejaría de describir su cálculo.

### Estado de actividad

```text
dias_sin_interaccion =
abs(dateDiff(now(), maxOver(fecha_evento_eve, [username], PRE_AGG), "DD"))

estado_actividad =
ifelse(
  estado_user = 'Sin ingreso', 'Nunca ingresó',
  dias_sin_interaccion <= 10, '0–10 días',
  dias_sin_interaccion <= 30, '11–30 días',
  dias_sin_interaccion <= 60, '31–60 días',
  'Más de 60 días'
)
```

El filtro global F22 excluye fechas nulas del año actual. Debe verificarse si esto elimina a los usuarios `Sin ingreso` antes de clasificarlos como `Nunca ingresó`.

### Roles de Chatbot y ExpertoPol

`grupos_chatbot` homologa seis valores técnicos:

| Valor fuente | Etiqueta mostrada |
|---|---|
| `admin_chatbot` | Admin Chatbot |
| `chatbot` | Acceso a ExpertoPol |
| `chatbot_documentacion` | Documentación |
| `estadistica_homicidio` | Delitos y Capturas |
| `estadistica_sivicc` | Minutas y Actividades Policiales |
| `estadistica_sivicc_data_sensible` | Consulta Personal Institucional |

El visual H1-V08 incluye únicamente esas seis categorías mediante F23.

## Hallazgos a validar

- Los controles Estado y Sigla pertenecen a datasets diferentes y no filtran uniformemente los nueve visuales.
- `User_Roles` puede multiplicar filas al combinar eventos con roles; los conteos distintos de usuario reducen el efecto, pero no validan el grano de la tabla.
- La fecha de `User_Roles` se recibe como STRING y se convierte con `parseDate`; no aparece un ajuste horario equivalente al aplicado en `eventos_IAPOL`.
- H1-V03 expone atributos personales y debe revisarse con los permisos efectivos del dashboard.
- H1-V09 no tiene título explícito y muestra estado y correo; se debe confirmar su finalidad funcional.

## Validaciones pendientes

- [ ] Conciliar los cuatro KPI con consultas de usuarios distintos.
- [ ] Probar los límites de mes, seis meses y año, incluidos nulos y fechas futuras.
- [ ] Confirmar que `Nunca ingresó` aparezca cuando corresponda.
- [ ] Verificar el alcance de cada control sobre visuales de ambos datasets.
- [ ] Conciliar los roles homologados y usuarios con varios roles.
- [ ] Validar permisos, exportación y anonimización de las tablas de detalle.

[Volver a Métricas de Uso de la Plataforma](../README.md)
