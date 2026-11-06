# Microterritorios

## 1. Identificación

| Campo | Valor |
|---|---|
| Módulo padre | Anticipación a Fenómenos de Seguridad |
| Submódulo | Mapa de Anticipación a Fenómenos de Seguridad |
| Funcionalidad | Microterritorios |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Responsable | Pendiente por confirmar |
| Evidencia | Código de XCrime publicado en S3 el 2026-10-29; [alcance y versión](../evidencia-validacion-2026-11-03.md) |
| Prueba funcional en la aplicación | No ejecutado en esta revisión |

## Documentación técnica

Consultar la [documentación técnica y guía de soporte de Microterritorios](Documentación%20Técnica.md): arquitectura, incidentes, configuración, integraciones, despliegue, monitoreo, recuperación y ejecución local.

## 2. Descripción

Permite dibujar y guardar un microterritorio con su caracterización, consultar los guardados, visualizarlos, editar sus datos o geometría y eliminarlos desde las acciones disponibles.

## 3. Acceso y disponibilidad

`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad`.

El panel exige unidad seleccionada. Los datos del usuario autenticado se incorporan a la creación; el alcance de permisos por perfil está Pendiente por confirmar.

1. Seleccionar una unidad y abrir Microterritorios.
2. Consultar los guardados o activar Dibujar Microterritorio.
3. Completar la caracterización del polígono y guardar solo durante una prueba autorizada.
4. Consultar, editar, redibujar o eliminar mediante las acciones de la lista cuando corresponda.

## 4. Parámetros y controles

| Control | Comportamiento confirmado en código |
|---|---|
| Dibujar Microterritorio | Activa la captura de geometría. |
| Ver Microterritorios Guardados | Controla la consulta y representación de los guardados. |
| Formulario | Nombre, delitos/comportamientos, clase y factores de riesgo, capacidades institucionales y fechas. |
| Documento de percepción de seguridad | Adjunto opcional enviado junto al payload. |
| Acciones de la lista | Visualizar u ocultar, editar y eliminar según permisos y estado. |
| Detalle de análisis | Consulta del análisis y documentos disponibles en el modal del microterritorio. |

## 5. Comportamiento y reglas

- La creación envía FormData con payload y, opcionalmente, percepcion_seguridad_doc.
- El payload incluye geometry, sigla, fechas, vigente y metadatos del usuario autenticado.
- La edición puede modificar atributos o redibujar el área antes de actualizar el GeoJSON.
- La existencia de rutas de escritura se verificó en código; no se creó, modificó ni eliminó un microterritorio durante esta revisión.

## 6. Datos y servicios

API: `POST /microterritorios/list`, `/microterritorios/guardar-geojson`, `/microterritorios/actualizar-geojson` y `/microterritorios/eliminar`; `GET /factores-riesgo`, `/unidad-delitos/{sigla}` y `/microterritorios/{id}/documentos/{tipo}`. El catálogo dinámico conserva otra capa llamada Microterritorios; su equivalencia con este flujo de gestión no se acreditó.

## 7. Evidencia de implementación

Las rutas `src/` corresponden a fuentes recuperadas del mapa de código de la versión publicada; los números son líneas de esas fuentes, no del JavaScript minificado.

- `src/services/api/microterritoriosApi.js:6` — rutas de lectura y escritura.
- `src/pages/MapPage.js:2928` — creación; línea 4964 — listado; línea 5065 — visualización.
- `src/components/SelectorTurnos/MicroterritorioEditModal.js` — edición.
- `src/components/SelectorTurnos/MicroterritoriosPanelList.js` — acciones de la lista.

## 8. Validaciones funcionales y de datos pendientes

- [ ] Verificar permisos de consulta y escritura por perfil en el entorno de pruebas.
- [ ] Crear y recuperar un polígono de prueba con idénticos atributos y geometría.
- [ ] Verificar edición, redibujo, adjunto y eliminación en pruebas controladas.
- [ ] Distinguir el listado de gestión de la capa dinámica del catálogo.

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
