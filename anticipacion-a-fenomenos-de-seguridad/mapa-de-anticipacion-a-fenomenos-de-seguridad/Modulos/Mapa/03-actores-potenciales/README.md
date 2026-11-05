# Actores potenciales

## Identificación

| Campo | Valor |
|---|---|
| Nombre del acceso en el mapa | Actores Potenciales |
| Título del panel que abre | Consulta integrada |
| Estado de documentación | Verificación |
| Fecha de revisión | 2026-11-03 |
| Prueba en navegador | No ejecutado |

## Relación funcional

En la versión de XCrime publicada el 2026-10-29, el botón con icono `fa-user-secret` cambia `showActoresPotenciales` y muestra el componente `ActoresPotenciales`. Ese componente dibuja el título **Consulta integrada**.

Se documentan ambos nombres porque aparecen en la aplicación, pero no se cuentan como dos herramientas independientes.

La descripción, categorías, filtros, servicios y casos de prueba están en [Consulta integrada](../01-consulta-integrada/README.md).

## Evidencia

- `src/pages/MapPage.js:11028`: definición del acceso y del componente.
- `src/components/ActoresPotenciales/ActoresPotenciales.js:219`: título del panel.
- [Versión y alcance de la revisión](../evidencia-validacion-2026-11-03.md).

[Volver al índice](../README.md).
