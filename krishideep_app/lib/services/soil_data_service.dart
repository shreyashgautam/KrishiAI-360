import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/soil_data.dart';

class SoilDataService {
  static const String baseUrl = 'https://backend-krisi.onrender.com';
  static const String predictionUrl = 'https://backend-krisi-ml.onrender.com';

  // Enhanced headers to handle CORS
  static const Map<String, String> _corsHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };

  // Alternative CORS-friendly headers
  static const Map<String, String> _alternativeHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Method to handle CORS issues with retry mechanism
  static Future<http.Response> _makeRequestWithCorsHandling(
      String url, Map<String, String> headers,
      {String? body, String method = 'GET'}) async {
    try {
      // First attempt with full CORS headers
      http.Response response;
      if (method == 'POST') {
        response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: body,
        );
      } else {
        response = await http.get(
          Uri.parse(url),
          headers: headers,
        );
      }

      // If successful, return response
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      }

      // If CORS error, try with minimal headers
      if (response.statusCode == 0 || response.statusCode == 403) {
        print('CORS issue detected, trying with minimal headers...');
        if (method == 'POST') {
          response = await http.post(
            Uri.parse(url),
            headers: _alternativeHeaders,
            body: body,
          );
        } else {
          response = await http.get(
            Uri.parse(url),
            headers: _alternativeHeaders,
          );
        }
      }

      return response;
    } catch (e) {
      print('Request failed: $e');
      rethrow;
    }
  }

  // Insert soil data for prediction
  static Future<Map<String, dynamic>> insertSoilData(SoilData soilData) async {
    try {
      final response = await _makeRequestWithCorsHandling(
        '$baseUrl/soildata/insert',
        _corsHeaders,
        body: jsonEncode(soilData.toMap()),
        method: 'POST',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        print('Soil data inserted successfully: $responseData');
        return responseData;
      } else {
        print(
            'Failed to insert soil data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to insert soil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error inserting soil data: $e');
      throw Exception('Error inserting soil data: $e');
    }
  }

  // Get all soil data
  static Future<List<SoilData>> getAllSoilData() async {
    try {
      final response = await _makeRequestWithCorsHandling(
        '$baseUrl/soildata/all',
        _corsHeaders,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => SoilData.fromMap(item)).toList();
      } else {
        print(
            'Failed to get soil data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get soil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting soil data: $e');
      throw Exception('Error getting soil data: $e');
    }
  }

  // Get latest soil data
  static Future<SoilData?> getLatestSoilData() async {
    try {
      final response = await _makeRequestWithCorsHandling(
        '$baseUrl/soildata/latest',
        _corsHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          return SoilData.fromMap(data);
        }
        return null;
      } else {
        print(
            'Failed to get latest soil data: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to get latest soil data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting latest soil data: $e');
      throw Exception('Error getting latest soil data: $e');
    }
  }

  // Get crop prediction based on soil data
  static Future<CropPrediction?> getCropPrediction(SoilData soilData) async {
    try {
      // Use the prediction endpoint directly
      final response = await _makeRequestWithCorsHandling(
        '$predictionUrl/predict',
        _corsHeaders,
        body: jsonEncode(soilData.toMap()),
        method: 'POST',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Prediction response: $data');

        // Handle the response format: {"predicted_crop": "muskmelon"}
        if (data.containsKey('predicted_crop')) {
          return CropPrediction(
            cropName: data['predicted_crop'],
            confidence: 85.0, // Default confidence since API doesn't provide it
            description: 'AI-recommended crop based on soil analysis',
          );
        } else {
          print('Unexpected response format: $data');
          return null;
        }
      } else {
        print(
            'Failed to get crop prediction: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error getting crop prediction: $e');
      // For CORS issues, provide a fallback prediction
      if (e.toString().contains('XMLHttpRequest error') ||
          e.toString().contains('CORS') ||
          e.toString().contains('blocked')) {
        print('CORS issue detected - providing fallback prediction');
        return getFallbackPrediction(soilData);
      }
      return null;
    }
  }

  // Get intelligent fallback prediction based on soil data
  static CropPrediction getFallbackPrediction(SoilData soilData) {
    String cropName = 'Rice'; // Default fallback
    double confidence = 70.0;
    String description = 'Local recommendation based on soil analysis';

    // Analyze soil conditions to suggest appropriate crops
    if (soilData.ph < 6.0) {
      // Acidic soil - good for potatoes, tomatoes
      if (soilData.temperature > 20) {
        cropName = 'Tomato';
        description = 'Acidic soil with warm temperature - ideal for tomatoes';
      } else {
        cropName = 'Potato';
        description = 'Acidic soil - excellent for potatoes';
      }
    } else if (soilData.ph > 8.0) {
      // Alkaline soil - good for wheat, barley
      cropName = 'Wheat';
      description = 'Alkaline soil - suitable for wheat cultivation';
    } else {
      // Neutral pH - analyze other factors
      if (soilData.temperature > 25 && soilData.humidity > 60) {
        cropName = 'Rice';
        description = 'Warm and humid conditions - ideal for rice';
      } else if (soilData.temperature < 20) {
        cropName = 'Wheat';
        description = 'Cool temperature - suitable for wheat';
      } else if (soilData.n > 80 && soilData.p > 50) {
        cropName = 'Maize';
        description = 'High nutrient levels - good for maize';
      } else {
        cropName = 'Soybean';
        description = 'Balanced soil conditions - suitable for soybeans';
      }
    }

    return CropPrediction(
      cropName: cropName,
      confidence: confidence,
      description: description,
    );
  }

  // Test API connection
  static Future<bool> testConnection() async {
    try {
      // Test with sample data to the prediction endpoint
      final testData = {
        "N": 110,
        "P": 115,
        "K": 120,
        "temperature": 18,
        "humidity": 100,
        "ph": 1.8,
        "rainfall": 20,
        "soil_moisture_avg": 20
      };

      final response = await _makeRequestWithCorsHandling(
        '$predictionUrl/predict',
        _corsHeaders,
        body: jsonEncode(testData),
        method: 'POST',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API connection successful: $data');
        return true;
      } else {
        print(
            'API connection failed: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('API connection error: $e');
      // For CORS issues, we'll return false to indicate API is not accessible
      if (e.toString().contains('XMLHttpRequest error') ||
          e.toString().contains('CORS') ||
          e.toString().contains('blocked')) {
        print('CORS issue detected - API is blocked by browser');
        return false; // API is not accessible due to CORS
      }
      return false;
    }
  }

  // Validate soil data
  static bool validateSoilData(SoilData soilData) {
    return soilData.n >= 0 &&
        soilData.p >= 0 &&
        soilData.k >= 0 &&
        soilData.temperature >= -50 &&
        soilData.temperature <= 60 &&
        soilData.humidity >= 0 &&
        soilData.humidity <= 100 &&
        soilData.ph >= 0 &&
        soilData.ph <= 14 &&
        soilData.rainfall >= 0 &&
        soilData.soilMoistureAvg >= 0 &&
        soilData.soilMoistureAvg <= 100;
  }

  // Get soil data recommendations based on values
  static Map<String, String> getSoilRecommendations(SoilData soilData) {
    Map<String, String> recommendations = {};

    // Nitrogen recommendations
    if (soilData.n < 30) {
      recommendations['Nitrogen'] =
          'Low nitrogen levels. Consider adding nitrogen-rich fertilizers.';
    } else if (soilData.n > 100) {
      recommendations['Nitrogen'] =
          'High nitrogen levels. Reduce nitrogen application.';
    } else {
      recommendations['Nitrogen'] = 'Nitrogen levels are optimal.';
    }

    // Phosphorus recommendations
    if (soilData.p < 20) {
      recommendations['Phosphorus'] =
          'Low phosphorus levels. Add phosphorus fertilizers.';
    } else if (soilData.p > 80) {
      recommendations['Phosphorus'] =
          'High phosphorus levels. Reduce phosphorus application.';
    } else {
      recommendations['Phosphorus'] = 'Phosphorus levels are optimal.';
    }

    // Potassium recommendations
    if (soilData.k < 15) {
      recommendations['Potassium'] =
          'Low potassium levels. Add potassium fertilizers.';
    } else if (soilData.k > 60) {
      recommendations['Potassium'] =
          'High potassium levels. Reduce potassium application.';
    } else {
      recommendations['Potassium'] = 'Potassium levels are optimal.';
    }

    // pH recommendations
    if (soilData.ph < 6.0) {
      recommendations['pH'] =
          'Soil is acidic. Consider adding lime to raise pH.';
    } else if (soilData.ph > 8.0) {
      recommendations['pH'] =
          'Soil is alkaline. Consider adding sulfur to lower pH.';
    } else {
      recommendations['pH'] = 'Soil pH is optimal for most crops.';
    }

    // Temperature recommendations
    if (soilData.temperature < 15) {
      recommendations['Temperature'] =
          'Low temperature. Consider cold-tolerant crops or greenhouse cultivation.';
    } else if (soilData.temperature > 35) {
      recommendations['Temperature'] =
          'High temperature. Consider heat-tolerant crops or shade protection.';
    } else {
      recommendations['Temperature'] =
          'Temperature is suitable for most crops.';
    }

    // Humidity recommendations
    if (soilData.humidity < 40) {
      recommendations['Humidity'] =
          'Low humidity. Consider irrigation and moisture retention techniques.';
    } else if (soilData.humidity > 80) {
      recommendations['Humidity'] =
          'High humidity. Ensure good ventilation and disease prevention.';
    } else {
      recommendations['Humidity'] = 'Humidity levels are optimal.';
    }

    // Rainfall recommendations
    if (soilData.rainfall < 50) {
      recommendations['Rainfall'] =
          'Low rainfall. Consider drought-resistant crops and irrigation.';
    } else if (soilData.rainfall > 200) {
      recommendations['Rainfall'] =
          'High rainfall. Ensure proper drainage and waterlogging prevention.';
    } else {
      recommendations['Rainfall'] = 'Rainfall levels are adequate.';
    }

    // Soil moisture recommendations
    if (soilData.soilMoistureAvg < 20) {
      recommendations['Soil Moisture'] =
          'Low soil moisture. Increase irrigation frequency.';
    } else if (soilData.soilMoistureAvg > 60) {
      recommendations['Soil Moisture'] =
          'High soil moisture. Improve drainage and reduce irrigation.';
    } else {
      recommendations['Soil Moisture'] = 'Soil moisture levels are optimal.';
    }

    return recommendations;
  }
}
