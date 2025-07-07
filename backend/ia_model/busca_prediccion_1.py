import joblib
import pandas as pd
import os
from itertools import product

script_dir = os.path.dirname(os.path.abspath(__file__))

model = joblib.load(os.path.join(script_dir, "model_random_forest.joblib"))
df_mapeo_colegio = pd.read_csv(os.path.join(script_dir, "mapeo_colegio.csv"))
df_mapeo_carrera = pd.read_csv(os.path.join(script_dir, "mapeo_carrera.csv"))
df_mapeo_origen = pd.read_csv(os.path.join(script_dir, "mapeo_origen.csv"))

# Tomar solo los primeros 2 valores de cada mapeo para acelerar la búsqueda
d_colegios = df_mapeo_colegio['Colegio'].dropna().unique()[:2]
d_carreras = df_mapeo_carrera['Carrera'].dropna().unique()[:2]
d_origenes = df_mapeo_origen['Origen (Pregrado)'].dropna().unique()[:2]

años = [2020, 2024]
egresados = [0, 1]
distancias = [0.1, 10.0]

contador = 0
for colegio, carrera1, carrera2, origen, año, egresado, distancia in product(
    d_colegios, d_carreras, d_carreras, d_origenes, años, egresados, distancias):
    contador += 1
    if contador % 500 == 0:
        print(f"Probadas {contador} combinaciones...")
    data = {
        "Unnamed: 0": 1,
        "año": año,
        "egresado": egresado,
        "lat": -33.4,
        "lon": -70.6,
        "distancia": distancia,
        "colegio": colegio,
        "carrera_1": carrera1,
        "carrera_2": carrera2,
        "origen": origen
    }
    def get_id(df, col_name, id_col, value):
        row = df[df[col_name].str.lower().str.strip() == str(value).lower().strip()]
        if not row.empty:
            return int(row.iloc[0][id_col])
        return -1
    colegio_id = get_id(df_mapeo_colegio, "Colegio", "colegio_id", data["colegio"])
    carrera_1_id = get_id(df_mapeo_carrera, "Carrera", "carrera_id", data["carrera_1"])
    carrera_2_id = get_id(df_mapeo_carrera, "Carrera", "carrera_id", data["carrera_2"])
    origen_id = get_id(df_mapeo_origen, "Origen (Pregrado)", "origen_id", data["origen"])
    X = pd.DataFrame([{
        "Unnamed: 0": data["Unnamed: 0"],
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
    pred = model.predict(X)[0]
    if pred == 1:
        print("¡Encontrado registro con predicción 1!")
        print("Datos de entrada:", data)
        print("Predicción:", pred)
        break
else:
    print("No se encontró ninguna combinación que prediga 1 en el rango probado.") 