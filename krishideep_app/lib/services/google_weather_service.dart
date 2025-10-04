import 'dart:math' as math;
import '../models/weather.dart';

class GoogleWeatherService {
  // Using realistic weather simulation since external APIs require setup
  // Use a consistent seed based on current date and hour to ensure same data for same time period
  math.Random get _random {
    final now = DateTime.now();
    final seed =
        now.year * 1000000 + now.month * 10000 + now.day * 100 + now.hour;
    return math.Random(seed);
  }

  // Get current weather conditions
  Future<WeatherData> getCurrentWeather(
      double latitude, double longitude) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Generate realistic weather data based on location and time
      return _generateRealisticWeatherData(latitude, longitude);
    } catch (e) {
      print('Error generating weather data: $e');
      return _getMockWeatherData();
    }
  }

  // Get weather forecast
  Future<List<WeatherForecast>> getWeatherForecast(
      double latitude, double longitude) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));

      // Generate realistic forecast data
      return _generateRealisticForecast(latitude, longitude);
    } catch (e) {
      print('Error generating forecast: $e');
      return _getMockForecast();
    }
  }

  // Mock data fallback
  WeatherData _getMockWeatherData() {
    return WeatherData(
      location: 'Delhi',
      temperature: 28.0,
      humidity: 65.0,
      condition: 'Partly Cloudy',
      conditionHindi: 'आंशिक रूप से बादल',
      rainfall: 0.0,
      windSpeed: 12.0,
      timestamp: DateTime.now(),
      forecast: _getMockForecast(),
    );
  }

  List<WeatherForecast> _getMockForecast() {
    final now = DateTime.now();
    return List.generate(7, (index) {
      final date = now.add(Duration(days: index + 1));
      return WeatherForecast(
        date: date,
        maxTemp: 25.0 + (index * 2),
        minTemp: 15.0 + (index * 1),
        condition: ['Sunny', 'Partly Cloudy', 'Cloudy', 'Rainy'][index % 4],
        conditionHindi: [
          'धूप',
          'आंशिक रूप से बादल',
          'बादल',
          'बारिश'
        ][index % 4],
        rainProbability: (index * 10).toDouble(),
      );
    });
  }

  // Get weather alerts (Google Weather API doesn't provide alerts, so we'll use mock data)
  Future<List<WeatherAlert>> getWeatherAlerts(String location) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock alerts for demonstration
    return [
      WeatherAlert(
        id: '1',
        title: 'Weather Advisory',
        titleHindi: 'मौसम सलाह',
        description: 'Monitor weather conditions for agricultural activities.',
        descriptionHindi:
            'कृषि गतिविधियों के लिए मौसम की स्थिति की निगरानी करें।',
        severity: 'medium',
        alertTime: DateTime.now(),
        expiryTime: DateTime.now().add(const Duration(hours: 24)),
      ),
    ];
  }

  // Get weather recommendations based on current conditions
  Future<List<String>> getWeatherRecommendations(
    WeatherData weather,
    String cropType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));

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

    // Crop-specific recommendations
    if (cropType.toLowerCase().contains('rice')) {
      if (weather.humidity < 60) {
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

  // Get irrigation recommendations based on weather
  Future<Map<String, dynamic>> getIrrigationRecommendation(
    WeatherData weather,
    String soilType,
    String cropType,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));

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

  // Generate realistic weather data based on location and time
  WeatherData _generateRealisticWeatherData(double latitude, double longitude) {
    final now = DateTime.now();
    final hour = now.hour;
    final month = now.month;

    // Base temperature varies by season and time of day
    double baseTemp = 25.0;

    // Seasonal adjustments
    if (month >= 3 && month <= 5) {
      // Spring
      baseTemp = 28.0;
    } else if (month >= 6 && month <= 8) {
      // Summer
      baseTemp = 32.0;
    } else if (month >= 9 && month <= 11) {
      // Autumn
      baseTemp = 26.0;
    } else {
      // Winter
      baseTemp = 20.0;
    }

    // Daily temperature variation
    if (hour >= 6 && hour <= 18) {
      // Daytime
      baseTemp += 5.0;
    } else {
      // Nighttime
      baseTemp -= 3.0;
    }

    // Add some randomness
    final temperature = baseTemp + (_random.nextDouble() - 0.5) * 6;
    final humidity = 50.0 + _random.nextDouble() * 40; // 50-90%
    final windSpeed = 5.0 + _random.nextDouble() * 15; // 5-20 km/h

    // Determine weather condition based on humidity and temperature
    String condition;
    if (humidity > 80) {
      condition = _random.nextBool() ? 'Rain' : 'Cloudy';
    } else if (humidity > 60) {
      condition = 'Partly Cloudy';
    } else {
      condition = 'Clear';
    }

    // Rainfall based on condition
    double rainfall = 0.0;
    if (condition == 'Rain') {
      rainfall = 5.0 + _random.nextDouble() * 20; // 5-25mm
    }

    return WeatherData(
      location: _getLocationName(latitude, longitude),
      temperature: temperature,
      humidity: humidity,
      condition: condition,
      conditionHindi: _getHindiCondition(condition),
      rainfall: rainfall,
      windSpeed: windSpeed,
      timestamp: now,
      forecast: [],
    );
  }

  // Generate realistic forecast data
  List<WeatherForecast> _generateRealisticForecast(
      double latitude, double longitude) {
    final forecasts = <WeatherForecast>[];
    final now = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      final month = date.month;

      // Create a consistent random seed for each forecast day
      final daySeed = date.year * 10000 + date.month * 100 + date.day;
      final dayRandom = math.Random(daySeed);

      // Base temperature for the season
      double baseMaxTemp = 25.0;
      if (month >= 3 && month <= 5) {
        // Spring
        baseMaxTemp = 30.0;
      } else if (month >= 6 && month <= 8) {
        // Summer
        baseMaxTemp = 35.0;
      } else if (month >= 9 && month <= 11) {
        // Autumn
        baseMaxTemp = 28.0;
      } else {
        // Winter
        baseMaxTemp = 22.0;
      }

      final maxTemp = baseMaxTemp + (dayRandom.nextDouble() - 0.5) * 8;
      final minTemp = maxTemp - (8 + dayRandom.nextDouble() * 7);

      // Weather conditions
      final conditions = ['Clear', 'Partly Cloudy', 'Cloudy', 'Rain'];
      final condition = conditions[dayRandom.nextInt(conditions.length)];

      forecasts.add(WeatherForecast(
        date: date,
        maxTemp: maxTemp,
        minTemp: minTemp,
        condition: condition,
        conditionHindi: _getHindiCondition(condition),
        rainProbability: condition == 'Rain'
            ? 80.0 + dayRandom.nextDouble() * 20
            : dayRandom.nextDouble() * 30,
      ));
    }

    return forecasts;
  }

  // Get location name based on coordinates
  String _getLocationName(double latitude, double longitude) {
    // Simple location mapping for common Indian cities
    if (latitude >= 28.0 &&
        latitude <= 29.0 &&
        longitude >= 77.0 &&
        longitude <= 78.0) {
      return 'Delhi';
    } else if (latitude >= 19.0 &&
        latitude <= 20.0 &&
        longitude >= 72.0 &&
        longitude <= 73.0) {
      return 'Mumbai';
    } else if (latitude >= 12.0 &&
        latitude <= 13.0 &&
        longitude >= 77.0 &&
        longitude <= 78.0) {
      return 'Bangalore';
    } else if (latitude >= 22.0 &&
        latitude <= 23.0 &&
        longitude >= 88.0 &&
        longitude <= 89.0) {
      return 'Kolkata';
    } else if (latitude >= 13.0 &&
        latitude <= 14.0 &&
        longitude >= 80.0 &&
        longitude <= 81.0) {
      return 'Chennai';
    } else {
      return 'Lat: ${latitude.toStringAsFixed(2)}, Lng: ${longitude.toStringAsFixed(2)}';
    }
  }

  // Get Hindi translation for weather conditions
  String _getHindiCondition(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return 'साफ';
      case 'partly cloudy':
      case 'partly_cloudy':
        return 'आंशिक रूप से बादल';
      case 'cloudy':
      case 'overcast':
        return 'बादल';
      case 'rain':
      case 'rainy':
        return 'बारिश';
      case 'thunderstorm':
      case 'storm':
        return 'तूफान';
      case 'snow':
      case 'snowy':
        return 'बर्फ';
      case 'fog':
      case 'foggy':
        return 'कोहरा';
      default:
        return 'साफ';
    }
  }
}
