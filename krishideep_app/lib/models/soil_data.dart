class SoilData {
  final double n; // Nitrogen
  final double p; // Phosphorus
  final double k; // Potassium
  final double temperature;
  final double humidity;
  final double ph;
  final double rainfall;
  final double soilMoistureAvg;
  final String? id;
  final DateTime? createdAt;

  SoilData({
    required this.n,
    required this.p,
    required this.k,
    required this.temperature,
    required this.humidity,
    required this.ph,
    required this.rainfall,
    required this.soilMoistureAvg,
    this.id,
    this.createdAt,
  });

  // Convert to Map for API request
  Map<String, dynamic> toMap() {
    return {
      'N': n,
      'P': p,
      'K': k,
      'temperature': temperature,
      'humidity': humidity,
      'ph': ph,
      'rainfall': rainfall,
      'soil_moisture_avg': soilMoistureAvg,
    };
  }

  // Create from API response
  factory SoilData.fromMap(Map<String, dynamic> map) {
    return SoilData(
      n: (map['N'] ?? map['n'] ?? 0.0).toDouble(),
      p: (map['P'] ?? map['p'] ?? 0.0).toDouble(),
      k: (map['K'] ?? map['k'] ?? 0.0).toDouble(),
      temperature: (map['temperature'] ?? 0.0).toDouble(),
      humidity: (map['humidity'] ?? 0.0).toDouble(),
      ph: (map['ph'] ?? 0.0).toDouble(),
      rainfall: (map['rainfall'] ?? 0.0).toDouble(),
      soilMoistureAvg:
          (map['soil_moisture_avg'] ?? map['soilMoistureAvg'] ?? 0.0)
              .toDouble(),
      id: map['_id'] ?? map['id'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  // Copy with method for updates
  SoilData copyWith({
    double? n,
    double? p,
    double? k,
    double? temperature,
    double? humidity,
    double? ph,
    double? rainfall,
    double? soilMoistureAvg,
    String? id,
    DateTime? createdAt,
  }) {
    return SoilData(
      n: n ?? this.n,
      p: p ?? this.p,
      k: k ?? this.k,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      ph: ph ?? this.ph,
      rainfall: rainfall ?? this.rainfall,
      soilMoistureAvg: soilMoistureAvg ?? this.soilMoistureAvg,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SoilData(n: $n, p: $p, k: $k, temperature: $temperature, humidity: $humidity, ph: $ph, rainfall: $rainfall, soilMoistureAvg: $soilMoistureAvg)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoilData &&
        other.n == n &&
        other.p == p &&
        other.k == k &&
        other.temperature == temperature &&
        other.humidity == humidity &&
        other.ph == ph &&
        other.rainfall == rainfall &&
        other.soilMoistureAvg == soilMoistureAvg;
  }

  @override
  int get hashCode {
    return n.hashCode ^
        p.hashCode ^
        k.hashCode ^
        temperature.hashCode ^
        humidity.hashCode ^
        ph.hashCode ^
        rainfall.hashCode ^
        soilMoistureAvg.hashCode;
  }
}

class CropPrediction {
  final String cropName;
  final double confidence;
  final String? description;
  final Map<String, dynamic>? additionalData;

  CropPrediction({
    required this.cropName,
    required this.confidence,
    this.description,
    this.additionalData,
  });

  factory CropPrediction.fromMap(Map<String, dynamic> map) {
    return CropPrediction(
      cropName: map['crop_name'] ?? map['cropName'] ?? 'Unknown',
      confidence: (map['confidence'] ?? 0.0).toDouble(),
      description: map['description'],
      additionalData: map['additional_data'] ?? map['additionalData'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'crop_name': cropName,
      'confidence': confidence,
      'description': description,
      'additional_data': additionalData,
    };
  }
}
