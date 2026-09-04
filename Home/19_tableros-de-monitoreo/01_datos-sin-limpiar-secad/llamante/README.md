# Hoja: Llamante

## Propósito

Identifica concentración de llamadas por número de contacto y por base de datos de origen.

## Componentes observados

- `Conteo por Número de Teléfono`.
- `Cuenta po Base de Datos de Origen`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [ ] Conciliar el total y la distribución por base de origen. — Bloqueado: sin consulta Athena.
- [ ] Definir la normalización de teléfonos antes de contar: prefijos, espacios, extensiones, vacíos y valores inválidos. — Bloqueado: regla de negocio no suministrada.
- [ ] Validar duplicados y múltiples registros del mismo llamante sin confundir evento con persona. — Bloqueado: falta llave y consulta anonimizada.
- [ ] Confirmar que las selecciones cruzadas funcionan y pueden restablecerse. — Pendiente de interacción específica.
- [ ] Verificar que el alcance temporal coincide con el esperado para la hoja. — Bloqueado: no existe filtro temporal documentado para esta hoja.

## Privacidad

Los teléfonos son datos personales. No registrar valores reales, capturas legibles ni muestras sin enmascarar. Usar identificadores irreversibles o parcialmente ocultos y la [plantilla común](../../registro-resultados.md).
