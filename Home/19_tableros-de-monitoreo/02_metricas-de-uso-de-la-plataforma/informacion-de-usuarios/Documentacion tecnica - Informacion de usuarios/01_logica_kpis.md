# Lógica de los KPI

## Criterio de conteo

Una persona puede tener varios eventos. Para evitar duplicidades, la métrica base es el recuento distinto de `username`.

## 1. Total usuario

Representa todos los usuarios únicos registrados dentro del contexto definido por los filtros.

```text
distinct_count({username})
```

Nombre documentado del campo: `KPI Total usuarios`.

## 2. Han ingresado

Cuenta usuarios únicos que tienen el estado `Con ingreso`.

```text
distinct_countIf(
    {username},
    {estado_user} = 'Con ingreso'
)
```

Nombre documentado del campo: `KPI Han ingresado`.

### Porcentaje Han ingresado

Mide adopción acumulada. El denominador es el total de usuarios registrados, no el total de eventos.

```text
distinct_countIf({username}, {estado_user} = 'Con ingreso')
/
distinct_count({username})
```

Nombre documentado del campo: `Porcentaje Han ingresado`.

Ejemplo de la captura:

```text
9.674 / 21.198 = 45,64 %
```

## 3. Sin ingreso

Cuenta usuarios únicos registrados que no tienen evidencia de ingreso.

```text
distinct_countIf(
    {username},
    {estado_user} = 'Sin ingreso'
)
```

Nombre documentado del campo: `KPI Nunca ingresaron`.

### Porcentaje Sin ingreso

```text
distinct_countIf({username}, {estado_user} = 'Sin ingreso')
/
distinct_count({username})
```

Nombre documentado del campo: `Porcentaje Nunca ingresaron`.

Ejemplo de la captura:

```text
11.524 / 21.198 = 54,36 %
```

## 4. Activos en los últimos 10 días

Cuenta usuarios únicos que registraron un evento en los diez días anteriores a la fecha de consulta.

```text
distinctCountIf(
    {username},
    dateDiff({fecha_evento}, now(), 'DD') <= 10
)
```

Nombre documentado del campo: `Usuarios_ingreso_10_dias`.

### Porcentaje de activos

El porcentaje se calcula sobre todos los usuarios registrados:

```text
{Usuarios_ingreso_10_dias}
/
distinct_count({username})
```

Nombre documentado del campo: `Porcentaje Activos 10 días`.

Ejemplo de la captura:

```text
1.074 / 21.198 = 5,07 %
```

## Comparación con el mes anterior

La flecha del KPI **Han ingresado** no muestra el 45,64 %. Muestra el cambio en puntos porcentuales entre la adopción actual y la adopción acumulada al cierre del mes anterior.

### 1. Primera fecha de ingreso por usuario

```text
minOver(
    {fecha_evento},
    [{username}],
    PRE_AGG
)
```

Nombre sugerido: `Primera fecha de ingreso`.

### 2. Usuario con ingreso anterior al mes actual

```text
ifelse(
    isNull({Primera fecha de ingreso}), 0,
    {Primera fecha de ingreso} < truncDate('MM', now()), 1,
    0
)
```

Nombre sugerido: `Ingreso antes del mes actual`.

### 3. Porcentaje acumulado al cierre anterior

```text
distinct_countIf(
    {username},
    {Ingreso antes del mes actual} = 1
)
/
distinct_count({username})
```

Nombre sugerido: `Porcentaje ingresaron mes anterior`.

### 4. Variación mostrada por la flecha

```text
{Porcentaje Han ingresado}
-
{Porcentaje ingresaron mes anterior}
```

El resultado se interpreta en puntos porcentuales:

- Resultado positivo: aumentó la proporción de usuarios que ha ingresado.
- Resultado igual a cero: no hubo variación.
- Resultado negativo: disminuyó la proporción dentro del contexto comparado.

Para **Sin ingreso**, la lectura es inversa: una reducción es favorable porque menos usuarios permanecen sin ingresar.

## Configuración visual de los KPI

Amazon Quick admite el valor real, el valor de comparación y el formato condicional del texto o del icono. En esta implementación:

| Elemento | Uso |
|---|---|
| Valor real | Conteo distinto del KPI. |
| Valor de comparación | Porcentaje o variación correspondiente. |
| Icono | Dirección de la variación. |
| Color del texto | Interpretación favorable, neutra o desfavorable. |
| Fondo | Color estático suave de la tarjeta. |

Los porcentajes del embudo son proporciones sobre el total registrado y no deben confundirse con la variación mensual de las flechas.
