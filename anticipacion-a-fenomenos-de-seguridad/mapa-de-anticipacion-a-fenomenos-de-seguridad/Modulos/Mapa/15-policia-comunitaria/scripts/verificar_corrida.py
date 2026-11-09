"""
Verifica que la corrida mensual de Policía Comunitaria terminó bien. Solo lectura.

Revisa, para el mes procesado (`--mes`, p. ej. 2026-10):
  1. Cobertura: toda estación de UnidadesBase (las que recorre el orquestador) tiene su archivo en
     s3://pon-prod-ml-iapol/policia-comunitaria/{mes}/{SIGLA}/{codigo}.geojson.
  2. Frescura: los archivos se escribieron después del inicio de la corrida (`--desde`).
  3. Errores: marcadores en utilidades/errores_policia_comunitaria/{mes}/ escritos desde `--desde`.
  4. Lambda: invocaciones, errores y limitaciones (Throttles) del procesador en CloudWatch.
  5. Con `--profundo` lee cada archivo y reporta las fuentes internas que fallaron (la estación se genera
     igual pero sin esa fuente: el fallo no deja marcador de error, solo queda dentro del archivo).

Uso:
  python verificar_corrida.py --mes 2026-10
  python verificar_corrida.py --mes 2026-10 --desde 2026-11-01T10:00:00Z --profundo

Por defecto `--desde` es el inicio del disparo automático: el día 1 del mes siguiente a las 10:00 UTC (05:00 Colombia).
Estados: OK / AVISO / FALLA / INFO, como los monitores de monitoreo-datos-ponal. Código de salida: 0 sin FALLA, 1 con FALLA.
Credenciales: el perfil de AWS de la cuenta PON-PROD (ver README, sección 9).
"""
import argparse
import json
import re
import sys
from collections import Counter, defaultdict
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timedelta, timezone

import boto3
from dateutil.relativedelta import relativedelta

BUCKET = "pon-prod-ml-iapol"
PROCESADOR = "planes-comunitarios-procesador"
conteo = Counter()


def linea(estado, texto):
    conteo[estado] += 1
    print(f"[{estado:<5}] {texto}")


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--mes", required=True, help="Mes procesado, YYYY-MM")
    ap.add_argument("--desde", help="Inicio de la corrida (ISO, UTC); por defecto el día 1 del mes siguiente 10:00 UTC")
    ap.add_argument("--profundo", action="store_true", help="Lee cada archivo y revisa las fuentes internas")
    args = ap.parse_args()
    if not re.fullmatch(r"\d{4}-\d{2}", args.mes):
        sys.exit("--mes debe tener el formato YYYY-MM")

    siguiente = datetime.strptime(args.mes + "-01", "%Y-%m-%d") + relativedelta(months=1)
    desde = (datetime.fromisoformat(args.desde.replace("Z", "+00:00")) if args.desde
             else siguiente.replace(hour=10, tzinfo=timezone.utc))
    if desde.tzinfo is None:
        desde = desde.replace(tzinfo=timezone.utc)
    s3 = boto3.client("s3")

    # 1. Estaciones que recorre el orquestador: los features con `codigo` de cada UnidadesBase/{SIGLA}-UnidadesBase.geojson
    llaves = [o["Key"] for p in s3.get_paginator("list_objects_v2").paginate(Bucket=BUCKET, Prefix="UnidadesBase/")
              for o in p.get("Contents", []) if o["Key"].endswith("-UnidadesBase.geojson")]

    def estaciones(llave):
        sigla = llave.split("/")[-1].replace("-UnidadesBase.geojson", "")
        datos = json.loads(s3.get_object(Bucket=BUCKET, Key=llave)["Body"].read())
        return {(sigla, int(f["properties"]["codigo"])) for f in datos["features"] if f["properties"].get("codigo")}

    with ThreadPoolExecutor(12) as pool:
        esperadas = set().union(*pool.map(estaciones, llaves))
    objetos = {}
    for p in s3.get_paginator("list_objects_v2").paginate(Bucket=BUCKET, Prefix=f"policia-comunitaria/{args.mes}/"):
        for o in p.get("Contents", []):
            partes = o["Key"].split("/")
            if len(partes) == 4 and partes[3].endswith(".geojson") and partes[3][:-8].isdigit():
                objetos[(partes[2], int(partes[3][:-8]))] = o
    print(f"Mes {args.mes} · inicio de la corrida {desde:%Y-%m-%d %H:%M} UTC · {len(llaves)} siglas · {len(esperadas)} estaciones esperadas\n")

    faltan = sorted(esperadas - set(objetos))
    if faltan:
        linea("FALLA", f"{len(faltan)} estaciones sin archivo: {', '.join(f'{s}-{c}' for s, c in faltan[:15])}{' ...' if len(faltan) > 15 else ''}")
    else:
        linea("OK", f"las {len(esperadas)} estaciones tienen archivo")
    extra = sorted(set(objetos) - esperadas)
    if extra:
        linea("INFO", f"{len(extra)} archivos de estaciones que ya no están en UnidadesBase: {', '.join(f'{s}-{c}' for s, c in extra[:10])}")

    # 2. Frescura
    viejos = sorted(k for k, o in objetos.items() if o["LastModified"] < desde and k in esperadas)
    if viejos:
        linea("AVISO", f"{len(viejos)} archivos son anteriores a la corrida (no se refrescaron): {', '.join(f'{s}-{c}' for s, c in viejos[:10])}")
    else:
        linea("OK", "todos los archivos se escribieron durante la corrida")
    if objetos:
        ultimo = max(o["LastModified"] for o in objetos.values())
        primero = min(o["LastModified"] for k, o in objetos.items() if o["LastModified"] >= desde) if len(viejos) < len(objetos) else None
        if primero:
            linea("INFO", f"escritura de {primero:%H:%M} a {ultimo:%H:%M} UTC ({(ultimo - primero).seconds // 60} min), "
                          f"{sum(o['Size'] for o in objetos.values()) / 1e6:.0f} MB en total")

    # 3. Marcadores de error de la corrida
    errores = [o for p in s3.get_paginator("list_objects_v2").paginate(Bucket=BUCKET, Prefix=f"utilidades/errores_policia_comunitaria/{args.mes}/")
               for o in p.get("Contents", []) if o["LastModified"] >= desde]
    if errores:
        linea("FALLA", f"{len(errores)} marcadores de error desde el inicio de la corrida: " + ", ".join(o["Key"].split("/", 3)[3] for o in errores[:8]))
    else:
        linea("OK", "sin marcadores de error en utilidades/errores_policia_comunitaria/ desde el inicio de la corrida")

    # 4. Métricas de la Lambda procesador
    cw = boto3.client("cloudwatch", region_name="us-east-1")
    fin = min(datetime.now(timezone.utc), desde + timedelta(hours=3))

    def suma(metrica):
        r = cw.get_metric_statistics(Namespace="AWS/Lambda", MetricName=metrica, Dimensions=[{"Name": "FunctionName", "Value": PROCESADOR}],
                                     StartTime=desde, EndTime=fin, Period=3 * 3600, Statistics=["Sum"])
        return int(sum(d["Sum"] for d in r["Datapoints"]))

    invocaciones, fallos, limitadas = suma("Invocations"), suma("Errors"), suma("Throttles")
    linea("OK" if invocaciones >= len(esperadas) else "AVISO", f"{invocaciones} invocaciones del procesador (estaciones esperadas: {len(esperadas)})")
    linea("FALLA" if fallos else "OK", f"{fallos} errores de la Lambda procesador")
    linea("INFO", f"{limitadas} invocaciones limitadas por concurrencia (esperado: el procesador tiene concurrencia reservada 20 y Lambda las reintenta)")

    # 5. Fuentes internas que fallaron dentro de cada archivo
    if args.profundo:
        def revisar(par):
            clave, objeto = par
            datos = json.loads(s3.get_object(Bucket=BUCKET, Key=objeto["Key"])["Body"].read())
            return clave, len(datos["features"]), {n: i["error"] for n, i in (datos.get("fuentes_internas") or {}).items() if i.get("error")}

        with ThreadPoolExecutor(24) as pool:
            resultados = list(pool.map(revisar, [(k, o) for k, o in objetos.items() if k in esperadas]))
        sin_zonas = [k for k, n, _ in resultados if n == 0]
        linea("INFO", f"{sum(n for _, n, _ in resultados)} zonas en total; {len(sin_zonas)} estaciones sin zonas (normal si no hay hechos ni sitios)")
        por_fuente = defaultdict(list)
        for clave, _, fuentes in resultados:
            for fuente, error in fuentes.items():
                por_fuente[(clave[0], fuente)].append((clave, error))
        if not por_fuente:
            linea("OK", "ninguna fuente interna falló en ninguna estación")
        for (sigla, fuente), lista in sorted(por_fuente.items()):
            linea("AVISO", f"fuente {fuente} falló en {len(lista)} estaciones de {sigla} (ej. {lista[0][0][1]}): {lista[0][1][:160]}")

    print(f"\nTOTAL: {sum(conteo.values())} | {conteo['OK']} OK | {conteo['AVISO']} aviso | {conteo['FALLA']} falla")
    sys.exit(1 if conteo["FALLA"] else 0)


if __name__ == "__main__":
    main()
