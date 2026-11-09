# 01. Anticipación por Demanda

## Identificación

| Campo | Valor |
|---|---|
| Módulo padre | 05. Anticipación a Fenómenos de Seguridad |
| Submódulo | Anticipación por Demanda |
| Ruta de acceso | `Menú principal > Anticipación a Fenómenos de Seguridad > Anticipación por Demanda` |
| URL | `https://anticipacion.ia.policia.gov.co` |
| Estado de documentación | Verificación |
| Responsable | Cristian Sanchez |
| Fecha de actualización | 2026-11-09 |

## Descripción

Permite a un usuario autorizado generar, a solicitud, una anticipación espacial de la demanda de servicio de policía para una o varias unidades de una sigla, por turno, por hora, por turno parcial o por horas específicas, con filtro opcional de delitos. El motor entrena modelos sobre el histórico de `pon-prod-mdp.mdp_limpio`, publica cuadrículas de intensidad en S3 y un job de Glue genera configuraciones optimizadas de cuadrantes con puntos de apoyo.

## Documentación

| Documento | Contenido |
|---|---|
| [Documentación Técnica.md](Documentación%20Técnica.md) | Lógica, arquitectura, diagnóstico de incidentes, configuración, integraciones (Keycloak, API PONAL), despliegue y rollback, monitoreo, recuperación y ejecución local. |
| [arquitectura_aws.drawio](arquitectura_aws.drawio) | Diagrama editable de la arquitectura AWS con el flujo numerado de una solicitud. |

## Componentes

| Componente | Repositorio |
|---|---|
| Front (Next.js) | `ai-scm/pon-xcrimePredictionDemanda-front` |
| BFF (Flask + OIDC) | `ai-scm/pon-xcrimePredictionDemanda-gateway` |
| Services (Flask) | `ai-scm/pon-xcrimePredictionDemanda-services` |
| Motor de predicción, Glue, Lambda e infraestructura CDK | `XCrimePrediction` / `ai-scm/pon-xcrimePrediction-infra`, rama `ecs_demanda` |

## Checklist de documentación

- [x] Descripción funcional
- [x] Ruta de acceso verificada
- [x] Parámetros y filtros
- [ ] Validaciones funcionales
- [ ] Evidencias

## Hallazgos y notas

Detalle en el Anexo C de la documentación técnica. Los principales:

- Credenciales del usuario de servicio de la API PONAL escritas en el código del motor. Se recomienda rotarlas y moverlas a Secrets Manager.
- El control de duplicados no excluye las predicciones en `error` (compara con `Error` en mayúscula), así que una predicción fallida no se puede volver a pedir con los mismos parámetros.
- El stack `cdk_demanda` fija la imagen `demanda_v4.0.0`, pero producción usa `demanda_v4.0.5`. Un `cdk deploy` regresaría el motor a la versión anterior.
- No hay alarmas funcionales, y la Lambda del catálogo mensual no tiene permisos para escribir logs.
- Las tablas DynamoDB no tienen PITR.
