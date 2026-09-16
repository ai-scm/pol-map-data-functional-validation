# Estadísticas de uso

## Estado de publicación

Hoja interna **no publicada** del análisis `eventos_IAPOL_metricas_uso analysis`.

## Objetivo observado

Analiza la evolución diaria de usuarios y la utilización de tableros o elementos padre. Contiene una serie temporal y dos comparaciones por `parent_corregido_para_null_manual`.

## Controles observados

| Control | Valor observado durante la inspección | Uso |
|---|---|---|
| Fecha Inicio | `2026/08/01` | Alimenta el parámetro `Fechainicio`. |
| Fecha fin | `2026/09/04` | Alimenta el parámetro `Fechafin`. |
| Estado de empleado | `AC` | Limita la población de empleados. |

Los valores anteriores son valores de sesión observados, no valores permanentes que deban fijarse en una prueba futura.

## Filtros comunes

- `usuarios_policia = 1`.
- `estado_empleado` incluye `AC`.
- `sigla_laborando = sigla`, según la condición configurada en el análisis.

## Lógica de los visuales

### Número de usuarios que ingresaron cada día

- Tipo: gráfico de líneas.
- Eje temporal: `fecha_evento`.
- Medida mostrada: recuento de `username`, no conteo distinto.
- Filtros del visual:
  - `SIgla_laborando_ME_DE` excluye `NULL`;
  - `fecha_evento` está entre `Fechainicio` y `Fechafin`.

Como la medida es un recuento, un usuario con varios eventos el mismo día puede aparecer varias veces. El título “Número de usuarios” podría sugerir usuarios distintos; esta diferencia debe validarse antes de publicar la hoja.

### Tableros con mayor número de interacciones

- Tipo: gráfico de rectángulos.
- Dimensión: `parent_corregido_para_null_manual`.
- Medida: suma de `Interacciones Totales`.
- Filtros del visual:
  - `category` incluye `Dashboard`;
  - `parent_corregido_para_null_manual` excluye `NULL`;
  - `fecha_evento` está entre `Fechainicio` y `Fechafin`.

`Interacciones Totales` está definido como `countOver({name_item}, [username], PRE_FILTER)`. Sumar este valor sobre múltiples filas puede repetir el total de un usuario y sobredimensionar la medida. Se debe verificar si la intención es contar eventos, sumar un valor por usuario o usar otra agregación.

### Usuarios por tablero

- Tipo: gráfico de barras horizontales.
- Dimensión: `parent_corregido_para_null_manual`.
- Medida: conteo distinto de `username`.
- Filtros del visual:
  - `parent_corregido_para_null_manual` excluye `NULL`;
  - `fecha_evento` está entre `Fechainicio` y `Fechafin`.

## Validaciones

1. Comparar `COUNT(username)` y `COUNT(DISTINCT username)` por día para determinar si el título es correcto.
2. Validar que ambos extremos de fecha se incluyan según la semántica de Quick.
3. Revisar el efecto de `PRE_FILTER` sobre `Interacciones Totales` antes de sumar.
4. Conciliar el Top de tableros con eventos filtrados por `category = Dashboard`.
5. Confirmar que valores nulos o sin homologar en `parent_corregido_para_null_manual` quedan fuera de forma intencional.

## Asuntos pendientes

- Motivo por el cual la hoja no está publicada.
- Definición y fórmula de `parent_corregido_para_null_manual`.
- Agregación funcional correcta para “usuarios que ingresaron cada día”.
- Regla correcta para el número de interacciones por tablero.

[Volver a Métricas de Uso](../README.md)
