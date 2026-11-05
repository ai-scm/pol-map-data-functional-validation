# Tipos de Minuta

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Tipos de Minuta |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## 2. Descripción

Permite representar el personal operativo completo o filtrado por tipo de minuta y consultar su rol en el mapa.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

Requiere una unidad seleccionada. El texto del acceso está en plural, Tipos de Minutas, y el título del panel dice Tipos de Minuta.

1. Seleccionar unidad y abrir Tipos de Minutas.
2. Elegir Ver Todo el Personal o una minuta.
3. Consultar la posición y el rol de un integrante.
4. Revisar Plan Democracia de forma separada cuando corresponda.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Ver Todo el Personal | Consulta y representa el personal completo. |
| Minuta de Vigilancia | Filtra por ese tipo de minuta. |
| Minuta de Apoyos | Filtra por ese tipo de minuta. |
| Minuta por Zona de atención | Envía el valor de servicio Minuta por Cuadrantes. |
| Minuta de Plana Mayor | Filtra por ese tipo de minuta. |
| Plan Democracia | Usa una consulta independiente por sigla. |

## 5. Comportamiento y reglas

- La consulta de personal utiliza el hash del mapa de patrullas.
- El filtro envía minuta con el nombre esperado por el servicio; no siempre coincide con el rótulo de pantalla.
- La actualización del tipo de patrulla activo tiene un temporizador de 15 segundos.
- Los iconos se seleccionan según descRolMinuta.
- Servicios Extraordinarios tiene su propio panel y no se documenta como un quinto tipo de la lista estática.

## 6. Datos y servicios

`POST /RO/obtener_cuadrantes_completos_hash`, `POST /RO/obtener_cuadrantes_completos_hash_y_minuta` con hash y minuta; `POST /consulta-sigla-plan-democracia` para Plan Democracia. La fuente física del personal y la política de actualización del origen están **Pendiente por confirmar**.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/pages/MapPage.js:284` — lista estática; línea 1738 — consulta por minuta; línea 11954 — panel.
- `src/services/api/mapaPatrullaApi.js` — consultas por hash y Plan Democracia.
- `src/utils/roleIconMapper.js` — iconos por rol.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Contrastar cada rótulo de pantalla con el valor de minuta enviado.
- [ ] Comparar personal completo y filtrado con la misma respuesta temporal.
- [ ] Verificar actualización y limpieza al cambiar de minuta o unidad.
- [ ] Probar Plan Democracia sin confundir su origen con las minutas.

## 9. Criterios de aceptación

La funcionalidad debe responder a los controles documentados, representar el ámbito territorial y temporal solicitado y retirar sus elementos al desactivarse o limpiarse. La aceptación exige ejecutar las comprobaciones anteriores y registrar fecha, unidad, filtros, cantidades y diferencias justificadas. Un resultado vacío y un error del servicio deben distinguirse durante la prueba.

## 10. Resultado y pendientes

| Comprobación | Resultado |
|---|---|
| Presencia y lógica en el código publicado | Confirmado por revisión estática |
| Navegación y representación en navegador | No ejecutado |
| Comparación de registros Policía / servicio / mapa | No ejecutado |
| Fuente física no indicada expresamente en esta ficha | Pendiente por confirmar |

La revisión del código describe el comportamiento implementado. No acredita por sí sola disponibilidad del servicio, permisos del usuario ni igualdad de registros.

[Volver al índice del mapa](../README.md).
