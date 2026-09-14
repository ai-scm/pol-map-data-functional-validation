# Filtros e interacciones

## Filtros de población

Estos filtros definen la población utilizada por la hoja:

| Campo | Condición | Alcance |
|---|---|---|
| `usuarios_policia` | Igual a `1` | Hoja cruzada. |
| `estado_empleado` | Incluir `AC` | Hoja cruzada. |

La combinación conserva usuarios policiales con estado laboral activo.

## Controles visibles del dashboard

| Control | Campo | Alcance funcional |
|---|---|---|
| Periodo del gráfico de actividad | `event_time` | Solo `Usuarios activos por mes`. |
| Sigla | `sigla_laborando` | Hoja. |
| Dependencia | `descripcion_dependencia` | Hoja. |
| Estado | `Estado actividad` | Hoja. |

El valor `Todo` mantiene toda la población definida por los filtros técnicos.

## Motivo del alcance temporal

`event_time` existe en registros de interacción. Si el filtro temporal se aplicara a toda la hoja, podría retirar usuarios sin eventos recientes y alterar:

- Total usuario.
- Han ingresado.
- Sin ingreso.
- Porcentajes del embudo.
- Distribución del estado de actividad.

Por eso el periodo **Últimos 7 meses** se limita al gráfico mensual.

## Interacciones configuradas

### Dependencias con menor adopción → tabla

Al seleccionar una barra, la tabla de seguimiento muestra los usuarios correspondientes a la sigla seleccionada.

```text
Origen: Dependencias con menor adopción
Campo de selección: sigla_laborando
Destino: Usuarios que requieren seguimiento
```

### Estado de actividad → tabla

Al seleccionar un segmento, la tabla presenta usuarios del estado elegido.

```text
Origen: Estado de actividad
Campo de selección: Estado actividad
Destino: Usuarios que requieren seguimiento
```

Al limpiar una selección, la tabla vuelve al contexto definido por los controles visibles.

## Flujo de filtrado

```text
Población técnica
    ↓
Controles de Sigla, Dependencia y Estado
    ↓
KPI + Embudo + Gráficos + Tabla

Control de periodo
    ↓
Solo Usuarios activos por mes

Selección de barra o segmento
    ↓
Tabla Usuarios que requieren seguimiento
```

## Correspondencia entre controles

`Sigla` utiliza el código corto `sigla_laborando`; `Dependencia` utiliza el nombre completo `descripcion_dependencia`. Ambos controles describen dimensiones relacionadas, pero no son intercambiables: el primero filtra por sigla y el segundo permite llegar al detalle de dependencia.

`Estado` utiliza exactamente las categorías producidas por el campo calculado `Estado actividad`:

```text
0-10 días
11-30 días
31-60 días
Más de 60 días
Nunca ingresó
```
