class LandData {
  final String id;
  final String name;
  final String sensorId;
  final String location;
  final double latitude;
  final double longitude;
  final String cropType;
  final double area; // in acres
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String farmerId;
  final String? adminNotes;
  final SensorData? sensorData;

  LandData({
    required this.id,
    required this.name,
    required this.sensorId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.cropType,
    required this.area,
    required this.status,
    required this.createdAt,
    this.approvedAt,
    required this.farmerId,
    this.adminNotes,
    this.sensorData,
  });

  factory LandData.fromJson(Map<String, dynamic> json) {
    return LandData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      sensorId: json['sensorId'] ?? '',
      location: json['location'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      cropType: json['cropType'] ?? '',
      area: (json['area'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      approvedAt: json['approvedAt'] != null
          ? DateTime.parse(json['approvedAt'])
          : null,
      farmerId: json['farmerId'] ?? '',
      adminNotes: json['adminNotes'],
      sensorData: json['sensorData'] != null
          ? SensorData.fromJson(json['sensorData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sensorId': sensorId,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'cropType': cropType,
      'area': area,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'farmerId': farmerId,
      'adminNotes': adminNotes,
      'sensorData': sensorData?.toJson(),
    };
  }

  LandData copyWith({
    String? id,
    String? name,
    String? sensorId,
    String? location,
    double? latitude,
    double? longitude,
    String? cropType,
    double? area,
    String? status,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? farmerId,
    String? adminNotes,
    SensorData? sensorData,
  }) {
    return LandData(
      id: id ?? this.id,
      name: name ?? this.name,
      sensorId: sensorId ?? this.sensorId,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cropType: cropType ?? this.cropType,
      area: area ?? this.area,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      farmerId: farmerId ?? this.farmerId,
      adminNotes: adminNotes ?? this.adminNotes,
      sensorData: sensorData ?? this.sensorData,
    );
  }
}

class SensorData {
  final String sensorId;
  final double temperature;
  final double humidity;
  final double soilMoisture;
  final double ph;
  final double lightIntensity;
  final DateTime lastUpdated;
  final String batteryLevel;
  final bool isOnline;
  final double n;
  final double p;
  final double k;
  final double rainfall;

  SensorData({
    required this.sensorId,
    required this.temperature,
    required this.humidity,
    required this.soilMoisture,
    required this.ph,
    required this.lightIntensity,
    required this.lastUpdated,
    required this.batteryLevel,
    required this.isOnline,
    required this.n,
    required this.p,
    required this.k,
    required this.rainfall,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      sensorId: json['sensorId'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      humidity: (json['humidity'] ?? 0.0).toDouble(),
      soilMoisture: (json['soilMoisture'] ?? 0.0).toDouble(),
      ph: (json['ph'] ?? 0.0).toDouble(),
      lightIntensity: (json['lightIntensity'] ?? 0.0).toDouble(),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : (json['timestamp'] != null
              ? DateTime.parse(json['timestamp'])
              : DateTime.now()),
      batteryLevel: json['batteryLevel'] ?? '0%',
      isOnline: json['isOnline'] ?? false,
      n: (json['N'] ?? 0.0).toDouble(),
      p: (json['P'] ?? 0.0).toDouble(),
      k: (json['K'] ?? 0.0).toDouble(),
      rainfall: (json['rainfall'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sensorId': sensorId,
      'temperature': temperature,
      'humidity': humidity,
      'soilMoisture': soilMoisture,
      'ph': ph,
      'lightIntensity': lightIntensity,
      'lastUpdated': lastUpdated.toIso8601String(),
      'batteryLevel': batteryLevel,
      'isOnline': isOnline,
      'N': n,
      'P': p,
      'K': k,
      'rainfall': rainfall,
    };
  }
}

class CropPrediction {
  final String landId;
  final String cropType;
  final double yieldPrediction;
  final String growthStage;
  final List<String> recommendations;
  final DateTime predictionDate;
  final double confidence;

  CropPrediction({
    required this.landId,
    required this.cropType,
    required this.yieldPrediction,
    required this.growthStage,
    required this.recommendations,
    required this.predictionDate,
    required this.confidence,
  });

  factory CropPrediction.fromJson(Map<String, dynamic> json) {
    return CropPrediction(
      landId: json['landId'] ?? '',
      cropType: json['cropType'] ?? '',
      yieldPrediction: (json['yieldPrediction'] ?? 0.0).toDouble(),
      growthStage: json['growthStage'] ?? '',
      recommendations: List<String>.from(json['recommendations'] ?? []),
      predictionDate: json['predictionDate'] != null
          ? DateTime.parse(json['predictionDate'])
          : DateTime.now(),
      confidence: (json['confidence'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'landId': landId,
      'cropType': cropType,
      'yieldPrediction': yieldPrediction,
      'growthStage': growthStage,
      'recommendations': recommendations,
      'predictionDate': predictionDate.toIso8601String(),
      'confidence': confidence,
    };
  }
}

class LandRegistrationForm {
  final String name;
  final String sensorId;
  final String location;
  final double latitude;
  final double longitude;
  final String cropType;
  final double area;
  final String description;

  LandRegistrationForm({
    required this.name,
    required this.sensorId,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.cropType,
    required this.area,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sensorId': sensorId,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'cropType': cropType,
      'area': area,
      'description': description,
    };
  }
}
