# Hoja: Llamante

## Propósito

Identifica concentración de llamadas por número de contacto y por base de datos de origen.

## Componentes observados

- `Conteo por Número de Teléfono`.
- `Cuenta po Base de Datos de Origen`.

No se observaron controles de filtro propios en la hoja.

## Pruebas específicas

- [x] Conciliar el total y la distribución por base de origen. — Aprobado: consulta Athena.
- [x] Validar duplicados y múltiples registros del mismo llamante sin confundir evento con persona. — Bloqueado: falta llave y consulta anonimizada.
- [x] Confirmar que las selecciones cruzadas funcionan y pueden restablecerse. — Aprobado 

## Privacidad

Los teléfonos son datos personales. No registrar valores reales, capturas legibles ni muestras sin enmascarar. Usar identificadores irreversibles o parcialmente ocultos y la [plantilla común](../../ejecucion-validaciones-2026-09-04.md).
