# Documentación técnica — Última actualización de datos migrados

## Activos y estado

| Elemento | Valor |
|---|---|
| ID proporcionado | `8cae6307-9b57-4c94-beb3-ae8c7ee7e04f` |
| Dashboard informado | `migracion_tablas` |
| Análisis informado | `utima_actualizacion_tablas analysis` |
| Hojas visibles | CNP, DISEC, GEOPOL, SIVICC y TELEPOL |
| Análisis en catálogo accesible | No localizado con el nombre informado |
| Conjunto de datos | Pendiente de identificación |

Esta sección se basa en la configuración visible del dashboard y en los nombres proporcionados. Al no estar disponible el análisis, no se consideran confirmadas las expresiones de campos, tablas físicas, umbrales de color ni filtros internos.

## Estructura común de las hojas

Las cinco hojas siguen el mismo patrón:

- un control `Tabla`, con valor inicial visible `Todo`;
- una tabla de detalle de actualizaciones;
- un gráfico denominado `Cantidad de tablas por días sin actualizar`;
- una hoja por dominio o sistema: CNP, DISEC, GEOPOL, SIVICC y TELEPOL.

El diseño sugiere que `Tabla` filtra el nombre del objeto migrado y que el gráfico agrupa objetos por antigüedad de actualización. Esta interpretación es **inferida** y debe confirmarse en el análisis.

## Contrato de datos requerido

Para hacer reproducible el tablero, el análisis debe documentar estos campos o sus equivalentes:

| Concepto | Definición que debe capturarse |
|---|---|
| Sistema | Dominio que determina la hoja: CNP, DISEC, GEOPOL, SIVICC o TELEPOL. |
| Tabla | Nombre lógico del objeto migrado, sin incluir direcciones o credenciales. |
| Última actualización | Campo de fecha utilizado y si corresponde a fuente, ingesta, transformación o publicación. |
| Fecha de evaluación | Instante contra el que se calcula la antigüedad. |
| Días sin actualizar | Expresión exacta, zona horaria, redondeo y tratamiento de nulos. |
| Cantidad de tablas | Debe aclarar si es `COUNT(*)` o conteo distinto del nombre de tabla. |
| Estado | Umbrales, categorías, colores y manejo de objetos nunca cargados. |

Una posible forma conceptual es `dateDiff(fecha_ultima_actualizacion, fecha_evaluacion, 'DD')`, pero **no es una fórmula verificada** y no debe implementarse sin abrir el análisis.

## Filtro Tabla

Pruebas necesarias para cada hoja:

1. `Todo` debe incluir únicamente las tablas del dominio de la hoja.
2. Seleccionar una tabla debe actualizar simultáneamente detalle y gráfico.
3. Una tabla no perteneciente al dominio no debe estar disponible.
4. Restablecer debe volver a `Todo` y eliminar selecciones cruzadas.
5. Diferencias de mayúsculas, esquema o alias no deben duplicar una misma tabla lógica sin justificación.

## Lógica esperada de conciliación

Para una fecha de evaluación fija:

1. obtener una fila por tabla y sistema;
2. resolver múltiples registros usando la misma regla del dashboard, normalmente la fecha máxima, pero confirmándola;
3. calcular días con la misma zona horaria y truncamiento;
4. agrupar por el valor o banda exacta usada en el gráfico;
5. verificar que la suma de categorías coincida con la cantidad distinta de tablas visible;
6. tratar por separado fechas futuras, nulas o imposibles.

## Validaciones por hoja

| Hoja | Partición mínima de conciliación |
|---|---|
| CNP | Tabla y fecha de última actualización para el dominio CNP. |
| DISEC | Tabla y fecha de última actualización para el dominio DISEC. |
| GEOPOL | Tabla y fecha de última actualización para el dominio GEOPOL. |
| SIVICC | Tabla y fecha de última actualización para el dominio SIVICC. |
| TELEPOL | Tabla y fecha de última actualización para el dominio TELEPOL. |

No se deben comparar sólo los totales. Dos tablas intercambiadas entre bandas pueden conservar el mismo total y ocultar un error.

## Asuntos pendientes

- Localizar el análisis o confirmar si fue renombrado o transferido.
- Identificar conjunto de datos, tabla física, modo de consulta y programación de refresco.
- Extraer nombres de campos, fórmulas, filtros, agregaciones y umbrales.
- Precisar qué significa “actualización”: dato fuente, partición de Athena, SPICE o dashboard.
- Corregir o confirmar la grafía `utima_` del nombre informado del análisis.

## Consultas Athena orientativas

Estado: **Pendiente.** No se localizó el análisis ni el conjunto de datos, y no se confirmaron nombres de campos, tablas físicas ni fórmulas. Por eso **no** se propone una consulta ejecutable como si fuera real; hacerlo violaría la regla del módulo de no completar por semejanza con otro tablero.

La siguiente estructura es únicamente conceptual y sigue la [plantilla SQL orientativa del módulo](../documentacion-tecnica.md#plantilla-sql-orientativa). Todos los identificadores son marcadores `<...>` y la expresión de "días sin actualizar" es **inferida, no verificada**.

```sql
-- CONCEPTUAL — no ejecutar. Reemplazar todos los <marcadores> tras abrir el análisis.
-- Objetivo: una fila por tabla y sistema, con la antigüedad de la última actualización.
SELECT
    <campo_sistema>                                                       AS sistema,       -- CNP, DISEC, GEOPOL, SIVICC, TELEPOL
    <campo_tabla>                                                         AS tabla,
    MAX(<campo_ultima_actualizacion>)                                     AS ultima_actualizacion,
    date_diff('day', MAX(<campo_ultima_actualizacion>), TIMESTAMP '<fecha_evaluacion>') AS dias_sin_actualizar
FROM <catalogo>.<esquema>.<tabla_migracion>
WHERE <campo_sistema> = '<dominio_de_la_hoja>'
GROUP BY <campo_sistema>, <campo_tabla>;
```

> Antes de convertir esto en una consulta real hay que confirmar: conjunto de datos y tabla física; qué significa "actualización" (dato fuente, partición de Athena, SPICE o dashboard); la regla para múltiples registros por tabla (normalmente fecha máxima, pero sin confirmar); si `Cantidad de tablas` es `COUNT(*)` o conteo distinto; zona horaria y truncamiento; umbrales/bandas del gráfico `Cantidad de tablas por días sin actualizar`; y el tratamiento de fechas futuras, nulas o de objetos nunca cargados. Verificar también la grafía `utima_` del nombre informado.

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)