# Información Estadística Delictiva

## 1. Identificación

| Campo | Valor |
|---|---|
| Orden en el menú | Pendiente por confirmar |
| Módulo | Información Estadística Delictiva |
| Ruta de acceso | `Menú principal > Información Estadística Delictiva` |
| Estado de documentación | En progreso |
| Responsable | Pendiente por confirmar |
| Fecha de actualización | 2026-10-13 |

## 2. Descripción

Módulo de tableros estadísticos sobre el comportamiento delictivo registrado en SIEDCO: comportamiento por periodo, comparativos entre años y alertas de homicidio.

## 3. Submódulos

Submódulos visibles en el menú según `Inventario_Dashboards_IAPOL.xlsx`:

- 01. Comportamiento Delictivo
- 02. Comparativo Delictivo (Datos crudos)
- 03. Comparativo por años - Comportamiento Delictivo
- 04. Homicidios de Otros Días
- Alerta de homicidios

El inventario registra además entradas no visibles por unidad (por ejemplo `Comportamiento Delictivo - MEBOG`), que no se documentan mientras no estén publicadas en el menú.

## 4. Estados de documentación

| Estado | Descripción |
|---|---|
| `Faltante` | La documentación aún no se ha iniciado. |
| `En progreso` | La documentación se está redactando. |
| `Verificación` | La documentación está redactada y pendiente de revisión. |
| `Terminado` | La documentación está completa y verificada. |

## 5. Checklist de submódulos

| # | Submódulo | Estado | Responsable | Fecha de actualización | Documentado |
|---|---|---|---|---|---|
| 01 | Comportamiento Delictivo | Faltante | Pendiente por confirmar | Pendiente por confirmar | [ ] |
| 02 | [Comparativo Delictivo (Datos crudos)](comparativo-delictivo-datos-crudos/README.md) | Verificación | Cristian Sanchez | 2026-10-13 | [x] |
| 03 | Comparativo por años - Comportamiento Delictivo | Faltante | Pendiente por confirmar | Pendiente por confirmar | [ ] |
| 04 | Homicidios de Otros Días | Faltante | Pendiente por confirmar | Pendiente por confirmar | [ ] |
| 05 | Alerta de homicidios | Faltante | Pendiente por confirmar | Pendiente por confirmar | [ ] |

## 6. Progreso del módulo

- [ ] 01. Comportamiento Delictivo
- [x] 02. Comparativo Delictivo (Datos crudos)
- [ ] 03. Comparativo por años - Comportamiento Delictivo
- [ ] 04. Homicidios de Otros Días
- [ ] 05. Alerta de homicidios

## 7. Hallazgos y notas

- El tablero `02. Comparativo Delictivo (Datos crudos)` comparte fuente con las capas SIEDCO del mapa: ambos leen la vista de Athena `vw_delitos_corregido_schema_temporal`. La documentación de la capa está en [`SIEDCO`](../anticipacion-a-fenomenos-de-seguridad/mapa-de-anticipacion-a-fenomenos-de-seguridad/Modulos/Mapa/FuentesInternas/SIEDCO/README.md).
- Los submódulos 01 y 03 usan otra fuente (`mdp_limpio_v2.1`), por lo que sus cifras no son comparables directamente con las del submódulo 02.
- El orden del módulo en el menú no se verificó; se deja `Pendiente por confirmar`.
