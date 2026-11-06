# Tablero Aprendizaje IAPOL

## Objetivo

Mostrar cuántas personas de la población institucional no han iniciado, están en curso o terminaron Aprendizaje IAPOL; permitir la consulta del avance, tiempo activo y módulos de una persona.

## Ruta funcional

`Home > Certificación IAPOL > tablero-aprendizaje-iapol` (nombre registrado en Houndoc; ruta exacta del menú por verificar).

## Estructura funcional

| Vista | Contenido documentado |
|---|---|
| Resumen | Total de la cohorte, cantidades por estado de capacitación y distribución por unidad. |
| Consulta por persona | Búsqueda por persona y correo institucional, estado, porcentaje, horas activas y detalle de módulos. |

El análisis editable incorpora además una comparación de finalización por los 15 módulos. Hay que verificar si ese visual ya fue publicado en el tablero que abre Houndoc. Los controles y rótulos finales también se deben confirmar en la vista publicada.

## Interpretación del semáforo

- **Sin iniciar (rojo):** la persona pertenece a la cohorte, pero no tiene registro del curso.
- **En curso (naranja):** existe un registro del curso, sin cumplir la condición de terminación.
- **Terminó (verde):** el registro tiene estado `terminado`, avance global de 100 % y fecha de finalización.

El color es una ayuda visual; el texto del estado debe poder leerse sin depender del color. “En curso” significa que abrió la capacitación, no que abrió el formulario de certificación.

## Validaciones funcionales

- [ ] El acceso desde Houndoc abre el tablero autorizado sin errores.
- [ ] El total equivale a la suma de los tres estados con el mismo corte y filtros.
- [ ] La búsqueda por nombre o correo institucional filtra la tabla de personas.
- [ ] El control de estado permite seleccionar Sin iniciar, En curso o Terminó y filtra la tabla.
- [ ] El detalle de módulos y tiempo activo corresponde a la persona seleccionada.
- [ ] Los colores y rótulos son coherentes en resumen, control y tabla.
- [ ] La vista publicada coincide con las hojas y visuales esperados del análisis.

## Validaciones de datos

Comparar la población con el tablero de certificaciones usando la misma fecha de carga; comprobar que cada persona aparece una sola vez, que los tres estados son excluyentes y que el tiempo mostrado equivale a `active_seconds / 3600`. Verificar especialmente registros con `status = terminado` pero avance inferior a 100 % o sin `completed_at`: deben figurar **En curso** según la regla del dataset.

## Documentación técnica y aceptación

Fuentes, fórmulas, actualizaciones y consultas de comprobación: [documentacion-tecnica.md](documentacion-tecnica.md). Aplican también las convenciones de [validación de tableros](../../tableros-de-monitoreo/validaciones.md). La documentación está en **Verificación** hasta comprobar la publicación en Houndoc y conciliar un corte real; no se incluyen cifras productivas fijas porque cambian en cada carga.
