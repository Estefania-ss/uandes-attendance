import sys
import json
import joblib
import pandas as pd
import os

script_dir = os.path.dirname(os.path.abspath(__file__))

model = joblib.load(os.path.join(script_dir, "model_random_forest.joblib"))
df_mapeo_colegio = pd.read_csv(os.path.join(script_dir, "mapeo_colegio.csv"))
df_mapeo_carrera = pd.read_csv(os.path.join(script_dir, "mapeo_carrera.csv"))
df_mapeo_origen = pd.read_csv(os.path.join(script_dir, "mapeo_origen.csv"))

def get_id(df, col_name, id_col, value):
    row = df[df[col_name].str.lower().str.strip() == str(value).lower().strip()]
    if not row.empty:
        return int(row.iloc[0][id_col])
    return -1

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python predict.py '{json}'", file=sys.stderr)
        sys.exit(1)
    data = json.loads(sys.argv[1])

    colegio_id = get_id(df_mapeo_colegio, "Colegio", "colegio_id", data["colegio"])
    carrera_1_id = get_id(df_mapeo_carrera, "Carrera", "carrera_id", data["carrera_1"])
    carrera_2_id = get_id(df_mapeo_carrera, "Carrera", "carrera_id", data["carrera_2"])
    origen_id = get_id(df_mapeo_origen, "Origen (Pregrado)", "origen_id", data["origen"])

    print(f"[DEBUG] colegio_id: {colegio_id}, carrera_1_id: {carrera_1_id}, carrera_2_id: {carrera_2_id}, origen_id: {origen_id}")
    if -1 in [colegio_id, carrera_1_id, carrera_2_id, origen_id]:
        print("[WARNING] Al menos un valor mapeado es -1. Revisa los nombres de entrada y los archivos de mapeo.")

    X = pd.DataFrame([{
        "año": data["año"],
        "egresado": data["egresado"],
        "lat": data["lat"],
        "lon": data["lon"],
        "distancia": data["distancia"],
        "colegio_id": colegio_id,
        "carrera_1_id": carrera_1_id,
        "carrera_2_id": carrera_2_id,
        "origen_id": origen_id
    }])

    print("[DEBUG] Datos de entrada al modelo:")
    print(X)

    try:
        pred = model.predict(X)[0]
        print(pred)
    except Exception as e:
        print(f"Predicción fallida: {e}", file=sys.stderr)
        sys.exit(1)