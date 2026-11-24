# Consulta integrada

## 1. Identificación

| Campo | Valor |
|---|---|
| ID | POL-MAPA-005 |
| Filtros | Zonas de Atención actuales |
| Frecuencia de actualización | null |
| Hora de carga del Data Lake | null |
| Última actualización documento | 24/11/2026 |
| Responsable | null |

## 2. Descripción

Filtro que permite visualizar las zonas de atención definidas para cada unidad (SIGLA, Estación, Subestación o CAI), se identifica por divisiones con lineas amarillas.

## 3. Ruta de Acceso y activación de la capa

1. Ingresar al aplicativo `IAPOL`.
2. Abrir el módulo `Anticipación a Fenómenos de Seguridad`.
3. Seleccionar el submódulo `Mapa de Anticipación a Fenómenos de Seguridad`.
4. Ingresar a `Mapa`.
5. Seleccionar una unidad (Sigla, Estación, subestación o CAI)
6. Activar o desactivar filtro 'Zonas de atención actuales'

<p align="center">
  <img src="Imgs/filtro.png" width="600">
</p>



`Menú principal > Anticipación a Fenómenos de Seguridad > Mapa de Anticipación a Fenómenos de Seguridad > Modulo Filtros`

## 4. Parámetros y filtros de prueba

<p align="center">

| Parámetro | Valor utilizado | Obligatorio |
|---|---|---|
| Sigla | Todos | SI |
| Unidades hijas | Todos | SI |
</p>

## 5. Fuente de datos

### 

## 6. Validaciones funcionales

- [ ] El filtro puede activarse y desactivarse.
- [ ] Se visualiza la permanencia de policia sobre el mapa.
- [ ] No se presentan errores al cargar los datos.
- [ ] El porcentaje total debe sumar el 100%
