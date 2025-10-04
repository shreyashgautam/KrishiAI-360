import 'soil_data.dart';

class CropAdviceRequest {
  final double soilPH;
  final double soilMoisture; // percentage
  final double farmSize; // in acres
  final String location;
  final double? latitude;
  final double? longitude;
  final String? season;
  final SoilData? soilData; // New field for comprehensive soil data

  CropAdviceRequest({
    required this.soilPH,
    required this.soilMoisture,
    required this.farmSize,
    required this.location,
    this.latitude,
    this.longitude,
    this.season,
    this.soilData,
  });

  // Convert to SoilData format for API
  SoilData toSoilData() {
    return SoilData(
      n: soilData?.n ?? 50.0, // Default values
      p: soilData?.p ?? 30.0,
      k: soilData?.k ?? 20.0,
      temperature: soilData?.temperature ?? 25.0,
      humidity: soilData?.humidity ?? 60.0,
      ph: soilPH,
      rainfall: soilData?.rainfall ?? 100.0,
      soilMoistureAvg: soilMoisture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soilPH': soilPH,
      'soilMoisture': soilMoisture,
      'farmSize': farmSize,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'season': season,
      'soilData': soilData?.toMap(),
    };
  }

  factory CropAdviceRequest.fromJson(Map<String, dynamic> json) {
    return CropAdviceRequest(
      soilPH: json['soilPH'].toDouble(),
      soilMoisture: json['soilMoisture'].toDouble(),
      farmSize: json['farmSize'].toDouble(),
      location: json['location'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      season: json['season'],
      soilData:
          json['soilData'] != null ? SoilData.fromMap(json['soilData']) : null,
    );
  }
}

class CropAdviceResponse {
  final String cropName;
  final double confidence;
  final String description;
  final List<String> recommendations;
  final Map<String, String> soilRecommendations;
  final DateTime timestamp;

  CropAdviceResponse({
    required this.cropName,
    required this.confidence,
    required this.description,
    required this.recommendations,
    required this.soilRecommendations,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropName': cropName,
      'confidence': confidence,
      'description': description,
      'recommendations': recommendations,
      'soilRecommendations': soilRecommendations,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CropAdviceResponse.fromJson(Map<String, dynamic> json) {
    return CropAdviceResponse(
      cropName: json['cropName'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      soilRecommendations:
          Map<String, String>.from(json['soilRecommendations'] ?? {}),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }
}
