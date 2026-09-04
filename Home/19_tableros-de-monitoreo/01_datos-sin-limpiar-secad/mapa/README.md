# Hoja: Mapa

## Propósito

Representa geográficamente los registros SECAD y permite contrastar su distribución con dimensiones de origen, latitud y código final.

## Control observado

- `Días`, con valor observado `30`.

## Componentes observados

- `Distribución de Registros Según Base de Datos de Origen por Coordenadas`.
- `Distribución de Registros por Latitud`.
- `Distribución de Llamadas por Código FInal`.
- Tabla `Detalle`.

## Pruebas específicas

- [ ] Conciliar puntos/elementos del mapa con el total de Athena para el mismo periodo. — Bloqueado: sin consulta Athena.
- [ ] Validar latitud entre -90 y 90 y longitud entre -180 y 180. — Bloqueado: requiere consulta completa; el visual por sí solo no demuestra todos los registros.
- [ ] Separar sin coordenadas, coordenadas cero, pares incompletos y ubicaciones fuera del alcance. — Bloqueado: sin consulta de calidad.
- [x] Comprobar leyenda, colores, símbolos, agrupación y nivel de zoom. — Aprobado visualmente; falta contrastar colores con una especificación formal.
- [ ] Seleccionar un punto o agregado y verificar que `Detalle` corresponde a la selección. — Bloqueado: falta muestra anonimizada de referencia.
- [ ] Cambiar `Días` y comprobar que mapa, distribuciones y tabla se actualizan juntos. — Pendiente de prueba específica en la hoja Mapa.

No almacenar coordenadas puntuales ni narrativas operativas en evidencias. Usar la [plantilla común](../../registro-resultados.md).
