# Documentación técnica — Monitoreo Componentes

## Estado de levantamiento

| Elemento | Estado |
|---|---|
| ID proporcionado | `a2f9a0d2-07b5-40b3-ab99-8a6254725378` |
| Dashboard de Amazon Quick | No encontrado |
| Análisis | No informado |
| Conjunto de datos | No identificado |
| Interfaz visible | Contenido personalizado que solicita autenticación de Google |

Este submódulo no se presenta como un dashboard de Quick accesible en el catálogo inspeccionado. La autenticación requerida impidió identificar filtros, KPI, fuentes y reglas. En consecuencia, no se atribuye ninguna fórmula técnica por semejanza con los otros tableros.

## Contrato técnico pendiente de completar

Cuando se disponga del acceso autorizado, se debe registrar como mínimo:

| Tema | Información requerida |
|---|---|
| Fuente | Sistema, tabla o API; propietario; ambiente; frecuencia y fecha de corte. |
| Grano | Una fila por componente, ejecución, incidente, métrica o intervalo. |
| Componentes | Catálogo de servicios supervisados y regla de inclusión/exclusión. |
| Estado | Valores posibles y condición exacta para disponible, degradado, detenido o sin datos. |
| Ventana | Periodo del estado actual, histórico y disponibilidad acumulada. |
| KPI | Numerador, denominador, unidad, tratamiento de nulos y zona horaria. |
| Filtros | Campo, operador, valores iniciales, alcance y dependencia entre controles. |
| Alertas | Umbrales, colores, severidad, persistencia y regla de recuperación. |
| Seguridad | Autenticación, autorización y atributos visibles por rol. |

## Validaciones que sí pueden definirse

1. La autenticación debe realizarse únicamente con el mecanismo institucional autorizado.
2. Un componente sin datos no debe confundirse automáticamente con un componente detenido.
3. Los estados del resumen deben reconciliar con el detalle usando el mismo instante de observación.
4. Los colores deben tener un umbral documentado y una alternativa textual accesible.
5. Las marcas de tiempo deben indicar zona horaria y distinguir hora del evento de hora de ingesta.
6. La evidencia no debe incluir tokens, cookies, cuentas, URL internas ni contenido privado del proveedor externo.

## Criterio de cierre documental

La documentación técnica sólo podrá pasar de `Pendiente` a `Confirmada` cuando se obtengan el nombre del activo, la fuente, el catálogo de filtros y la expresión de cada KPI. El acceso visual por sí solo no demuestra la lógica.

## Consultas Athena orientativas

Por lo anterior **no se proponen consultas SQL** para este submódulo. Cualquier query sería inventado y contradiría el criterio de cierre documental, que exige obtener el nombre del activo, la fuente, el catálogo de filtros y la expresión de cada KPI antes de pasar de `Pendiente` a `Confirmada`. El acceso visual por sí solo no demuestra la lógica.

Cuando se disponga del acceso autorizado, las consultas de conciliación deberán derivarse del contrato técnico pendiente descrito arriba (fuente, grano, catálogo de componentes, estados, ventana, KPI, filtros, alertas y seguridad) y seguir la [plantilla SQL orientativa del módulo](../documentacion-tecnica.md#plantilla-sql-orientativa).

[Volver a la documentación técnica del módulo](../documentacion-tecnica.md)