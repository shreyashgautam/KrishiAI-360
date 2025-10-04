# Crop Soil Prediction API Integration

This document explains the integration of the crop soil prediction API from [https://backend-krisi.onrender.com/](https://backend-krisi.onrender.com/) into your Flutter app.

## 🌱 API Overview

The backend API provides AI-powered crop recommendations based on comprehensive soil analysis data.

### API Endpoints

1. **POST** `/soildata/insert` - Insert soil data for prediction
2. **GET** `/soildata/all` - Get all soil data records
3. **GET** `/soildata/latest` - Get the latest soil data record
4. **GET** `/` - Health check endpoint

## 📊 Data Structure

### Soil Data Input (POST /soildata/insert)
```json
{
    "N": 50.0,           // Nitrogen (ppm)
    "P": 30.0,           // Phosphorus (ppm)
    "K": 20.0,           // Potassium (ppm)
    "temperature": 25.5,  // Temperature (°C)
    "humidity": 70.2,     // Humidity (%)
    "ph": 6.5,           // pH Level
    "rainfall": 120.3,   // Rainfall (mm)
    "soil_moisture_avg": 35.0  // Soil Moisture (%)
}
```

### API Response
```json
{
    "message": "Data inserted successfully"
}
```

## 🚀 Features Implemented

### 1. Soil Data Model (`lib/models/soil_data.dart`)
- **SoilData Class**: Represents comprehensive soil analysis data
- **CropPrediction Class**: Represents AI prediction results
- **Validation**: Built-in data validation for all soil parameters
- **Serialization**: JSON serialization/deserialization support

### 2. Soil Data Service (`lib/services/soil_data_service.dart`)
- **API Integration**: Direct communication with backend API
- **Data Validation**: Comprehensive soil data validation
- **Error Handling**: Robust error handling with fallback mechanisms
- **Soil Recommendations**: AI-generated soil improvement recommendations
- **Connection Testing**: API connectivity testing

### 3. Enhanced Crop Service (`lib/services/crop_service.dart`)
- **API-Based Recommendations**: Uses real AI predictions from backend
- **Fallback System**: Falls back to local recommendations if API fails
- **Yield Estimation**: Calculates expected yield based on soil conditions
- **Sustainability Scoring**: Environmental sustainability assessment
- **Multi-language Support**: Hindi crop name translations

### 4. Enhanced Crop Advice Screen (`lib/screens/enhanced_crop_advice_screen.dart`)
- **Comprehensive Input Form**: All soil parameters in one interface
- **API Mode Toggle**: Switch between API and local recommendations
- **Real-time Connection Status**: Live API connectivity monitoring
- **Detailed Results**: Comprehensive crop recommendations with analysis
- **Interactive UI**: User-friendly interface with validation

## 🔧 Technical Implementation

### API Integration Flow
1. **Data Collection**: User inputs soil parameters
2. **Validation**: Client-side validation of all parameters
3. **API Call**: Send data to backend for AI analysis
4. **Response Processing**: Parse and format API response
5. **Recommendation Generation**: Create detailed crop recommendations
6. **Fallback**: Use local recommendations if API fails

### Error Handling Strategy
```dart
try {
  // Try API-based recommendation
  recommendation = await cropService.getCropRecommendationFromAPI(request);
} catch (e) {
  // Fallback to local recommendation
  recommendation = await cropService.getCropRecommendation(request);
}
```

### Data Validation
```dart
static bool validateSoilData(SoilData soilData) {
  return soilData.n >= 0 &&
         soilData.p >= 0 &&
         soilData.k >= 0 &&
         soilData.temperature >= -50 && soilData.temperature <= 60 &&
         soilData.humidity >= 0 && soilData.humidity <= 100 &&
         soilData.ph >= 0 && soilData.ph <= 14 &&
         soilData.rainfall >= 0 &&
         soilData.soilMoistureAvg >= 0 && soilData.soilMoistureAvg <= 100;
}
```

## 📱 User Interface

### Enhanced Crop Advice Screen Features
- **API Status Indicator**: Shows real-time connection status
- **Mode Toggle**: Switch between API and local recommendations
- **Comprehensive Form**: Input all soil parameters
- **Real-time Validation**: Immediate feedback on input errors
- **Loading States**: Visual feedback during API calls
- **Detailed Results**: Comprehensive recommendation display

### Navigation
- **Floating Action Button**: Quick access from main screen
- **Direct Route**: `/enhanced-crop-advice`
- **Integrated Navigation**: Seamless app integration

## 🧪 Testing

### API Connection Test
```dart
static Future<bool> testConnection() async {
  try {
    final response = await http.get(Uri.parse(baseUrl));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
```

### Data Validation Test
```dart
// Test with valid data
final validSoilData = SoilData(
  n: 50.0, p: 30.0, k: 20.0,
  temperature: 25.5, humidity: 70.2,
  ph: 6.5, rainfall: 120.3,
  soilMoistureAvg: 35.0,
);
assert(SoilDataService.validateSoilData(validSoilData) == true);
```

## 📊 Soil Recommendations

The system provides intelligent recommendations for each soil parameter:

### Nitrogen (N)
- **Low (< 30 ppm)**: Add nitrogen-rich fertilizers
- **Optimal (30-100 ppm)**: Maintain current levels
- **High (> 100 ppm)**: Reduce nitrogen application

### Phosphorus (P)
- **Low (< 20 ppm)**: Add phosphorus fertilizers
- **Optimal (20-80 ppm)**: Maintain current levels
- **High (> 80 ppm)**: Reduce phosphorus application

### Potassium (K)
- **Low (< 15 ppm)**: Add potassium fertilizers
- **Optimal (15-60 ppm)**: Maintain current levels
- **High (> 60 ppm)**: Reduce potassium application

### pH Level
- **Acidic (< 6.0)**: Add lime to raise pH
- **Optimal (6.0-8.0)**: Suitable for most crops
- **Alkaline (> 8.0)**: Add sulfur to lower pH

### Environmental Factors
- **Temperature**: Recommendations based on crop temperature requirements
- **Humidity**: Moisture management suggestions
- **Rainfall**: Irrigation and drainage recommendations
- **Soil Moisture**: Water management guidance

## 🔄 Integration with Existing Systems

### MongoDB Integration
- Soil data can be stored in MongoDB for historical analysis
- User profiles linked to soil data for personalized recommendations
- Offline data storage with sync when online

### Firebase Integration
- User authentication for personalized recommendations
- Cloud storage for soil data and recommendations
- Real-time updates and synchronization

## 🚀 Usage Examples

### Basic Usage
```dart
// Create soil data
final soilData = SoilData(
  n: 50.0, p: 30.0, k: 20.0,
  temperature: 25.5, humidity: 70.2,
  ph: 6.5, rainfall: 120.3,
  soilMoistureAvg: 35.0,
);

// Get crop prediction
final prediction = await SoilDataService.getCropPrediction(soilData);
```

### Advanced Usage
```dart
// Create comprehensive request
final request = CropAdviceRequest(
  soilPH: 6.5,
  soilMoisture: 35.0,
  farmSize: 2.0,
  location: 'Mumbai',
  soilData: soilData,
);

// Get API-based recommendation
final cropService = CropService();
final recommendation = await cropService.getCropRecommendationFromAPI(request);
```

## 📈 Performance Optimization

### Caching Strategy
- Local storage of recent recommendations
- Offline mode with cached data
- Smart refresh based on data age

### Error Recovery
- Automatic retry mechanism
- Graceful degradation to local recommendations
- User-friendly error messages

## 🔐 Security Considerations

### Data Validation
- Client-side validation before API calls
- Server-side validation on backend
- Input sanitization and bounds checking

### API Security
- HTTPS communication
- Error message sanitization
- Rate limiting considerations

## 🎯 Future Enhancements

### Planned Features
1. **Historical Analysis**: Track soil data over time
2. **Weather Integration**: Real-time weather data integration
3. **IoT Sensor Support**: Direct sensor data integration
4. **Machine Learning**: Local ML model for offline predictions
5. **Multi-language Support**: Extended language support
6. **Export Features**: PDF/Excel export of recommendations

### API Extensions
1. **Batch Processing**: Multiple soil samples at once
2. **Real-time Updates**: WebSocket integration
3. **Advanced Analytics**: Detailed soil health reports
4. **Crop Rotation**: Multi-season planning

## 📞 Support and Troubleshooting

### Common Issues
1. **API Connection Failed**: Check internet connectivity and API status
2. **Invalid Data**: Verify all input parameters are within valid ranges
3. **Slow Response**: API may be under load, try again later

### Debug Information
- API connection status displayed in UI
- Detailed error messages in console
- Fallback recommendations always available

## 🎉 Conclusion

The crop soil prediction API integration provides:
- **AI-Powered Recommendations**: Real machine learning predictions
- **Comprehensive Analysis**: Detailed soil parameter analysis
- **User-Friendly Interface**: Intuitive input and results display
- **Robust Error Handling**: Graceful fallbacks and error recovery
- **Future-Ready Architecture**: Extensible for additional features

The system successfully bridges the gap between traditional farming knowledge and modern AI technology, providing farmers with data-driven crop recommendations based on comprehensive soil analysis.

---

**API Base URL**: [https://backend-krisi.onrender.com/](https://backend-krisi.onrender.com/)  
**Status**: ✅ Active and Integrated  
**Last Updated**: September 2024
