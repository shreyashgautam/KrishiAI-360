import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/land_data.dart';

class LandService {
  static const String _baseUrl =
      'https://your-api-endpoint.com/api'; // Replace with actual API
  static const String _landEndpoint = '/lands';
  static const String _sensorEndpoint = '/sensors';
  static const String _predictionEndpoint = '/predictions';

  // Get all lands for a farmer
  Future<List<LandData>> getFarmerLands(String farmerId) async {
    // Always return mock data for development with real sensor data
    print('Using mock data for farmer lands with real sensor data');
    return await _getMockLands();
  }

  // Get specific land details
  Future<LandData> getLandDetails(String landId) async {
    // Always return mock data for development with real sensor data
    print('Using mock data for land details with real sensor data');
    return await _getMockLandDetails(landId);
  }

  // Register new land
  Future<bool> registerLand(LandRegistrationForm form, String farmerId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl$_landEndpoint/register'),
        headers: await _getHeaders(),
        body: json.encode({
          ...form.toJson(),
          'farmerId': farmerId,
          'status': 'pending',
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error registering land: $e');
      // For development, simulate success
      return true;
    }
  }

  // Get sensor data for a land
  Future<SensorData> getSensorData(String sensorId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_sensorEndpoint/$sensorId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return SensorData.fromJson(data);
      } else {
        throw Exception('Failed to load sensor data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sensor data: $e');
      // Return mock data for development
      return _getMockSensorData(sensorId);
    }
  }

  // Get crop prediction for a land
  Future<CropPrediction> getCropPrediction(String landId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_predictionEndpoint/land/$landId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return CropPrediction.fromJson(data);
      } else {
        throw Exception(
            'Failed to load crop prediction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching crop prediction: $e');
      // Return mock data for development
      return _getMockCropPrediction(landId);
    }
  }

  // Update land information
  Future<bool> updateLand(String landId, Map<String, dynamic> updates) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl$_landEndpoint/$landId'),
        headers: await _getHeaders(),
        body: json.encode(updates),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating land: $e');
      return false;
    }
  }

  // Delete land
  Future<bool> deleteLand(String landId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl$_landEndpoint/$landId'),
        headers: await _getHeaders(),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting land: $e');
      return false;
    }
  }

  // Get headers for API requests
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Mock data for development - Only one land with real sensor data
  Future<List<LandData>> _getMockLands() async {
    // Try to fetch real sensor data first
    final realSensorData = await _fetchRealSensorData('SENSOR_001');

    return [
      LandData(
        id: '1',
        name: 'Land 1',
        sensorId: 'SENSOR_001',
        location: 'Chennai, Tamil Nadu',
        latitude: 13.0827,
        longitude: 80.2707,
        cropType: 'Rice',
        area: 2.5,
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        approvedAt: DateTime.now().subtract(const Duration(days: 25)),
        farmerId: 'farmer_001',
        sensorData: realSensorData ?? _getMockSensorData('SENSOR_001'),
      ),
    ];
  }

  Future<LandData> _getMockLandDetails(String landId) async {
    // Try to fetch real sensor data first
    final realSensorData = await _fetchRealSensorData('SENSOR_001');

    return LandData(
      id: landId,
      name: 'Land 1',
      sensorId: 'SENSOR_001',
      location: 'Chennai, Tamil Nadu',
      latitude: 13.0827,
      longitude: 80.2707,
      cropType: 'Rice',
      area: 2.5,
      status: 'approved',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      approvedAt: DateTime.now().subtract(const Duration(days: 25)),
      farmerId: 'farmer_001',
      sensorData: realSensorData ?? _getMockSensorData('SENSOR_001'),
    );
  }

  SensorData _getMockSensorData(String sensorId) {
    return SensorData(
      sensorId: sensorId,
      temperature: 28.5,
      humidity: 65.0,
      soilMoisture: 45.0,
      ph: 6.8,
      lightIntensity: 750.0,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 5)),
      batteryLevel: '85%',
      isOnline: true,
      n: 50.0,
      p: 30.0,
      k: 20.0,
      rainfall: 120.3,
    );
  }

  // Fetch real sensor data from backend API
  Future<SensorData?> _fetchRealSensorData(String sensorId) async {
    try {
      final response = await http.get(
        Uri.parse('https://backend-krisi.onrender.com/soildata/latest'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Real sensor data fetched: $data');

        // Convert API response to SensorData
        return SensorData(
          sensorId: sensorId,
          temperature: data['temperature']?.toDouble() ?? 25.0,
          humidity: data['humidity']?.toDouble() ?? 70.0,
          soilMoisture: data['soil_moisture_avg']?.toDouble() ?? 35.0,
          ph: data['ph']?.toDouble() ?? 6.5,
          lightIntensity: 750.0, // Not provided by API
          lastUpdated: DateTime.now(),
          batteryLevel: '95%', // Assume good battery for real data
          isOnline: true,
          n: data['N']?.toDouble() ?? 50.0,
          p: data['P']?.toDouble() ?? 30.0,
          k: data['K']?.toDouble() ?? 20.0,
          rainfall: data['rainfall']?.toDouble() ?? 120.3,
        );
      } else {
        print('❌ Failed to fetch real sensor data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching real sensor data: $e');
      return null;
    }
  }

  CropPrediction _getMockCropPrediction(String landId) {
    return CropPrediction(
      landId: landId,
      cropType: 'Rice',
      yieldPrediction: 4.2,
      growthStage: 'Vegetative',
      recommendations: [
        'Increase irrigation frequency',
        'Apply nitrogen fertilizer',
        'Monitor for pest infestation',
        'Check soil pH levels'
      ],
      predictionDate: DateTime.now(),
      confidence: 0.85,
    );
  }
}
