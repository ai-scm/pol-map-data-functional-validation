"""
Corre el motor de Policía Comunitaria (zonificación v2) en local para una o varias estaciones.

Hace lo mismo que `procesar_v2` del procesador (handler.py), pero NO escribe en S3: lee de AWS
(S3, Athena y RDS) y guarda el resultado en una carpeta local. No modifica producción.
Athena sí deja los CSV de resultado de sus consultas en
s3://aws-athena-query-results-926162397524-us-east-1/planes-comunitarios-v2/ (es lo normal del motor).

Uso:
  python ejecutar_local.py --sigla DESAB --mes 2026-09 --codigos 64779
  python ejecutar_local.py --sigla MESOA --mes 2026-09                # todas las estaciones de la sigla
  python ejecutar_local.py --sigla DESAB --mes 2026-09 --codigos 64779 --repo C:\\ruta\\pon-iapol-capas

Requisitos: ver la sección 9 del README (Python 3.11, dependencias del procesador y credenciales AWS).
`--mes` es el mes que se procesa (YYYY-MM): la ventana de hechos son los 3 meses que terminan en él
y las fechas sugeridas caen en el mes siguiente.
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

BUCKET = "pon-prod-ml-iapol"


def ubicar_repo(argumento):
    """Carpeta del código del procesador: --repo, la variable PON_IAPOL_CAPAS o un hermano `pon-iapol-capas`."""
    candidatos = [argumento, os.environ.get("PON_IAPOL_CAPAS")]
    candidatos += [p / "pon-iapol-capas" for p in Path(__file__).resolve().parents]
    for c in candidatos:
        if c:
            procesador = Path(c) / "planes_comunitarios" / "lambdas" / "procesador"
            if (procesador / "zonificacion_v2.py").exists():
                return procesador
    sys.exit("No encuentro el código del procesador. Use --repo <ruta de pon-iapol-capas> o la variable PON_IAPOL_CAPAS.")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--sigla", required=True, help="Sigla de la unidad, p. ej. DESAB")
    ap.add_argument("--mes", required=True, help="Mes que se procesa, YYYY-MM")
    ap.add_argument("--codigos", nargs="*", type=int, help="Códigos de estación; sin ellos, todas las de la sigla")
    ap.add_argument("--repo", help="Ruta del repositorio pon-iapol-capas")
    ap.add_argument("--salida", default="salida_local", help="Carpeta local de salida (por defecto ./salida_local)")
    args = ap.parse_args()

    sys.path.insert(0, str(ubicar_repo(args.repo)))
    import geopandas as gpd
    import zonificacion_v2 as z
    from fuentes_internas import Contexto, cargar_fuentes_internas
    from recomendacion import NumpyEncoder
    from turnos import cargar_turnos
    from zonificacion import listar_archivos_estacion

    sigla, mes = args.sigla.upper(), args.mes
    salida = Path(args.salida) / sigla
    salida.mkdir(parents=True, exist_ok=True)

    unidades = gpd.read_file(z.s3.get_object(Bucket=BUCKET, Key=f"UnidadesBase/{sigla}-UnidadesBase.geojson")["Body"])
    codigos = args.codigos or sorted(int(c) for c in unidades.codigo.dropna().unique())
    unidades_metros = unidades.to_crs("EPSG:3116")

    for codigo in codigos:
        t = time.time()
        estacion = unidades[unidades.codigo.astype(int) == codigo]
        if estacion.empty:
            print(f"{sigla} {codigo}: no está en UnidadesBase/{sigla}-UnidadesBase.geojson")
            continue
        estacion_4326 = estacion.to_crs("EPSG:4326").geometry.iloc[0]
        estacion_metros = z.area_propia(codigo, unidades_metros)                      # sin el área de sus CAI

        archivos = listar_archivos_estacion(BUCKET, "Fuentes_externas/", codigo)      # sitios: colegios, parques...
        sitios = z.preparar_sitios(z.cargar_sitios(BUCKET, archivos, codigo) if archivos else None)
        hechos = z.cargar_hechos(sigla, codigo, estacion_4326, mes)                   # SIEDCO + RNMC
        ctx = Contexto(sigla=sigla, codigo=codigo, mes=mes, bbox=estacion_4326.bounds,
                       athena_df=z._athena_df, s3=z.s3, unidades=z.unidades_del_mapa(codigo))
        internas, resumen = cargar_fuentes_internas(ctx)                              # SIMEP, MTRS, IRIS, SIRAP, SECAD, homicidios
        hechos = z.agregar_fuentes_internas(hechos, internas)
        turnos = cargar_turnos(z.s3, sigla, codigo, mes)
        antecedentes = z.cargar_antecedentes(sigla, codigo, estacion_4326, mes)       # justifica las zonas preventivas

        resultado = z.construir_zonas_v2(estacion_metros, sitios, hechos, codigo, mes, turnos, antecedentes)
        resultado.update({"codigo_estacion": codigo, "sigla": sigla, "mes": mes, "fuentes_internas": resumen})
        destino = salida / f"{codigo}.geojson"
        destino.write_text(json.dumps(resultado, ensure_ascii=False, cls=NumpyEncoder), encoding="utf-8")

        tipos = {}
        for f in resultado["features"]:
            tipos[f["properties"]["tipo_zona"]] = tipos.get(f["properties"]["tipo_zona"], 0) + 1
        fuentes = " ".join(f"{k}={v.get('eventos', 'ERROR')}" for k, v in resumen.items())
        print(f"{sigla} {codigo}: {len(resultado['features'])} zonas {tipos} en {time.time() - t:.0f} s | {fuentes} -> {destino}",
              flush=True)


if __name__ == "__main__":
    main()
