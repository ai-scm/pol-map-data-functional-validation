"""
Valida que los conteos de las tarjetas de Policía Comunitaria sean los puntos de las capas del mapa.

Para cada zona del archivo de una estación compara, contra lo que devuelven hoy los servicios del mapa:
  * RNMC: comparendos por capa (Riñas, Incautaciones, Comportamientos contrarios a la convivencia)
  * SECAD: casos por capa (Riñas, Hurto violento y homicidio, Hurto general)
  * Análisis de homicidios (opcional, con HOMICIDIOS_API_KEY): homicidios de la capa dentro de la zona

Los puntos se cuentan como los dibuja el front (deduplicarFeatures de MapPage.js): en RNMC se quitan las filas
idénticas y en SECAD se deja un punto por llamada (misma hora_caso y ubicación).

Uso:
  set CAPAS_API_KEY=<clave del BFF capas-adicionales>                 (PowerShell: $env:CAPAS_API_KEY = "...")
  python validar_contra_mapa.py salida_local/DESAB/64779.geojson --sigla DESAB --codigo 64779 --mes 2026-09 --repo <pon-iapol-capas>

La clave sale del secreto `capas-adicionales-bff-api-key` (Secrets Manager); no se guarda en este repositorio.
`--mes` es el mes procesado: el rango consultado son los 3 meses que terminan en él, igual que el motor.
Código de salida: 0 sin diferencias, 1 con diferencias, 2 argumentos o credenciales inválidos.
"""
import argparse
import json
import os
import sys
import urllib.request
from collections import Counter
from datetime import datetime
from pathlib import Path

from dateutil.relativedelta import relativedelta
from shapely.geometry import Point, shape

BFF = "https://addcapas.ia.policia.gov.co/bff"
HOMICIDIOS = "https://analisis.homicidios.ia.policia.gov.co/bff/analisis-homicidios"
CAPAS_RNMC = {"rnmc-rinas": "RNMC: Riñas", "rnmc-incautaciones": "RNMC: Incautaciones",
              "comportamientos-contrarios-convivencia-materializados": "Comportamientos contrarios a la convivencia"}
CAPAS_SECAD = {"secad-rinas": "SECAD: Riñas", "secad-hurtos-violento-y-homicidio": "SECAD: Hurto violento y homicidio",
               "secad-hurtos-general": "SECAD: Hurto general"}


def pedir(url, cuerpo, clave):
    req = urllib.request.Request(url, data=json.dumps(cuerpo).encode() if cuerpo is not None else None,
                                 headers={"x-api-key": clave, "Content-Type": "application/json"})
    with urllib.request.urlopen(req, timeout=300) as r:
        return json.loads(r.read())


def sin_repetidos(features, por_llamada):
    """Como el front: SECAD un punto por llamada; el resto, sin filas idénticas (propiedades y geometría)."""
    vistos, salida = set(), []
    for f in features:
        p = f.get("properties") or {}
        clave = (json.dumps([p.get("hora_caso"), f["geometry"]["coordinates"]]) if por_llamada
                 else json.dumps({"p": p, "g": f["geometry"]}))
        if clave not in vistos:
            vistos.add(clave)
            salida.append(f)
    return salida


def unidades_del_mapa(repo, codigo):
    sys.path.insert(0, str(Path(repo) / "planes_comunitarios" / "lambdas" / "procesador"))
    import zonificacion_v2 as z
    return z.unidades_del_mapa(codigo)


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("archivo", help="GeoJSON de la estación generado por el motor")
    ap.add_argument("--sigla", required=True)
    ap.add_argument("--codigo", type=int, required=True, help="Código de la estación")
    ap.add_argument("--mes", required=True, help="Mes procesado, YYYY-MM")
    ap.add_argument("--unidades", nargs="*", type=int, help="Unidades que pide el mapa; por defecto la estación y sus dependientes")
    ap.add_argument("--repo", help="Ruta de pon-iapol-capas (para calcular las unidades dependientes)")
    args = ap.parse_args()

    clave = os.environ.get("CAPAS_API_KEY")
    if not clave:
        sys.exit("Falta la variable de entorno CAPAS_API_KEY.")
    unidades = args.unidades or unidades_del_mapa(args.repo or os.environ.get("PON_IAPOL_CAPAS", ""), args.codigo)
    fin_mes = datetime.strptime(args.mes + "-01", "%Y-%m-%d") + relativedelta(months=1)
    inicio, fin = fin_mes - relativedelta(months=3), fin_mes - relativedelta(days=1)
    cuerpo = {"sigla": args.sigla.upper(), "id_unidad": [str(u) for u in unidades],
              "timestamp_inicio": [inicio.strftime("%Y-%m-%d 00:00:00")],
              "timestamp_final": [fin.strftime("%Y-%m-%d 23:59:00")]}
    print(f"Estación {args.codigo} ({args.sigla}), unidades {unidades}, del {cuerpo['timestamp_inicio'][0]} al {cuerpo['timestamp_final'][0]}")

    capas = {}
    for capa, nombre in {**CAPAS_RNMC, **CAPAS_SECAD}.items():
        feats = pedir(f"{BFF}/{capa}", cuerpo, clave)["geojson"]["features"]
        capas[nombre] = sin_repetidos(feats, por_llamada=capa in CAPAS_SECAD)
        print(f"  {nombre}: {len(feats)} puntos del servicio, {len(capas[nombre])} que dibuja el mapa")

    homicidios = None
    if os.environ.get("HOMICIDIOS_API_KEY"):
        url = f"{HOMICIDIOS}?fecha_inicio={inicio:%Y-%m-%d}&fecha_fin={fin:%Y-%m-%d}"
        casos = {}
        for f in pedir(url, None, os.environ["HOMICIDIOS_API_KEY"])["features"]:
            p = f["properties"]
            casos.setdefault(p["caso_id"], Point(float(p["longitud"]), float(p["latitud"])))
        homicidios = casos
        print(f"  Análisis de homicidios: {len(casos)} casos del país en el rango")

    zonas = json.loads(Path(args.archivo).read_text(encoding="utf-8"))["features"]
    diferencias = 0
    for f in zonas:
        p, poligono = f["properties"], shape(f["geometry"])
        card = {"rnmc": Counter(), "secad": Counter()}
        for r in p["comparendos_resumen"]:
            card["rnmc"][r.get("capa")] += r["casos"]
        for r in p["secad_resumen"]:
            card["secad"][r.get("capa")] += r["casos"]
        for nombre, feats in capas.items():
            grupo = "rnmc" if nombre in CAPAS_RNMC.values() else "secad"
            mapa = sum(1 for x in feats if poligono.intersects(Point(*x["geometry"]["coordinates"])))
            if mapa != card[grupo][nombre]:
                diferencias += 1
                print(f"  DIFERENCIA zona {p['zona_id']} · {nombre}: tarjeta {card[grupo][nombre]} · mapa {mapa}")
        if homicidios is not None:
            mapa = sum(1 for pt in homicidios.values() if poligono.intersects(pt))
            tarjeta = (p.get("fuentes_internas") or {}).get("analisis_homicidios", 0)
            if mapa != tarjeta:
                diferencias += 1
                print(f"  DIFERENCIA zona {p['zona_id']} · Análisis de homicidios: tarjeta {tarjeta} · mapa {mapa}")

    print(f"\n{len(zonas)} zonas revisadas · {diferencias} diferencias")
    sys.exit(1 if diferencias else 0)


if __name__ == "__main__":
    main()
