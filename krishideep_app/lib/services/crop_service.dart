import 'dart:math' as math;
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/crop.dart';
import '../models/crop_advice.dart';
import '../models/crop_recommendation.dart';
import '../models/disease_detection.dart';
import '../models/soil_data.dart';
import 'soil_data_service.dart';

class CropService {
  // Real API-based crop data only

  // Get crop recommendation using real API
  Future<CropRecommendation> getCropRecommendationFromAPI(
    CropAdviceRequest request,
  ) async {
    try {
      // Convert request to SoilData
      final soilData = request.toSoilData();

      // Validate soil data
      if (!SoilDataService.validateSoilData(soilData)) {
        throw Exception('Invalid soil data provided');
      }

      // Get crop prediction from API
      final prediction = await SoilDataService.getCropPrediction(soilData);

      if (prediction != null) {
        // Create crop object from prediction
        final recommendedCrop = Crop(
          id: 'api_${DateTime.now().millisecondsSinceEpoch}',
          name: prediction.cropName,
          nameHindi: _getHindiName(prediction.cropName),
          description: prediction.description ??
              'AI-recommended crop based on soil analysis',
          expectedYield: _estimateYield(prediction.cropName, soilData),
          profitMargin: _estimateProfitMargin(prediction.cropName),
          sustainabilityScore: _calculateSustainabilityScore(soilData),
          suitableConditions:
              _getSuitableConditions(prediction.cropName, soilData),
        );

        // Get soil recommendations
        final soilRecommendations =
            SoilDataService.getSoilRecommendations(soilData);

        return CropRecommendation(
          recommendedCrops: [recommendedCrop],
          recommendation:
              _generateAPIBasedRecommendation(prediction, soilData, request),
          confidenceLevel: _getConfidenceLevel(prediction.confidence),
          timestamp: DateTime.now(),
          analysisData: {
            'soilPH': soilData.ph,
            'soilMoisture': soilData.soilMoistureAvg,
            'temperature': soilData.temperature,
            'humidity': soilData.humidity,
            'rainfall': soilData.rainfall,
            'nitrogen': soilData.n,
            'phosphorus': soilData.p,
            'potassium': soilData.k,
            'location': request.location,
            'confidence': prediction.confidence,
            'soilRecommendations': soilRecommendations,
          },
        );
      } else {
        // Fallback to local recommendation if API fails
        return await getCropRecommendation(request);
      }
    } catch (e) {
      print('API-based recommendation failed: $e');
      // Fallback to local recommendation
      return await getCropRecommendation(request);
    }
  }

  // Real API-based crop recommendation only
  Future<CropRecommendation> getCropRecommendation(
    CropAdviceRequest request,
  ) async {
    // Use only real API-based recommendations
    return await getCropRecommendationFromAPI(request);
  }

  // Real API-based methods only

  // Real disease detection using ML API
  Future<DiseaseDetectionResult> detectDisease(File imageFile) async {
    print('🔍 DEBUG: CropService.detectDisease() called');
    print('🔍 DEBUG: Image file path: ${imageFile.path}');
    print('🔍 DEBUG: Image file exists: ${await imageFile.exists()}');
    print('🔍 DEBUG: Image file size: ${await imageFile.length()} bytes');

    try {
      print('🔍 DEBUG: Making API call to disease detection service...');

      // Create multipart request with correct endpoint
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backend-krisi-ml-crophealth.onrender.com/predict'),
      );

      // Add image file with 'file' as key (as specified by user)
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      print('🔍 DEBUG: Sending request to API with form data...');
      print(
          '🔍 DEBUG: API endpoint: https://backend-krisi-ml-crophealth.onrender.com/predict');
      print('🔍 DEBUG: Form field key: file');
      print('🔍 DEBUG: File path: ${imageFile.path}');
      print('🔍 DEBUG: Request method: POST');
      print('🔍 DEBUG: Content-Type: multipart/form-data');
      print('🔍 DEBUG: File size: ${await imageFile.length()} bytes');
      print('🔍 DEBUG: File exists: ${await imageFile.exists()}');

      var response = await request.send().timeout(
        const Duration(seconds: 60), // Increased timeout for ML processing
        onTimeout: () {
          throw TimeoutException('API request timed out after 60 seconds',
              const Duration(seconds: 60));
        },
      );

      print('🔍 DEBUG: API response status: ${response.statusCode}');
      print('🔍 DEBUG: API response headers: ${response.headers}');

      if (response.statusCode == 200) {
        print('🔍 DEBUG: API call successful, parsing response...');
        var responseBody = await response.stream.bytesToString();
        print('🔍 DEBUG: Raw API response: $responseBody');

        var jsonResponse = json.decode(responseBody);
        print('🔍 DEBUG: Parsed JSON response: $jsonResponse');

        // Parse the API response with proper error handling
        // Based on the working HTML code, the API returns 'prediction' field
        String prediction = jsonResponse['prediction'] ??
            jsonResponse['disease_name'] ??
            jsonResponse['diseaseName'] ??
            'Unknown Disease';

        return DiseaseDetectionResult(
          diseaseName: prediction,
          diseaseNameHindi: _getHindiName(prediction),
          description:
              jsonResponse['description'] ?? 'AI-detected disease: $prediction',
          confidence: (jsonResponse['confidence'] ?? 85.0)
              .toDouble(), // Default confidence if not provided
          severity: jsonResponse['severity'] ??
              _getSeverityFromPrediction(prediction),
          treatments: List<String>.from(
              jsonResponse['treatments'] ?? _getDefaultTreatments(prediction)),
          prevention: List<String>.from(
              jsonResponse['prevention'] ?? _getDefaultPrevention(prediction)),
        );
      } else {
        print('🔍 DEBUG: API call failed with status: ${response.statusCode}');
        var errorBody = await response.stream.bytesToString();
        print('🔍 DEBUG: API error response: $errorBody');
        throw Exception(
            'API call failed with status: ${response.statusCode}. Error: $errorBody');
      }
    } catch (e) {
      print('🔍 DEBUG: API call failed with error: $e');
      print('🔍 DEBUG: Error type: ${e.runtimeType}');
      print('🔍 DEBUG: API Error Details: $e');

      // Create a result that shows the API error instead of mock data
      return DiseaseDetectionResult(
        diseaseName: 'API Error',
        diseaseNameHindi: 'API त्रुटि',
        description: 'API call failed: $e',
        confidence: 0.0,
        severity: 'Error',
        treatments: [
          'Check internet connection',
          'Try again later',
          'Contact support'
        ],
        prevention: ['Ensure stable internet', 'Check API status'],
      );
    }
  }

  // No mock data - only real API results

  // Real API-based crop data only

  // Helper methods for API-based recommendations
  String _getHindiName(String englishName) {
    final hindiNames = {
      'Rice': 'चावल',
      'Wheat': 'गेहूं',
      'Maize': 'मक्का',
      'Sugarcane': 'गन्ना',
      'Cotton': 'कपास',
      'Potato': 'आलू',
      'Tomato': 'टमाटर',
      'Onion': 'प्याज',
      'Chili': 'मिर्च',
      'Brinjal': 'बैंगन',
      'Cabbage': 'पत्ता गोभी',
      'Cauliflower': 'फूल गोभी',
      'Carrot': 'गाजर',
      'Radish': 'मूली',
      'Spinach': 'पालक',
      'Coriander': 'धनिया',
      'Mint': 'पुदीना',
      'Basil': 'तुलसी',
      'Ginger': 'अदरक',
      'Turmeric': 'हल्दी',
    };
    return hindiNames[englishName] ?? englishName;
  }

  double _estimateYield(String cropName, SoilData soilData) {
    final baseYields = {
      'Rice': 2500.0,
      'Wheat': 1800.0,
      'Maize': 3200.0,
      'Sugarcane': 45000.0,
      'Cotton': 800.0,
      'Potato': 15000.0,
      'Tomato': 20000.0,
      'Onion': 12000.0,
    };

    double baseYield = baseYields[cropName] ?? 1000.0;

    // Adjust yield based on soil conditions
    double multiplier = 1.0;

    // pH adjustment
    if (soilData.ph >= 6.0 && soilData.ph <= 7.5) {
      multiplier += 0.2;
    } else if (soilData.ph < 5.0 || soilData.ph > 8.5) {
      multiplier -= 0.3;
    }

    // Nutrient adjustment
    if (soilData.n >= 30 && soilData.n <= 100) multiplier += 0.1;
    if (soilData.p >= 20 && soilData.p <= 80) multiplier += 0.1;
    if (soilData.k >= 15 && soilData.k <= 60) multiplier += 0.1;

    // Temperature adjustment
    if (soilData.temperature >= 20 && soilData.temperature <= 30) {
      multiplier += 0.15;
    } else if (soilData.temperature < 10 || soilData.temperature > 40) {
      multiplier -= 0.2;
    }

    return (baseYield * multiplier).roundToDouble();
  }

  double _estimateProfitMargin(String cropName) {
    final profitMargins = {
      'Rice': 25.5,
      'Wheat': 30.2,
      'Maize': 35.8,
      'Sugarcane': 28.5,
      'Cotton': 32.1,
      'Potato': 40.0,
      'Tomato': 45.0,
      'Onion': 35.0,
    };
    return profitMargins[cropName] ?? 30.0;
  }

  double _calculateSustainabilityScore(SoilData soilData) {
    double score = 5.0; // Base score

    // pH sustainability
    if (soilData.ph >= 6.0 && soilData.ph <= 7.5) score += 1.0;

    // Nutrient balance
    if (soilData.n >= 30 && soilData.n <= 100) score += 0.5;
    if (soilData.p >= 20 && soilData.p <= 80) score += 0.5;
    if (soilData.k >= 15 && soilData.k <= 60) score += 0.5;

    // Environmental factors
    if (soilData.temperature >= 15 && soilData.temperature <= 35) score += 0.5;
    if (soilData.humidity >= 40 && soilData.humidity <= 80) score += 0.5;
    if (soilData.rainfall >= 50 && soilData.rainfall <= 200) score += 0.5;

    return math.min(score, 10.0);
  }

  List<String> _getSuitableConditions(String cropName, SoilData soilData) {
    List<String> conditions = [];

    // pH conditions
    if (soilData.ph >= 6.0 && soilData.ph <= 7.5) {
      conditions.add('Optimal pH (${soilData.ph.toStringAsFixed(1)})');
    } else {
      conditions
          .add('pH adjustment needed (${soilData.ph.toStringAsFixed(1)})');
    }

    // Temperature conditions
    if (soilData.temperature >= 20 && soilData.temperature <= 30) {
      conditions.add(
          'Ideal temperature (${soilData.temperature.toStringAsFixed(1)}°C)');
    } else {
      conditions.add(
          'Temperature monitoring needed (${soilData.temperature.toStringAsFixed(1)}°C)');
    }

    // Moisture conditions
    if (soilData.soilMoistureAvg >= 30 && soilData.soilMoistureAvg <= 70) {
      conditions.add(
          'Good soil moisture (${soilData.soilMoistureAvg.toStringAsFixed(1)}%)');
    } else {
      conditions.add(
          'Moisture management needed (${soilData.soilMoistureAvg.toStringAsFixed(1)}%)');
    }

    // Nutrient conditions
    if (soilData.n >= 30 && soilData.n <= 100) {
      conditions.add('Adequate nitrogen (${soilData.n.toStringAsFixed(1)})');
    } else {
      conditions
          .add('Nitrogen adjustment needed (${soilData.n.toStringAsFixed(1)})');
    }

    return conditions;
  }

  String _getConfidenceLevel(double confidence) {
    if (confidence >= 80) return 'High';
    if (confidence >= 60) return 'Medium';
    return 'Low';
  }

  String _generateAPIBasedRecommendation(
      CropPrediction prediction, SoilData soilData, CropAdviceRequest request) {
    return 'Based on comprehensive soil analysis using AI prediction model, '
        '${prediction.cropName} is recommended with ${prediction.confidence.toStringAsFixed(1)}% confidence. '
        'Your soil conditions (pH: ${soilData.ph.toStringAsFixed(1)}, '
        'Temperature: ${soilData.temperature.toStringAsFixed(1)}°C, '
        'Moisture: ${soilData.soilMoistureAvg.toStringAsFixed(1)}%) '
        'are suitable for this crop. '
        'Consider the soil recommendations for optimal yield.';
  }

  // Helper methods for disease detection based on prediction
  String _getSeverityFromPrediction(String prediction) {
    final severeDiseases = ['blight', 'wilt', 'rot', 'canker', 'rust'];
    final moderateDiseases = ['spot', 'mildew', 'mosaic', 'yellow'];

    String lowerPrediction = prediction.toLowerCase();

    for (String disease in severeDiseases) {
      if (lowerPrediction.contains(disease)) return 'Severe';
    }

    for (String disease in moderateDiseases) {
      if (lowerPrediction.contains(disease)) return 'Moderate';
    }

    if (lowerPrediction.contains('healthy') ||
        lowerPrediction.contains('normal')) {
      return 'None';
    }

    return 'Mild';
  }

  List<String> _getDefaultTreatments(String prediction) {
    String lowerPrediction = prediction.toLowerCase();

    if (lowerPrediction.contains('healthy') ||
        lowerPrediction.contains('normal')) {
      return [
        'Continue regular care',
        'Maintain proper nutrition',
        'Monitor regularly',
      ];
    }

    if (lowerPrediction.contains('blight')) {
      return [
        'Apply copper-based fungicide',
        'Remove infected plant parts',
        'Improve air circulation',
        'Avoid overhead watering',
      ];
    }

    if (lowerPrediction.contains('mildew')) {
      return [
        'Apply sulfur-based fungicide',
        'Use neem oil spray',
        'Improve air circulation',
        'Reduce humidity',
      ];
    }

    if (lowerPrediction.contains('spot')) {
      return [
        'Apply fungicide spray',
        'Remove affected leaves',
        'Improve drainage',
        'Avoid wetting leaves',
      ];
    }

    // Default treatments for unknown diseases
    return [
      'Consult with agricultural expert',
      'Apply appropriate fungicide',
      'Remove infected parts',
      'Improve plant care',
    ];
  }

  List<String> _getDefaultPrevention(String prediction) {
    String lowerPrediction = prediction.toLowerCase();

    if (lowerPrediction.contains('healthy') ||
        lowerPrediction.contains('normal')) {
      return [
        'Continue good practices',
        'Regular monitoring',
        'Proper nutrition',
        'Maintain hygiene',
      ];
    }

    return [
      'Use disease-resistant varieties',
      'Practice crop rotation',
      'Maintain proper spacing',
      'Avoid overhead watering',
      'Regular field inspection',
      'Good drainage',
      'Balanced fertilization',
    ];
  }
}
