#include <WiFi.h>
#include <HTTPClient.h>
#include "DHT.h"

// ----- WIFI CONFIG -----
const char* ssid = "Chocopie";
const char* password = "testingg";

// ----- DHT CONFIG -----
#define DHTPIN 14
#define DHTTYPE DHT11
DHT dht(DHTPIN, DHTTYPE);

// ----- SOIL MOISTURE CONFIG -----
#define SOIL_PIN 34 // GPIO34 for analog soil moisture

// ----- PH SENSOR CONFIG -----
#define PH_PIN 35 // GPIO35 for analog pH sensor

// ----- SERVER CONFIG -----
const char* predictAPI = "https://backend-krisideep-npk.onrender.com/predict";
const char* insertAPI  = "https://backend-krisi.onrender.com/soildata/insert";  // <-- replace with your actual insert API

// Rainfall estimation constants
const float RH_threshold = 70.0;  // Humidity threshold in %
const float k = 150.0;            // Max rainfall estimate (mm)
const float T_max = 40.0;         // Max temperature for scaling (°C)

float estimateRainfall(float humidity, float temperature) {
  if (humidity < RH_threshold) {
    return 0.0;
  }
  float rain_estimate = k * (humidity - RH_threshold) / (100.0 - RH_threshold) * (1.0 - temperature / T_max);
  if (rain_estimate < 0) rain_estimate = 0.0;
  return rain_estimate;
}

void setup() {
  Serial.begin(115200);
  dht.begin();

  // Connect to Wi-Fi
  WiFi.disconnect(true);  
  delay(1000);
  WiFi.begin(ssid, password);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi!");
}

void loop() {
  // 1. Read sensors
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  int soil_adc = analogRead(SOIL_PIN);
  int soil_percent = 100 - (soil_adc * 100 / 4095); // scale to 0–100%

  int ph_adc = analogRead(PH_PIN);
  float voltage = ph_adc * (3.3 / 4095.0);  // ADC to voltage
  float phValue = 3.5 * voltage;  // Estimated pH (calibrate for accuracy)

  if (isnan(temperature) || isnan(humidity)) {
    Serial.println("Failed to read from DHT sensor!");
    delay(2000);
    return;
  }

  // Calculate rainfall
  float rainfall = estimateRainfall(humidity, temperature);

  // 2. Call Predict API first to get NPK
  String predictPayload = "{";
  predictPayload += "\"Temparature\": " + String(temperature) + ",";
  predictPayload += "\"Humidity\": " + String(humidity) + ",";
  predictPayload += "\"Moisture\": " + String(soil_percent) + ",";
  predictPayload += "\"Soil_Type\": \"Sandy\",";
  predictPayload += "\"Crop_Type\": \"Maize\"";
  predictPayload += "}";

  Serial.println("Sending to Predict API: " + predictPayload);

  float N = 0.0, P = 0.0, K = 0.0; // default values

  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(predictAPI);
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(predictPayload);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("Predict Response: " + response);

      // crude JSON parsing (since ESP32 has limited JSON libs)
      int nIndex = response.indexOf("\"Nitrogen\":");
      int pIndex = response.indexOf("\"Phosphorous\":");
      int kIndex = response.indexOf("\"Potassium\":");

      if (nIndex != -1 && pIndex != -1 && kIndex != -1) {
        N = response.substring(nIndex + 11, response.indexOf(",", nIndex)).toFloat();
        P = response.substring(pIndex + 14, response.indexOf(",", pIndex)).toFloat();
        K = response.substring(kIndex + 12, response.indexOf("}", kIndex)).toFloat();
      }
    } else {
      Serial.println("Error calling Predict API: " + String(httpResponseCode));
    }
    http.end();
  }

  // 3. Create final JSON for Insert API
  String jsonData = "{";
  jsonData += "\"N\": " + String(N) + ",";
  jsonData += "\"P\": " + String(P) + ",";
  jsonData += "\"K\": " + String(K) + ",";
  jsonData += "\"temperature\": " + String(temperature) + ",";
  jsonData += "\"humidity\": " + String(humidity) + ",";
  jsonData += "\"ph\": " + String(phValue, 2) + ",";
  jsonData += "\"rainfall\": " + String(rainfall, 2) + ",";
  jsonData += "\"soil_moisture_avg\": " + String(soil_percent);
  jsonData += "}";

  Serial.println("Final JSON to Insert API: " + jsonData);

  // 4. Send POST request to Insert API
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(insertAPI);
    http.addHeader("Content-Type", "application/json");

    int httpResponseCode = http.POST(jsonData);

    if (httpResponseCode > 0) {
      String response = http.getString();
      Serial.println("Insert API Response: " + response);
    } else {
      Serial.println("Error sending Insert POST: " + String(httpResponseCode));
    }
    http.end();
  } else {
    Serial.println("WiFi Disconnected!");
  }

  delay(30000); // wait before next cycle
}