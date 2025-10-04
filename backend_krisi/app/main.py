from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .routes import soil_routes

app = FastAPI(title="Crop Soil API", version="1.0")

# ===== CORS MIDDLEWARE =====
# Development ke liye allow all origins. Production me apni Flutter app ka domain use karo.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # ["https://your-flutter-app.com"] production me
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ===== Include Routes =====
app.include_router(soil_routes.router)

# ===== Root Endpoint =====
@app.get("/")
def root():
    return {"message": "🌱 Crop Soil API is running"}
