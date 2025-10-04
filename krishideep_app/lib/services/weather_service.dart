import 'dart:math' as math;
import '../models/weather.dart';
import 'google_weather_service.dart';

class WeatherService {
  final GoogleWeatherService _googleWeatherService = GoogleWeatherService();

  // Get current weather for location using Google Weather API
  Future<WeatherData> getCurrentWeather(String location) async {
    try {
      // For now, we'll use default coordinates for Delhi
      // In a real app, you'd get coordinates from the location string
      double latitude = 28.6139;
      double longitude = 77.2090;

      // Try to get coordinates from location string if it contains coordinates
      if (location.contains(',')) {
        final parts = location.split(',');
        if (parts.length == 2) {
          latitude = double.tryParse(parts[0].trim()) ?? 28.6139;
          longitude = double.tryParse(parts[1].trim()) ?? 77.2090;
        }
      }

      final weatherData =
          await _googleWeatherService.getCurrentWeather(latitude, longitude);
      final forecast =
          await _googleWeatherService.getWeatherForecast(latitude, longitude);

      return WeatherData(
        location: location.isEmpty ? weatherData.location : location,
        temperature: weatherData.temperature,
        humidity: weatherData.humidity,
        condition: weatherData.condition,
        conditionHindi: weatherData.conditionHindi,
        rainfall: weatherData.rainfall,
        windSpeed: weatherData.windSpeed,
        timestamp: weatherData.timestamp,
        forecast: forecast,
      );
    } catch (e) {
      print('Error fetching weather data: $e');
      // Fallback to mock data
      return _getMockWeatherData(location);
    }
  }

  // Mock weather data fallback
  WeatherData _getMockWeatherData(String location) {
    final random = math.Random();
    final conditions = [
      'Sunny',
      'Partly Cloudy',
      'Cloudy',
      'Rainy',
      'Thunderstorm',
      'Foggy'
    ];
    final conditionsHindi = [
      'धूप',
      'आंशिक रूप से बादल',
      'बादल',
      'बारिश',
      'तूफान',
      'कोहरा'
    ];
    final conditionIndex = random.nextInt(conditions.length);

    // Generate 7-day forecast
    final forecast = List.generate(7, (index) {
      final date = DateTime.now().add(Duration(days: index + 1));
      final maxTemp = 25.0 + random.nextDouble() * 15; // 25-40°C
      final minTemp =
          maxTemp - (8 + random.nextDouble() * 7); // 8-15°C difference

      return WeatherForecast(
        date: date,
        maxTemp: maxTemp,
        minTemp: minTemp,
        condition: conditions[random.nextInt(conditions.length)],
        conditionHindi: conditionsHindi[random.nextInt(conditionsHindi.length)],
        rainProbability: random.nextDouble() * 100,
      );
    });

    return WeatherData(
      location: location.isEmpty ? 'Delhi' : location,
      temperature: 20.0 + random.nextDouble() * 20, // 20-40°C
      humidity: 30.0 + random.nextDouble() * 50, // 30-80%
      condition: conditions[conditionIndex],
      conditionHindi: conditionsHindi[conditionIndex],
      rainfall: random.nextDouble() * 10, // 0-10mm
      windSpeed: 5.0 + random.nextDouble() * 15, // 5-20 km/h
      timestamp: DateTime.now(),
      forecast: forecast,
    );
  }

  // Get weather alerts using Google Weather API
  Future<List<WeatherAlert>> getWeatherAlerts(String location) async {
    try {
      return await _googleWeatherService.getWeatherAlerts(location);
    } catch (e) {
      print('Error fetching weather alerts: $e');
      // Fallback to mock alerts
      return _getMockAlerts();
    }
  }

  // Mock alerts fallback
  List<WeatherAlert> _getMockAlerts() {
    final random = math.Random();
    final alerts = <WeatherAlert>[];

    // Generate random alerts
    if (random.nextBool()) {
      alerts.add(WeatherAlert(
        id: '1',
        title: 'Heavy Rain Alert',
        titleHindi: 'भारी बारिश की चेतावनी',
        description:
            'Heavy rainfall expected in the next 24 hours. Avoid field activities.',
        descriptionHindi:
            'अगले 24 घंटों में भारी बारिश की उम्मीद है। खेत की गतिविधियों से बचें।',
        severity: 'high',
        alertTime: DateTime.now(),
        expiryTime: DateTime.now().add(const Duration(hours: 24)),
      ));
    }

    if (random.nextBool()) {
      alerts.add(WeatherAlert(
        id: '2',
        title: 'Frost Warning',
        titleHindi: 'पाला चेतावनी',
        description:
            'Frost conditions possible tonight. Protect sensitive crops.',
        descriptionHindi:
            'आज रात पाला पड़ने की संभावना। संवेदनशील फसलों की रक्षा करें।',
        severity: 'medium',
        alertTime: DateTime.now(),
        expiryTime: DateTime.now().add(const Duration(hours: 12)),
      ));
    }

    return alerts;
  }

  // Get crop-specific weather recommendations using Google Weather API
  Future<List<String>> getWeatherRecommendations(
    WeatherData weather,
    String cropType,
  ) async {
    try {
      return await _googleWeatherService.getWeatherRecommendations(
          weather, cropType);
    } catch (e) {
      print('Error fetching weather recommendations: $e');
      // Fallback to mock recommendations
      return _getMockRecommendations(weather, cropType);
    }
  }

  // Mock recommendations fallback
  List<String> _getMockRecommendations(WeatherData weather, String cropType) {
    final recommendations = <String>[];

    // Temperature-based recommendations
    if (weather.temperature > 35) {
      recommendations
          .add('High temperature detected. Increase irrigation frequency.');
      recommendations.add('उच्च तापमान का पता चला। सिंचाई की आवृत्ति बढ़ाएं।');
    }

    if (weather.temperature < 10) {
      recommendations
          .add('Low temperature alert. Protect crops from frost damage.');
      recommendations.add('कम तापमान चेतावनी। फसलों को पाले से बचाएं।');
    }

    // Humidity-based recommendations
    if (weather.humidity > 80) {
      recommendations
          .add('High humidity may cause fungal diseases. Monitor crop health.');
      recommendations.add(
          'उच्च आर्द्रता फंगल रोग का कारण बन सकती है। फसल स्वास्थ्य की निगरानी करें।');
    }

    // Rainfall-based recommendations
    if (weather.rainfall > 5) {
      recommendations
          .add('Heavy rainfall expected. Ensure proper drainage in fields.');
      recommendations.add(
          'भारी बारिश की उम्मीद है। खेतों में उचित जल निकासी सुनिश्चित करें।');
    }

    // Crop-specific recommendations
    if (cropType.toLowerCase().contains('rice')) {
      if (weather.rainfall < 2 && weather.humidity < 60) {
        recommendations.add('Rice crops need more water. Increase irrigation.');
        recommendations.add('चावल की फसल को अधिक पानी चाहिए। सिंचाई बढ़ाएं।');
      }
    } else if (cropType.toLowerCase().contains('wheat')) {
      if (weather.temperature > 30) {
        recommendations.add(
            'High temperature may affect wheat grain filling. Monitor closely.');
        recommendations.add(
            'उच्च तापमान गेहूं के दाने भरने को प्रभावित कर सकता है। बारीकी से निगरानी करें।');
      }
    }

    // Default recommendations if no specific ones
    if (recommendations.isEmpty) {
      recommendations
          .add('Weather conditions are favorable for farming activities.');
      recommendations
          .add('मौसम की स्थिति खेती की गतिविधियों के लिए अनुकूल है।');
    }

    return recommendations;
  }

  // Get irrigation recommendations based on weather using Google Weather API
  Future<Map<String, dynamic>> getIrrigationRecommendation(
    WeatherData weather,
    String soilType,
    String cropType,
  ) async {
    try {
      return await _googleWeatherService.getIrrigationRecommendation(
          weather, soilType, cropType);
    } catch (e) {
      print('Error fetching irrigation recommendations: $e');
      // Fallback to mock recommendations
      return _getMockIrrigationRecommendation(weather, soilType, cropType);
    }
  }

  // Mock irrigation recommendations fallback
  Map<String, dynamic> _getMockIrrigationRecommendation(
    WeatherData weather,
    String soilType,
    String cropType,
  ) {
    double irrigationFrequency = 3; // days
    String intensity = 'Medium';
    String timing = 'Early Morning';

    // Adjust based on weather conditions
    if (weather.temperature > 35) {
      irrigationFrequency = 2;
      intensity = 'High';
    } else if (weather.temperature < 20) {
      irrigationFrequency = 5;
      intensity = 'Low';
    }

    if (weather.humidity > 70) {
      irrigationFrequency += 1;
    }

    if (weather.rainfall > 5) {
      irrigationFrequency += 2;
      intensity = 'Very Low';
    }

    return {
      'frequency': irrigationFrequency,
      'intensity': intensity,
      'timing': timing,
      'recommendation':
          'Based on current weather conditions, irrigate every ${irrigationFrequency.toInt()} days with $intensity intensity during $timing.',
      'recommendationHindi':
          'वर्तमान मौसम स्थितियों के आधार पर, हर ${irrigationFrequency.toInt()} दिन $timing के दौरान $intensity तीव्रता के साथ सिंचाई करें।',
    };
  }

  // Get seasonal crop suggestions based on weather patterns
  Future<List<Map<String, dynamic>>> getSeasonalCropSuggestions(
    String location,
    String season,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final suggestions = <Map<String, dynamic>>[];

    switch (season.toLowerCase()) {
      case 'kharif':
        suggestions.addAll([
          {
            'crop': 'Rice',
            'cropHindi': 'चावल',
            'suitability': 90,
            'reason': 'Monsoon season ideal for rice cultivation',
            'reasonHindi': 'मानसून का मौसम चावल की खेती के लिए आदर्श है',
          },
          {
            'crop': 'Cotton',
            'cropHindi': 'कपास',
            'suitability': 85,
            'reason': 'High temperature and humidity favorable',
            'reasonHindi': 'उच्च तापमान और आर्द्रता अनुकूल है',
          },
          {
            'crop': 'Maize',
            'cropHindi': 'मक्का',
            'suitability': 80,
            'reason': 'Good rainfall supports maize growth',
            'reasonHindi': 'अच्छी बारिश मक्के की वृद्धि का समर्थन करती है',
          },
        ]);
        break;

      case 'rabi':
        suggestions.addAll([
          {
            'crop': 'Wheat',
            'cropHindi': 'गेहूं',
            'suitability': 95,
            'reason': 'Cool winter weather perfect for wheat',
            'reasonHindi': 'ठंडा सर्दी का मौसम गेहूं के लिए एकदम सही है',
          },
          {
            'crop': 'Barley',
            'cropHindi': 'जौ',
            'suitability': 85,
            'reason': 'Tolerates cold and requires less water',
            'reasonHindi': 'ठंड को सहन करता है और कम पानी चाहिए',
          },
          {
            'crop': 'Mustard',
            'cropHindi': 'सरसों',
            'suitability': 80,
            'reason': 'Cool season crop with good market value',
            'reasonHindi': 'अच्छे बाजार मूल्य के साथ ठंडे मौसम की फसल',
          },
        ]);
        break;

      case 'zaid':
        suggestions.addAll([
          {
            'crop': 'Watermelon',
            'cropHindi': 'तरबूज',
            'suitability': 90,
            'reason': 'Hot summer weather ideal for melons',
            'reasonHindi': 'गर्म गर्मी का मौसम तरबूज के लिए आदर्श है',
          },
          {
            'crop': 'Fodder Crops',
            'cropHindi': 'चारा फसलें',
            'suitability': 85,
            'reason': 'Quick growing summer fodder',
            'reasonHindi': 'तेजी से बढ़ने वाला गर्मियों का चारा',
          },
        ]);
        break;

      default:
        suggestions.addAll([
          {
            'crop': 'Mixed Vegetables',
            'cropHindi': 'मिश्रित सब्जियां',
            'suitability': 75,
            'reason': 'Year-round vegetable cultivation possible',
            'reasonHindi': 'साल भर सब्जी की खेती संभव है',
          },
        ]);
    }

    return suggestions;
  }
}
