# Guía de validación

> Esta es una plantilla reutilizable. Las casillas permanecen vacías para cada nueva ejecución. Los resultados comprobados el 2026-09-04 están en [`ejecucion-validaciones-2026-09-04.md`](ejecucion-validaciones-2026-09-04.md).

## Preparación

Antes de comparar fuentes, registrar:

1. Fecha y hora de ejecución.
2. Fecha y hora de corte de Policía.
3. Fecha y hora de actualización de Athena.
4. Partición de Athena consultada.
5. Campo de fecha utilizado.
6. Periodo y zona horaria.
7. Filtros de negocio.
8. Transformaciones, exclusiones, homologaciones, agrupaciones y deduplicación aplicadas.

Una diferencia de cantidades no demuestra por sí sola un error: la fuente Policía puede continuar recibiendo información después de la carga diaria del Data Lake.

## Validaciones funcionales mínimas

- [ ] Aparece en `Home > Tableros de Monitoreo` y en el submódulo correcto.
- [ ] Se puede activar y desactivar o abandonar sin errores.
- [ ] Carga todos los visuales esperados sin mensajes de error.
- [ ] Cada filtro modifica los resultados y puede restablecerse.
- [ ] Los puntos o elementos geográficos aparecen en la ubicación esperada, cuando aplica.
- [ ] La leyenda, los colores, símbolos, unidades y formatos son correctos.
- [ ] El detalle corresponde al registro o segmento seleccionado.
- [ ] No aparecen registros fuera del periodo, territorio o alcance definido.
- [ ] La interacción entre visuales aplica los filtros cruzados esperados.
- [ ] La hoja conserva títulos y etiquetas accesibles coherentes con su contenido.

## Validaciones de datos mínimas

- [ ] Fecha de actualización de Athena.
- [ ] Fecha de corte utilizada en Policía y Athena.
- [ ] Cantidad total de registros.
- [ ] Cantidades agrupadas por departamento y municipio, cuando existan esos campos.
- [ ] Registros duplicados según la llave funcional documentada.
- [ ] Campos obligatorios con valores nulos.
- [ ] Registros sin coordenadas.
- [ ] Formato, rango y validez de latitud y longitud.
- [ ] Muestra anonimizada de registros entre Policía y Athena.
- [ ] Cantidad consultada en Athena frente a la mostrada por la aplicación.

Para tableros sin componente cartográfico, sustituir la comparación con el mapa por la visual principal, tabla o KPI que represente el total.

## Reglas para comparar Policía y Athena

Confirmar que ambas consultas:

1. Utilizan el mismo periodo.
2. Aplican los mismos filtros de negocio.
3. Usan el mismo campo de fecha.
4. Consideran las transformaciones realizadas durante la carga.
5. Encuentran disponible la partición correspondiente en Athena.
6. Comparten una fecha y hora de corte conocida.

Las diferencias deben clasificarse como rezago de carga, transformación esperada, dato inválido, duplicado, filtro desigual, partición ausente o defecto sin justificar.

## Criterios generales de aceptación

Una hoja o vista se aprueba cuando:

1. Es posible acceder y activarla correctamente.
2. Carga la información sin errores.
3. Los filtros funcionan según lo esperado.
4. La información corresponde al periodo seleccionado.
5. Athena contiene los datos esperados de acuerdo con la fuente Policía y las reglas de transformación.
6. La visual principal representa correctamente la información consultada en Athena.
7. No existen diferencias sin justificación documentada.

Si una dependencia externa impide validar el contenido, el resultado debe ser `Bloqueado`, nunca `Aprobado`.

## Evidencias permitidas

- Capturas recortadas sin datos personales ni narrativas operativas.
- Totales agregados y resultados de control.
- Consultas parametrizadas sin credenciales ni direcciones internas.
- Identificadores enmascarados para la muestra de conciliación.

No almacenar exportaciones completas de producción.
