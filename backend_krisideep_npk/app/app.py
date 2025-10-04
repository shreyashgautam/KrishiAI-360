import joblib
import numpy as np
from fastapi import FastAPI
from pydantic import BaseModel

# Load trained model
model = joblib.load("app/npk_model.pkl")
model_columns = list(model.feature_names_in_)  # Columns expected by model

# FastAPI request schema
class SoilInput(BaseModel):
    Temparature: float
    Humidity: float
    Moisture: float
    Soil_Type: str

app = FastAPI()

@app.post("/predict")
async def predict(data: SoilInput):
    # Convert input to dict
    input_dict = data.dict()
    
    # Start with numeric features
    features = {
        "Temparature": input_dict['Temparature'],
        "Humidity": input_dict['Humidity'],
        "Moisture": input_dict['Moisture']
    }

    # One-hot encode soil type according to training columns
    for col in model_columns:
        if col.startswith("Soil Type_"):
            features[col] = 1 if col == f"Soil Type_{input_dict['Soil_Type']}" else 0
    
    # Convert to array in correct column order
    features_array = np.array([features[col] for col in model_columns]).reshape(1, -1)

    # Predict
    pred = model.predict(features_array)

    return {
        "Nitrogen": float(pred[0][0]),
        "Phosphorous": float(pred[0][1]),
        "Potassium": float(pred[0][2])
    }
