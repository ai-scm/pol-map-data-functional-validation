# Hoja: Llamante

## Propósito

Identifica concentración de llamadas por número de contacto y por base de datos de origen.

## Componentes observados

- `Conteo por Número de Teléfono`.
- `Cuenta po Base de Datos de Origen`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [ ] Conciliar el total y la distribución por base de origen.
- [ ] Definir la normalización de teléfonos antes de contar: prefijos, espacios, extensiones, vacíos y valores inválidos.
- [ ] Validar duplicados y múltiples registros del mismo llamante sin confundir evento con persona.
- [ ] Confirmar que las selecciones cruzadas funcionan y pueden restablecerse.
- [ ] Verificar que el alcance temporal coincide con el esperado para la hoja.

## Privacidad

Los teléfonos son datos personales. No registrar valores reales, capturas legibles ni muestras sin enmascarar. Usar identificadores irreversibles o parcialmente ocultos y la [plantilla común](../../registro-resultados.md).
