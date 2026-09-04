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

- [ ] Conciliar puntos/elementos del mapa con el total de Athena para el mismo periodo.
- [ ] Validar latitud entre -90 y 90 y longitud entre -180 y 180.
- [ ] Separar sin coordenadas, coordenadas cero, pares incompletos y ubicaciones fuera del alcance.
- [ ] Comprobar leyenda, colores, símbolos, agrupación y nivel de zoom.
- [ ] Seleccionar un punto o agregado y verificar que `Detalle` corresponde a la selección.
- [ ] Cambiar `Días` y comprobar que mapa, distribuciones y tabla se actualizan juntos.

No almacenar coordenadas puntuales ni narrativas operativas en evidencias. Usar la [plantilla común](../../registro-resultados.md).
