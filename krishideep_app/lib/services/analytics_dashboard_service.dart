import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/analytics_dashboard.dart';
import '../services/iot_sensor_service.dart';
import '../services/weather_service.dart';
import '../services/crop_detection_service.dart';

class AnalyticsDashboardService {
  // Mock database
  static final List<YieldPrediction> _yieldPredictions = [];
  static final List<PerformanceReport> _performanceReports = [];
  static final List<EnvironmentalTracking> _environmentalRecords = [];
  static final List<AnalyticsDashboardSummary> _dashboardSummaries = [];

  // Dependencies
  final IoTSensorService _iotService = IoTSensorService();
  final WeatherService _weatherService = WeatherService();
  final CropDetectionService _cropDetectionService = CropDetectionService();

  // Backend API URL
  static const String _backendUrl = 'https://backend-krisi.onrender.com';

  // Fetch real sensor data from backend
  Future<Map<String, dynamic>?> _fetchRealSensorData() async {
    try {
      final response = await http.get(
        Uri.parse('$_backendUrl/soildata/latest'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Real sensor data fetched for analytics: $data');
        return data;
      } else {
        print('❌ Failed to fetch sensor data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching sensor data: $e');
      return null;
    }
  }

  // Yield Prediction Services
  Future<YieldPrediction> generateYieldPrediction(
    String farmerId,
    String fieldId,
    String cropType,
    String cropTypeHindi,
    String season,
    double farmSize,
    Map<String, dynamic>? inputData,
  ) async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate AI processing

    final random = math.Random();
    final predictionId = 'YIELD_PRED_${DateTime.now().millisecondsSinceEpoch}';

    // Fetch real sensor data from backend
    final realSensorData = await _fetchRealSensorData();

    // Get supporting data
    final weatherData = await _weatherService.getCurrentWeather('Delhi');
    final soilData = await _iotService.getLatestSoilData('SENSOR_001');

    // AI-based yield prediction algorithm
    final baseYield = _getStandardYield(cropType);

    // Use real sensor data for calculations if available
    double weatherFactor = 1.0;
    double soilFactor = 1.0;

    if (realSensorData != null) {
      // Use real sensor data for weather and soil factors
      final temperature =
          realSensorData['temperature']?.toDouble() ?? weatherData.temperature;
      final humidity =
          realSensorData['humidity']?.toDouble() ?? weatherData.humidity;
      final ph = realSensorData['ph']?.toDouble() ?? 6.5;
      final soilMoisture =
          realSensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
      final nitrogen = realSensorData['N']?.toDouble() ?? 50.0;

      weatherFactor = _calculateWeatherFactor(temperature, humidity);
      soilFactor = _calculateSoilFactor(soilMoisture, ph, nitrogen);
    } else {
      // Fallback to mock data
      weatherFactor = _calculateWeatherFactor(
          weatherData.temperature, weatherData.humidity);
      if (soilData != null) {
        soilFactor = _calculateSoilFactor(
            soilData.moistureLevel, soilData.phLevel, soilData.nitrogen);
      }
    }

    // Management factor (0.9 - 1.1) - based on farmer practices
    final managementFactor = 0.95 + random.nextDouble() * 0.15;

    // Market conditions factor (0.95 - 1.05)
    final marketFactor = 0.975 + random.nextDouble() * 0.075;

    final predictedYield = baseYield *
        weatherFactor *
        soilFactor *
        managementFactor *
        marketFactor;
    final confidence = 75 + random.nextDouble() * 20; // 75-95%

    // Generate forecast points
    final forecastPoints = _generateForecastPoints(cropType, predictedYield);

    final prediction = YieldPrediction(
      id: predictionId,
      farmerId: farmerId,
      fieldId: fieldId,
      cropType: cropType,
      cropTypeHindi: cropTypeHindi,
      season: season,
      predictionDate: DateTime.now(),
      predictedYieldPerAcre: predictedYield,
      totalPredictedYield: predictedYield * farmSize,
      farmSize: farmSize,
      confidenceLevel: confidence,
      accuracyLevel:
          confidence > 85 ? 'high' : (confidence > 70 ? 'medium' : 'low'),
      factorsInfluencing: {
        'weather': weatherFactor * 100,
        'soil': soilFactor * 100,
        'management': managementFactor * 100,
        'market': marketFactor * 100,
      },
      recommendations: _generateYieldRecommendations(
          weatherFactor, soilFactor, managementFactor),
      recommendationsHindi: _generateYieldRecommendationsHindi(
          weatherFactor, soilFactor, managementFactor),
      historicalComparison: {
        'lastSeason': baseYield * (0.85 + random.nextDouble() * 0.3),
        'averageLast3Years': baseYield * (0.9 + random.nextDouble() * 0.2),
        'bestYieldEver': baseYield * (1.1 + random.nextDouble() * 0.2),
      },
      harvestPredictionDate: _calculateHarvestDate(DateTime.now(), cropType),
      scenarioAnalysis: {
        'best_case': predictedYield * 1.2,
        'expected': predictedYield,
        'worst_case': predictedYield * 0.8,
      },
      forecastPoints: forecastPoints,
      riskFactors: {
        'weatherRisk': random.nextDouble() * 30 + 10,
        'pestRisk': random.nextDouble() * 20 + 5,
        'marketRisk': random.nextDouble() * 25 + 10,
        'inputCostRisk': random.nextDouble() * 15 + 5,
      },
    );

    _yieldPredictions.add(prediction);
    return prediction;
  }

  Future<List<YieldPrediction>> getYieldPredictions(String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    return _yieldPredictions.where((pred) => pred.farmerId == farmerId).toList()
      ..sort((a, b) => b.predictionDate.compareTo(a.predictionDate));
  }

  // Performance Report Services
  Future<PerformanceReport> generatePerformanceReport(
    String farmerId,
    String reportType,
    DateTime startDate,
    DateTime endDate,
    Map<String, dynamic>? customParameters,
  ) async {
    await Future.delayed(
        const Duration(seconds: 4)); // Simulate comprehensive analysis

    final random = math.Random();
    final reportId = 'PERF_REPORT_${DateTime.now().millisecondsSinceEpoch}';

    // Generate crop performance data
    final cropPerformances =
        await _generateCropPerformanceData(farmerId, startDate, endDate);

    // Generate financial performance data
    final financialData = _generateFinancialPerformanceData(random);

    // Generate environmental performance data
    final environmentalData =
        await _generateEnvironmentalPerformanceData(farmerId);

    // Generate operational performance data
    final operationalData = _generateOperationalPerformanceData(random);

    // Calculate overall performance score
    final overallScore = _calculateOverallPerformanceScore(
        financialData, environmentalData, operationalData, cropPerformances);

    final report = PerformanceReport(
      id: reportId,
      farmerId: farmerId,
      reportType: reportType,
      reportPeriodStart: startDate,
      reportPeriodEnd: endDate,
      generatedAt: DateTime.now(),
      cropPerformances: cropPerformances,
      financialData: financialData,
      environmentalData: environmentalData,
      operationalData: operationalData,
      overallPerformanceScore: overallScore,
      performanceGrade: _calculatePerformanceGrade(overallScore),
      achievements:
          _generateAchievements(overallScore, financialData, environmentalData),
      achievementsHindi: _generateAchievementsHindi(
          overallScore, financialData, environmentalData),
      improvements: _generateImprovements(overallScore, cropPerformances),
      improvementsHindi:
          _generateImprovementsHindi(overallScore, cropPerformances),
      benchmarkComparison:
          _generateBenchmarkComparison(financialData, environmentalData),
      recommendations:
          await _generatePerformanceRecommendations(farmerId, overallScore),
      trendAnalysis: _generateTrendAnalysis(reportType),
    );

    _performanceReports.add(report);
    return report;
  }

  Future<List<PerformanceReport>> getPerformanceReports(String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _performanceReports
        .where((report) => report.farmerId == farmerId)
        .toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
  }

  // Environmental Tracking Services
  Future<EnvironmentalTracking> generateEnvironmentalTracking(
    String farmerId,
    String fieldId,
    Map<String, dynamic>? sensorData,
  ) async {
    await Future.delayed(const Duration(seconds: 2));

    final random = math.Random();
    final trackingId = 'ENV_TRACK_${DateTime.now().millisecondsSinceEpoch}';

    // Get current weather data
    final weatherData = await _weatherService.getCurrentWeather('Delhi');

    // Get soil data
    final soilData = await _iotService.getLatestSoilData('SENSOR_001');

    final tracking = EnvironmentalTracking(
      id: trackingId,
      farmerId: farmerId,
      fieldId: fieldId,
      recordDate: DateTime.now(),
      weatherData: WeatherImpactData(
        temperature: weatherData.temperature,
        humidity: weatherData.humidity,
        rainfall: random.nextDouble() * 10,
        windSpeed: random.nextDouble() * 20 + 5,
        solarRadiation: random.nextDouble() * 25 + 15,
        growingDegreeDays: random.nextInt(30) + 10,
        evapotranspiration: random.nextDouble() * 8 + 2,
        weatherStress: _calculateWeatherStress(weatherData.temperature),
        weatherEvents: _generateWeatherEvents(random),
      ),
      soilData: SoilEnvironmentData(
        organicCarbon:
            soilData?.organicMatter ?? (1.5 + random.nextDouble() * 3),
        nitrogenContent: soilData?.nitrogen ?? (20 + random.nextDouble() * 30),
        phosphorusContent:
            soilData?.phosphorus ?? (15 + random.nextDouble() * 25),
        potassiumContent:
            soilData?.potassium ?? (100 + random.nextDouble() * 100),
        microbialActivity: 60 + random.nextDouble() * 35,
        erosionRate: random.nextDouble() * 2 + 0.5,
        compactionLevel: random.nextDouble() * 50 + 25,
        biodiversityIndex: 65 + random.nextDouble() * 30,
        beneficialOrganisms: [
          'Earthworms',
          'Mycorrhizae',
          'Rhizobium',
          'Beneficial Bacteria'
        ],
      ),
      waterData: WaterManagementData(
        waterConsumption: random.nextDouble() * 5000 + 2000,
        irrigationEfficiency: 65 + random.nextDouble() * 30,
        waterWastage: random.nextDouble() * 500 + 100,
        groundwaterLevel: 10 + random.nextDouble() * 20,
        waterQualityIndex: 70 + random.nextDouble() * 25,
        runoffReduction: random.nextDouble() * 40 + 20,
        conservationMethods: [
          'Drip irrigation',
          'Mulching',
          'Rainwater harvesting'
        ],
        conservationMethodsHindi: ['ड्रिप सिंचाई', 'मल्चिंग', 'वर्षा जल संचयन'],
      ),
      airQualityData: AirQualityData(
        pm25Level: random.nextDouble() * 50 + 10,
        pm10Level: random.nextDouble() * 80 + 20,
        coLevel: random.nextDouble() * 2 + 0.5,
        no2Level: random.nextDouble() * 0.1 + 0.02,
        so2Level: random.nextDouble() * 0.05 + 0.01,
        airQualityIndex: 50 + random.nextDouble() * 100,
        airQualityStatus: _getAirQualityStatus(50 + random.nextDouble() * 100),
      ),
      biodiversityData: BiodiversityData(
        plantSpeciesCount: 15 + random.nextInt(25),
        animalSpeciesCount: 8 + random.nextInt(15),
        beneficialInsectCount: 20 + random.nextInt(30),
        ecosystemHealth: 60 + random.nextDouble() * 35,
        threatenedSpecies: random.nextBool() ? ['Local butterfly species'] : [],
        conservationEfforts: [
          'Organic farming',
          'Habitat preservation',
          'Native plant cultivation'
        ],
        conservationEffortsHindi: [
          'जैविक खेती',
          'आवास संरक्षण',
          'देशी पौधे की खेती'
        ],
      ),
      pollutionLevels: {
        'soil': random.nextDouble() * 30 + 10,
        'water': random.nextDouble() * 25 + 5,
        'air': random.nextDouble() * 40 + 20,
        'noise': random.nextDouble() * 35 + 15,
      },
      overallEnvironmentalScore: 65 + random.nextDouble() * 30,
      environmentalAlerts: _generateEnvironmentalAlerts(random),
      environmentalAlertsHindi: _generateEnvironmentalAlertsHindi(random),
      sustainabilityMetrics: {
        'carbonSequestration': random.nextDouble() * 5 + 2,
        'biodiversityImprovement': random.nextDouble() * 20 + 10,
        'soilHealthTrend': random.nextDouble() * 15 + 5,
        'waterConservation': random.nextDouble() * 30 + 20,
      },
      recommendations: _generateEnvironmentalRecommendations(random),
    );

    _environmentalRecords.add(tracking);
    return tracking;
  }

  // Dashboard Summary Services
  Future<AnalyticsDashboardSummary> getDashboardSummary(String farmerId) async {
    await Future.delayed(const Duration(seconds: 2));

    // Fetch real sensor data from backend
    final realSensorData = await _fetchRealSensorData();

    // Get latest data from different services
    final latestYieldPrediction =
        _yieldPredictions.where((p) => p.farmerId == farmerId).isNotEmpty
            ? _yieldPredictions.where((p) => p.farmerId == farmerId).last
            : null;

    final latestPerformanceReport =
        _performanceReports.where((r) => r.farmerId == farmerId).isNotEmpty
            ? _performanceReports.where((r) => r.farmerId == farmerId).last
            : null;

    final latestEnvironmentalTracking =
        _environmentalRecords.where((e) => e.farmerId == farmerId).isNotEmpty
            ? _environmentalRecords.where((e) => e.farmerId == farmerId).last
            : null;

    // Calculate farm health score based on real sensor data
    final farmHealth = _calculateFarmHealthFromSensorData(realSensorData);

    // Calculate metrics based on real sensor data
    final expectedYield =
        _calculateYieldFromSensorData(realSensorData, latestYieldPrediction);
    final environmentalScore = _calculateEnvironmentalScoreFromSensorData(
        realSensorData, latestEnvironmentalTracking);
    final soilHealth = _calculateSoilHealthFromSensorData(realSensorData);

    // Calculate all metrics based on real sensor data
    final yieldConfidence =
        _calculateYieldConfidenceFromSensorData(realSensorData);
    final overallPerformance =
        _calculateOverallPerformanceFromSensorData(realSensorData);
    final profitMargin = _calculateProfitMarginFromSensorData(realSensorData);
    final farmSize = 2.5; // Default farm size
    final activeCrops = 3; // Default active crops

    final summary = AnalyticsDashboardSummary(
      farmerId: farmerId,
      lastUpdated: DateTime.now(),
      keyMetrics: {
        'expectedYield': expectedYield,
        'yieldConfidence': yieldConfidence,
        'overallPerformance': overallPerformance,
        'environmentalScore': environmentalScore,
        'profitMargin': profitMargin,
        'sustainabilityScore': soilHealth,
        'farmSize': farmSize,
        'activeCrops': activeCrops,
        // Real sensor data metrics
        'temperature': realSensorData?['temperature']?.toDouble() ?? 25.0,
        'humidity': realSensorData?['humidity']?.toDouble() ?? 65.0,
        'ph': realSensorData?['ph']?.toDouble() ?? 6.5,
        'soilMoisture':
            realSensorData?['soil_moisture_avg']?.toDouble() ?? 35.0,
        'nitrogen': realSensorData?['N']?.toDouble() ?? 50.0,
        'phosphorus': realSensorData?['P']?.toDouble() ?? 30.0,
        'potassium': realSensorData?['K']?.toDouble() ?? 20.0,
        'rainfall': realSensorData?['rainfall']?.toDouble() ?? 120.0,
      },
      alerts: _generateDashboardAlerts(
          latestYieldPrediction, latestEnvironmentalTracking),
      alertsHindi: _generateDashboardAlertsHindi(
          latestYieldPrediction, latestEnvironmentalTracking),
      performanceIndicators: {
        'yield_efficiency': latestYieldPrediction?.yieldEfficiency ?? 0,
        'cost_efficiency': latestPerformanceReport?.financialData.roi ?? 0,
        'water_efficiency':
            latestEnvironmentalTracking?.waterData.irrigationEfficiency ?? 0,
        'soil_health':
            latestEnvironmentalTracking?.soilData.biodiversityIndex ?? 0,
        'sustainability':
            latestEnvironmentalTracking?.overallEnvironmentalScore ?? 0,
      },
      quickRecommendations: _generateQuickRecommendationsFromSensorData(
          realSensorData, farmHealth),
      quickRecommendationsHindi:
          _generateQuickRecommendationsHindiFromSensorData(
              realSensorData, farmHealth),
      trends: _generateTrendsFromSensorData(realSensorData),
      farmHealthScore: farmHealth,
    );

    _dashboardSummaries.add(summary);
    return summary;
  }

  // Crop Detection Services
  Future<CropDetectionResult> detectCropFromImage(dynamic imageFile) async {
    try {
      print('🔍 Starting crop detection in analytics service...');
      return await _cropDetectionService.detectCropFromImage(imageFile);
    } catch (e) {
      print('❌ Error in crop detection: $e');
      throw Exception('Crop detection failed: $e');
    }
  }

  Future<CropHealthSummary> getCropHealthSummary(
      List<CropDetectionResult> detections) async {
    try {
      print('📊 Generating crop health summary...');
      return await _cropDetectionService.getCropHealthSummary(detections);
    } catch (e) {
      print('❌ Error generating crop health summary: $e');
      throw Exception('Crop health summary failed: $e');
    }
  }

  // Advanced Analytics
  Future<Map<String, dynamic>> generateAdvancedAnalytics(
    String farmerId,
    String analysisType, // 'predictive', 'comparative', 'optimization', 'risk'
    Map<String, dynamic>? parameters,
  ) async {
    await Future.delayed(const Duration(seconds: 5)); // Complex AI processing

    final random = math.Random();

    switch (analysisType) {
      case 'predictive':
        return _generatePredictiveAnalytics(farmerId, random);
      case 'comparative':
        return _generateComparativeAnalytics(farmerId, random);
      case 'optimization':
        return _generateOptimizationAnalytics(farmerId, random);
      case 'risk':
        return _generateRiskAnalytics(farmerId, random);
      default:
        return _generatePredictiveAnalytics(farmerId, random);
    }
  }

  // Helper Methods
  double _getStandardYield(String cropType) {
    final standardYields = {
      'wheat': 2500.0,
      'rice': 3000.0,
      'cotton': 400.0,
      'maize': 3500.0,
      'sugarcane': 65000.0,
      'soybean': 1200.0,
      'tomato': 25000.0,
      'potato': 20000.0,
    };
    return standardYields[cropType.toLowerCase()] ?? 2000.0;
  }

  double _calculateWeatherFactor(double temperature, double humidity) {
    // Optimal temperature range 20-30°C, optimal humidity 60-80%
    double tempFactor = 1.0;
    if (temperature < 20 || temperature > 35) {
      tempFactor = 0.8;
    } else if (temperature >= 25 && temperature <= 30) {
      tempFactor = 1.2;
    }

    double humidityFactor = 1.0;
    if (humidity < 40 || humidity > 85) {
      humidityFactor = 0.9;
    } else if (humidity >= 60 && humidity <= 75) {
      humidityFactor = 1.1;
    }

    return (tempFactor + humidityFactor) / 2;
  }

  double _calculateSoilFactor(double moisture, double ph, double nitrogen) {
    double moistureFactor = 1.0;
    if (moisture < 20 || moisture > 80) {
      moistureFactor = 0.8;
    } else if (moisture >= 40 && moisture <= 60) {
      moistureFactor = 1.2;
    }

    double phFactor = 1.0;
    if (ph < 5.5 || ph > 8.0) {
      phFactor = 0.85;
    } else if (ph >= 6.0 && ph <= 7.5) {
      phFactor = 1.15;
    }

    double nitrogenFactor = 1.0;
    if (nitrogen < 20) {
      nitrogenFactor = 0.9;
    } else if (nitrogen >= 30) {
      nitrogenFactor = 1.1;
    }

    return (moistureFactor + phFactor + nitrogenFactor) / 3;
  }

  List<YieldForecastPoint> _generateForecastPoints(
      String cropType, double finalYield) {
    final random = math.Random();
    final points = <YieldForecastPoint>[];
    final stages = ['Seedling', 'Vegetative', 'Flowering', 'Maturity'];
    final stagesHindi = ['अंकुरण', 'वनस्पति', 'फूलना', 'परिपक्वता'];

    for (int i = 0; i < stages.length; i++) {
      final progress = (i + 1) / stages.length;
      final yieldAtStage =
          finalYield * progress * (0.8 + random.nextDouble() * 0.4);
      final confidence = 60 + (progress * 30) + random.nextDouble() * 10;

      points.add(YieldForecastPoint(
        date: DateTime.now().add(Duration(days: (i + 1) * 30)),
        predictedYield: yieldAtStage,
        confidence: confidence,
        growthStage: stages[i],
        growthStageHindi: stagesHindi[i],
      ));
    }

    return points;
  }

  DateTime _calculateHarvestDate(DateTime plantingDate, String cropType) {
    final cropDurations = {
      'wheat': 120,
      'rice': 150,
      'cotton': 180,
      'maize': 90,
      'sugarcane': 365,
      'soybean': 100,
      'tomato': 75,
      'potato': 90,
    };

    final duration = cropDurations[cropType.toLowerCase()] ?? 120;
    return plantingDate.add(Duration(days: duration));
  }

  List<String> _generateYieldRecommendations(
      double weatherFactor, double soilFactor, double managementFactor) {
    final recommendations = <String>[];

    if (weatherFactor < 1.0) {
      recommendations
          .add('Monitor weather conditions closely and adjust irrigation');
      recommendations
          .add('Consider protective measures against adverse weather');
    }

    if (soilFactor < 1.0) {
      recommendations.add('Improve soil health with organic amendments');
      recommendations.add('Test and adjust soil pH levels');
    }

    if (managementFactor < 1.0) {
      recommendations.add('Optimize crop management practices');
      recommendations.add('Consider precision agriculture techniques');
    }

    if (recommendations.isEmpty) {
      recommendations
          .add('Current conditions are favorable - maintain practices');
      recommendations.add('Consider yield enhancement techniques');
    }

    return recommendations;
  }

  List<String> _generateYieldRecommendationsHindi(
      double weatherFactor, double soilFactor, double managementFactor) {
    final recommendations = <String>[];

    if (weatherFactor < 1.0) {
      recommendations
          .add('मौसम की स्थिति पर बारीकी से नजर रखें और सिंचाई समायोजित करें');
      recommendations.add('प्रतिकूल मौसम के खिलाफ सुरक्षात्मक उपाय करें');
    }

    if (soilFactor < 1.0) {
      recommendations
          .add('जैविक संशोधन के साथ मिट्टी की स्वास्थ्य में सुधार करें');
      recommendations.add('मिट्टी के pH स्तर का परीक्षण और समायोजन करें');
    }

    if (managementFactor < 1.0) {
      recommendations.add('फसल प्रबंधन प्रथाओं को अनुकूलित करें');
      recommendations.add('सटीक कृषि तकनीकों पर विचार करें');
    }

    if (recommendations.isEmpty) {
      recommendations.add('वर्तमान स्थितियां अनुकूल हैं - अभ्यास बनाए रखें');
      recommendations.add('उत्पादन वृद्धि तकनीकों पर विचार करें');
    }

    return recommendations;
  }

  Future<Map<String, CropPerformanceData>> _generateCropPerformanceData(
      String farmerId, DateTime startDate, DateTime endDate) async {
    final random = math.Random();
    final crops = ['wheat', 'rice', 'cotton'];
    final cropsHindi = ['गेहूं', 'धान', 'कपास'];
    final cropData = <String, CropPerformanceData>{};

    for (int i = 0; i < crops.length; i++) {
      final crop = crops[i];
      final expectedYield = _getStandardYield(crop);
      final actualYield = expectedYield * (0.8 + random.nextDouble() * 0.4);

      cropData[crop] = CropPerformanceData(
        cropType: crop,
        cropTypeHindi: cropsHindi[i],
        areaUnderCultivation: 1 + random.nextDouble() * 4,
        actualYield: actualYield,
        expectedYield: expectedYield,
        yieldEfficiency: (actualYield / expectedYield) * 100,
        productionCost: 30000 + random.nextDouble() * 40000,
        revenue: actualYield * (20 + random.nextDouble() * 30),
        profit: (actualYield * (20 + random.nextDouble() * 30)) -
            (30000 + random.nextDouble() * 40000),
        profitPerAcre: ((actualYield * (20 + random.nextDouble() * 30)) -
                (30000 + random.nextDouble() * 40000)) /
            (1 + random.nextDouble() * 4),
        daysToMaturity: 90 + random.nextInt(60),
        qualityGrade: ['A', 'B+', 'B'][random.nextInt(3)],
        wastagePercentage: random.nextDouble() * 15 + 2,
        inputUsage: {
          'seeds': 50 + random.nextDouble() * 30,
          'fertilizer': 200 + random.nextDouble() * 150,
          'pesticide': 20 + random.nextDouble() * 30,
          'water': 1000 + random.nextDouble() * 2000,
        },
        challenges: _getCropChallenges(crop),
        challengesHindi: _getCropChallengesHindi(crop),
        successes: _getCropSuccesses(crop),
        successesHindi: _getCropSuccessesHindi(crop),
      );
    }

    return cropData;
  }

  FinancialPerformanceData _generateFinancialPerformanceData(
      math.Random random) {
    final totalRevenue = 150000 + random.nextDouble() * 200000;
    final totalCosts = 80000 + random.nextDouble() * 120000;
    final netProfit = totalRevenue - totalCosts;

    return FinancialPerformanceData(
      totalRevenue: totalRevenue,
      totalCosts: totalCosts,
      netProfit: netProfit,
      profitMargin: (netProfit / totalRevenue) * 100,
      roi: (netProfit / totalCosts) * 100,
      costPerAcre: totalCosts / 5,
      revenuePerAcre: totalRevenue / 5,
      costBreakdown: {
        'seeds': totalCosts * 0.15,
        'fertilizer': totalCosts * 0.25,
        'pesticide': totalCosts * 0.10,
        'labor': totalCosts * 0.30,
        'machinery': totalCosts * 0.12,
        'other': totalCosts * 0.08,
      },
      revenueBreakdown: {
        'wheat': totalRevenue * 0.4,
        'rice': totalRevenue * 0.35,
        'cotton': totalRevenue * 0.25,
      },
      subsidiesReceived: 15000 + random.nextDouble() * 25000,
      loansUtilized: 50000 + random.nextDouble() * 100000,
      savingsGenerated: netProfit * 0.3,
      monthlyTrends: {
        'Jan': 10000 + random.nextDouble() * 15000,
        'Feb': 12000 + random.nextDouble() * 18000,
        'Mar': 15000 + random.nextDouble() * 25000,
        'Apr': 20000 + random.nextDouble() * 30000,
        'May': 25000 + random.nextDouble() * 35000,
        'Jun': 18000 + random.nextDouble() * 28000,
      },
    );
  }

  Future<EnvironmentalPerformanceData> _generateEnvironmentalPerformanceData(
      String farmerId) async {
    final random = math.Random();

    return EnvironmentalPerformanceData(
      waterUsageEfficiency: 65 + random.nextDouble() * 30,
      soilHealthScore: 70 + random.nextDouble() * 25,
      carbonFootprint: 500 + random.nextDouble() * 300,
      organicMatterImprovement: random.nextDouble() * 15 + 5,
      biodiversityIndex: 60 + random.nextDouble() * 35,
      resourceUtilization: {
        'water': 75 + random.nextDouble() * 20,
        'energy': 60 + random.nextDouble() * 30,
        'land': 85 + random.nextDouble() * 10,
        'nutrients': 70 + random.nextDouble() * 25,
      },
      sustainabilityScore: 65 + random.nextDouble() * 30,
      environmentalBenefits: [
        'Improved soil organic matter',
        'Reduced water wastage',
        'Increased biodiversity',
        'Carbon sequestration',
      ],
      environmentalBenefitsHindi: [
        'मिट्टी में जैविक पदार्थ सुधार',
        'पानी की बर्बादी कम',
        'जैव विविधता में वृद्धि',
        'कार्बन भंडारण',
      ],
      pollutionMetrics: {
        'nitrogenRunoff': 10 + random.nextDouble() * 20,
        'phosphorusLeaching': 5 + random.nextDouble() * 15,
        'pesticidesResidues': 2 + random.nextDouble() * 8,
      },
      renewableEnergyUsage: random.nextDouble() * 40 + 10,
      wasteReduction: random.nextDouble() * 30 + 20,
    );
  }

  OperationalPerformanceData _generateOperationalPerformanceData(
      math.Random random) {
    return OperationalPerformanceData(
      farmingEfficiency: 70 + random.nextDouble() * 25,
      technologyAdoption: 40 + random.nextDouble() * 45,
      laborProductivity: 65 + random.nextDouble() * 30,
      equipmentUtilization: 60 + random.nextDouble() * 35,
      automationLevel: random.nextInt(60) + 20,
      taskCompletionTimes: {
        'plowing': 8 + random.nextDouble() * 4,
        'sowing': 6 + random.nextDouble() * 3,
        'harvesting': 12 + random.nextDouble() * 6,
        'irrigation': 4 + random.nextDouble() * 2,
      },
      downtime: random.nextDouble() * 50 + 10,
      maintenanceCosts: 15000 + random.nextDouble() * 20000,
      processImprovements: [
        'Adopted drip irrigation',
        'Implemented crop rotation',
        'Started using mobile app for monitoring',
      ],
      processImprovementsHindi: [
        'ड्रिप सिंचाई अपनाई',
        'फसल चक्र लागू किया',
        'निगरानी के लिए मोबाइल ऐप का उपयोग शुरू किया',
      ],
      digitalizationMetrics: {
        'appUsage': random.nextDouble() * 80 + 20,
        'dataCollection': random.nextDouble() * 70 + 30,
        'automatedSystems': random.nextDouble() * 50 + 10,
      },
    );
  }

  double _calculateOverallPerformanceScore(
    FinancialPerformanceData financial,
    EnvironmentalPerformanceData environmental,
    OperationalPerformanceData operational,
    Map<String, CropPerformanceData> crops,
  ) {
    final financialWeight = 0.35;
    final environmentalWeight = 0.25;
    final operationalWeight = 0.20;
    final cropWeight = 0.20;

    final financialScore =
        math.min(100, financial.roi * 2); // ROI to 0-100 scale
    final environmentalScore = environmental.sustainabilityScore;
    final operationalScore = operational.farmingEfficiency;
    final cropScore =
        crops.values.map((c) => c.yieldEfficiency).reduce((a, b) => a + b) /
            crops.length;

    return (financialScore * financialWeight) +
        (environmentalScore * environmentalWeight) +
        (operationalScore * operationalWeight) +
        (cropScore * cropWeight);
  }

  String _calculatePerformanceGrade(double score) {
    if (score >= 95) return 'A+';
    if (score >= 90) return 'A';
    if (score >= 85) return 'B+';
    if (score >= 80) return 'B';
    if (score >= 75) return 'C+';
    if (score >= 70) return 'C';
    return 'D';
  }

  List<String> _generateAchievements(
      double score,
      FinancialPerformanceData financial,
      EnvironmentalPerformanceData environmental) {
    final achievements = <String>[];

    if (score >= 85) achievements.add('Excellent overall farm performance');
    if (financial.roi > 50)
      achievements.add('Outstanding return on investment');
    if (environmental.sustainabilityScore > 80)
      achievements.add('High sustainability practices');
    if (achievements.isEmpty)
      achievements.add('Consistent farming performance');

    return achievements;
  }

  List<String> _generateAchievementsHindi(
      double score,
      FinancialPerformanceData financial,
      EnvironmentalPerformanceData environmental) {
    final achievements = <String>[];

    if (score >= 85) achievements.add('उत्कृष्ट समग्र खेत प्रदर्शन');
    if (financial.roi > 50) achievements.add('निवेश पर उत्कृष्ट रिटर्न');
    if (environmental.sustainabilityScore > 80)
      achievements.add('उच्च स्थिरता प्रथाएं');
    if (achievements.isEmpty) achievements.add('निरंतर कृषि प्रदर्शन');

    return achievements;
  }

  List<String> _generateImprovements(
      double score, Map<String, CropPerformanceData> crops) {
    final improvements = <String>[];

    if (score < 70) improvements.add('Focus on improving overall efficiency');

    crops.forEach((crop, data) {
      if (data.yieldEfficiency < 80) {
        improvements.add('Improve $crop yield through better practices');
      }
      if (data.wastagePercentage > 10) {
        improvements.add('Reduce post-harvest losses for $crop');
      }
    });

    if (improvements.isEmpty)
      improvements.add('Continue current best practices');

    return improvements;
  }

  List<String> _generateImprovementsHindi(
      double score, Map<String, CropPerformanceData> crops) {
    final improvements = <String>[];

    if (score < 70) improvements.add('समग्र दक्षता सुधार पर ध्यान दें');

    crops.forEach((crop, data) {
      if (data.yieldEfficiency < 80) {
        improvements.add(
            'बेहतर प्रथाओं के माध्यम से ${data.cropTypeHindi} उत्पादन में सुधार');
      }
      if (data.wastagePercentage > 10) {
        improvements.add(
            '${data.cropTypeHindi} के लिए फसल कटाई के बाद के नुकसान को कम करें');
      }
    });

    if (improvements.isEmpty)
      improvements.add('वर्तमान सर्वोत्तम प्रथाओं को जारी रखें');

    return improvements;
  }

  Map<String, dynamic> _generateBenchmarkComparison(
      FinancialPerformanceData financial,
      EnvironmentalPerformanceData environmental) {
    final random = math.Random();

    return {
      'regionalAverage': {
        'roi': 25 + random.nextDouble() * 20,
        'yieldEfficiency': 75 + random.nextDouble() * 15,
        'sustainabilityScore': 60 + random.nextDouble() * 20,
      },
      'nationalAverage': {
        'roi': 20 + random.nextDouble() * 15,
        'yieldEfficiency': 70 + random.nextDouble() * 15,
        'sustainabilityScore': 55 + random.nextDouble() * 20,
      },
      'topPerformers': {
        'roi': 60 + random.nextDouble() * 20,
        'yieldEfficiency': 95 + random.nextDouble() * 5,
        'sustainabilityScore': 85 + random.nextDouble() * 10,
      },
    };
  }

  Future<List<PerformanceRecommendation>> _generatePerformanceRecommendations(
      String farmerId, double score) async {
    final recommendations = <PerformanceRecommendation>[];

    if (score < 70) {
      recommendations.add(PerformanceRecommendation(
        id: 'PERF_REC_1',
        category: 'operational',
        priority: 'high',
        title: 'Improve Operational Efficiency',
        titleHindi: 'परिचालन दक्षता में सुधार',
        description:
            'Focus on streamlining farm operations to reduce costs and improve productivity',
        descriptionHindi:
            'लागत कम करने और उत्पादकता बढ़ाने के लिए खेत संचालन को सुव्यवस्थित करने पर ध्यान दें',
        actionSteps: [
          'Implement precision agriculture techniques',
          'Optimize labor allocation and scheduling',
          'Upgrade to modern farming equipment',
        ],
        actionStepsHindi: [
          'सटीक कृषि तकनीकों को लागू करें',
          'श्रम आवंटन और समय-निर्धारण को अनुकूलित करें',
          'आधुनिक कृषि उपकरण में अपग्रेड करें',
        ],
        expectedImprovement: 15.0,
        implementationCost: 50000.0,
        timeToImplement: 90,
        resources: {
          'funding': 'Agricultural loans available',
          'training': 'Extension services support',
          'technology': 'Mobile app guidance',
        },
      ));
    }

    return recommendations;
  }

  Map<String, List<double>> _generateTrendAnalysis(String reportType) {
    final random = math.Random();
    final periods =
        reportType == 'monthly' ? 12 : (reportType == 'seasonal' ? 4 : 5);

    return {
      'yield': List.generate(periods, (index) => 70 + random.nextDouble() * 25),
      'profit':
          List.generate(periods, (index) => 15 + random.nextDouble() * 20),
      'efficiency':
          List.generate(periods, (index) => 65 + random.nextDouble() * 30),
      'sustainability':
          List.generate(periods, (index) => 60 + random.nextDouble() * 35),
    };
  }

  String _calculateWeatherStress(double temperature) {
    if (temperature < 10 || temperature > 40) return 'high';
    if (temperature < 15 || temperature > 35) return 'medium';
    if (temperature < 20 || temperature > 30) return 'low';
    return 'none';
  }

  List<String> _generateWeatherEvents(math.Random random) {
    final events = [
      'Clear skies',
      'Light rain',
      'Heavy rain',
      'Drought',
      'Storm',
      'Frost'
    ];
    return [events[random.nextInt(events.length)]];
  }

  String _getAirQualityStatus(double aqi) {
    if (aqi <= 50) return 'good';
    if (aqi <= 100) return 'moderate';
    if (aqi <= 150) return 'unhealthy for sensitive groups';
    if (aqi <= 200) return 'unhealthy';
    return 'very unhealthy';
  }

  List<String> _generateEnvironmentalAlerts(math.Random random) {
    final alerts = [
      'Soil moisture levels are optimal',
      'Air quality is good for farming',
      'Biodiversity index is improving',
      'Water usage efficiency can be improved',
      'Consider organic farming practices',
    ];

    return [alerts[random.nextInt(alerts.length)]];
  }

  List<String> _generateEnvironmentalAlertsHindi(math.Random random) {
    final alerts = [
      'मिट्टी की नमी का स्तर इष्टतम है',
      'हवा की गुणवत्ता खेती के लिए अच्छी है',
      'जैव विविधता सूचकांक में सुधार हो रहा है',
      'पानी के उपयोग की दक्षता में सुधार किया जा सकता है',
      'जैविक खेती प्रथाओं पर विचार करें',
    ];

    return [alerts[random.nextInt(alerts.length)]];
  }

  List<EnvironmentalRecommendation> _generateEnvironmentalRecommendations(
      math.Random random) {
    return [
      EnvironmentalRecommendation(
        id: 'ENV_REC_1',
        type: 'soil',
        urgency: 'short_term',
        title: 'Improve Soil Organic Matter',
        titleHindi: 'मिट्टी में जैविक पदार्थ सुधार',
        description:
            'Add compost and organic amendments to improve soil health',
        descriptionHindi:
            'मिट्टी स्वास्थ्य सुधारने के लिए कंपोस्ट और जैविक संशोधन जोड़ें',
        benefits: [
          'Better water retention',
          'Improved nutrient availability',
          'Enhanced microbial activity',
        ],
        benefitsHindi: [
          'बेहतर जल धारण',
          'सुधारी पोषक तत्व उपलब्धता',
          'बढ़ी सूक्ष्मजीव गतिविधि',
        ],
        implementationCost: 5000.0,
        environmentalImpact: 85.0,
        timeframe: 30,
      ),
    ];
  }

  List<String> _generateDashboardAlerts(
      YieldPrediction? yieldPred, EnvironmentalTracking? envTrack) {
    final alerts = <String>[];

    if (yieldPred != null && yieldPred.confidenceLevel < 70) {
      alerts.add('Yield prediction confidence is low - monitor crop closely');
    }

    if (envTrack != null && envTrack.overallEnvironmentalScore < 60) {
      alerts.add('Environmental conditions need attention');
    }

    if (alerts.isEmpty) {
      alerts.add('All systems operating normally');
    }

    return alerts;
  }

  List<String> _generateDashboardAlertsHindi(
      YieldPrediction? yieldPred, EnvironmentalTracking? envTrack) {
    final alerts = <String>[];

    if (yieldPred != null && yieldPred.confidenceLevel < 70) {
      alerts.add(
          'उत्पादन भविष्यवाणी की आत्मविश्वास कम है - फसल की बारीकी से निगरानी करें');
    }

    if (envTrack != null && envTrack.overallEnvironmentalScore < 60) {
      alerts.add('पर्यावरणीय स्थितियों पर ध्यान देने की जरूरत है');
    }

    if (alerts.isEmpty) {
      alerts.add('सभी सिस्टम सामान्य रूप से काम कर रहे हैं');
    }

    return alerts;
  }

  Map<String, dynamic> _generatePredictiveAnalytics(
      String farmerId, math.Random random) {
    return {
      'nextSeasonYield': 2800 + random.nextDouble() * 1000,
      'marketPriceForecast': 28 + random.nextDouble() * 12,
      'weatherRisks': ['Drought probability: 25%', 'Flood probability: 15%'],
      'recommendedActions': [
        'Start early planting for next season',
        'Invest in water conservation',
        'Consider drought-resistant varieties',
      ],
      'profitProjection': 45000 + random.nextDouble() * 80000,
      'confidenceLevel': 78 + random.nextDouble() * 15,
    };
  }

  Map<String, dynamic> _generateComparativeAnalytics(
      String farmerId, math.Random random) {
    return {
      'regionalComparison': {
        'yourYield': 2650,
        'regionalAverage': 2400,
        'topPerformer': 3200,
      },
      'costEfficiency': {
        'yourCosts': 32000,
        'averageCosts': 35000,
        'bestInClass': 28000,
      },
      'ranking': {
        'overall': '12th out of 50',
        'yieldEfficiency': '8th out of 50',
        'sustainability': '15th out of 50',
      },
      'improvementOpportunities': [
        'Yield can be improved by 20%',
        'Cost reduction potential: 15%',
        'Sustainability score can increase by 25 points',
      ],
    };
  }

  Map<String, dynamic> _generateOptimizationAnalytics(
      String farmerId, math.Random random) {
    return {
      'resourceOptimization': {
        'water': 'Reduce usage by 25% with drip irrigation',
        'fertilizer': 'Optimize NPK ratio for 15% better efficiency',
        'labor': 'Mechanization can reduce labor costs by 30%',
      },
      'cropSelection': {
        'mostProfitable': 'Organic wheat with 45% higher margins',
        'leastRisky': 'Traditional rice with stable returns',
        'emerging': 'Quinoa with growing market demand',
      },
      'timing': {
        'optimalPlanting': 'First week of November',
        'harvestWindow': 'Mid-March to early April',
        'marketingTime': 'April-May for best prices',
      },
      'investmentRecommendations': [
        'Solar irrigation: ROI 35% over 5 years',
        'Soil testing equipment: Break-even in 2 years',
        'Cold storage: Reduces losses by 40%',
      ],
    };
  }

  Map<String, dynamic> _generateRiskAnalytics(
      String farmerId, math.Random random) {
    return {
      'riskAssessment': {
        'weather': 'Medium risk - 30% chance of adverse conditions',
        'market': 'Low risk - stable price trends expected',
        'pests': 'High risk - aphid outbreak reported in region',
        'financial': 'Low risk - good credit profile',
      },
      'mitigation': {
        'insurance': 'Crop insurance covers 80% of risks',
        'diversification': '3 crops reduce risk by 45%',
        'contracts': 'Forward selling covers 60% of produce',
      },
      'contingencyPlans': [
        'Alternative water sources identified',
        'Pest management protocol in place',
        'Emergency fund covers 6 months expenses',
      ],
      'earlyWarnings': [
        'Monitor weather forecasts daily',
        'Scout for pests weekly',
        'Track market prices continuously',
      ],
    };
  }

  List<String> _getCropChallenges(String crop) {
    final challenges = {
      'wheat': ['Late blight', 'Water scarcity', 'Market price fluctuation'],
      'rice': ['Brown plant hopper', 'Excessive rainfall', 'Labor shortage'],
      'cotton': ['Pink bollworm', 'High input costs', 'Quality issues'],
    };
    return challenges[crop] ??
        ['Weather dependence', 'Input cost rise', 'Market volatility'];
  }

  List<String> _getCropChallengesHindi(String crop) {
    final challenges = {
      'wheat': ['देर से तुषार', 'पानी की कमी', 'बाजार मूल्य में उतार-चढ़ाव'],
      'rice': ['भूरा पौधा हॉपर', 'अत्यधिक बारिश', 'श्रमिक की कमी'],
      'cotton': ['गुलाबी बॉलवर्म', 'उच्च इनपुट लागत', 'गुणवत्ता समस्याएं'],
    };
    return challenges[crop] ??
        ['मौसम निर्भरता', 'इनपुट लागत वृद्धि', 'बाजार अस्थिरता'];
  }

  List<String> _getCropSuccesses(String crop) {
    return ['Good yield achieved', 'Quality produce', 'Timely harvest'];
  }

  List<String> _getCropSuccessesHindi(String crop) {
    return ['अच्छी उपज प्राप्त', 'गुणवत्तापूर्ण उत्पादन', 'समय पर फसल'];
  }

  // Helper methods for real sensor data integration
  double _calculateYieldFromSensorData(
      Map<String, dynamic>? sensorData, YieldPrediction? existingPrediction) {
    if (sensorData == null) {
      return existingPrediction?.totalPredictedYield ?? 0;
    }

    // Calculate yield based on sensor data
    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    // Base yield calculation
    double baseYield = 100.0; // Base yield in quintals per hectare

    // Temperature factor (optimal: 20-30°C)
    double tempFactor = 1.0;
    if (temperature < 20 || temperature > 30) {
      tempFactor = 0.8;
    }

    // Humidity factor (optimal: 60-80%)
    double humidityFactor = 1.0;
    if (humidity < 60 || humidity > 80) {
      humidityFactor = 0.9;
    }

    // pH factor (optimal: 6.0-7.0)
    double phFactor = 1.0;
    if (ph < 6.0 || ph > 7.0) {
      phFactor = 0.85;
    }

    // Soil moisture factor (optimal: 30-50%)
    double moistureFactor = 1.0;
    if (soilMoisture < 30 || soilMoisture > 50) {
      moistureFactor = 0.9;
    }

    // Nutrient factor (N+P+K optimal: 100+)
    double nutrientFactor = 1.0;
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients < 80) {
      nutrientFactor = 0.7;
    } else if (totalNutrients > 120) {
      nutrientFactor = 0.95;
    }

    final calculatedYield = baseYield *
        tempFactor *
        humidityFactor *
        phFactor *
        moistureFactor *
        nutrientFactor;
    return double.parse(calculatedYield.toStringAsFixed(1));
  }

  double _calculateEnvironmentalScoreFromSensorData(
      Map<String, dynamic>? sensorData,
      EnvironmentalTracking? existingTracking) {
    if (sensorData == null) {
      return existingTracking?.overallEnvironmentalScore ?? 75.0;
    }

    // Calculate environmental score based on sensor data
    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    double score = 100.0;

    // Temperature impact (penalty for extreme temperatures)
    if (temperature < 15 || temperature > 35) {
      score -= 15;
    } else if (temperature < 20 || temperature > 30) {
      score -= 5;
    }

    // Humidity impact (penalty for extreme humidity)
    if (humidity < 40 || humidity > 90) {
      score -= 10;
    }

    // pH impact (penalty for extreme pH)
    if (ph < 5.5 || ph > 8.0) {
      score -= 20;
    } else if (ph < 6.0 || ph > 7.5) {
      score -= 10;
    }

    // Soil moisture impact (penalty for extreme moisture)
    if (soilMoisture < 20 || soilMoisture > 60) {
      score -= 15;
    }

    // Nutrient balance impact
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients < 70) {
      score -= 10;
    } else if (totalNutrients > 150) {
      score -= 5; // Over-fertilization penalty
    }

    return double.parse(score.clamp(0, 100).toStringAsFixed(1));
  }

  double _calculateSoilHealthFromSensorData(Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return 75.0;
    }

    // Calculate soil health based on sensor data
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    double healthScore = 100.0;

    // pH health (optimal: 6.0-7.0)
    if (ph >= 6.0 && ph <= 7.0) {
      // Perfect pH
    } else if (ph >= 5.5 && ph <= 7.5) {
      healthScore -= 5;
    } else {
      healthScore -= 15;
    }

    // Moisture health (optimal: 30-50%)
    if (soilMoisture >= 30 && soilMoisture <= 50) {
      // Perfect moisture
    } else if (soilMoisture >= 25 && soilMoisture <= 55) {
      healthScore -= 5;
    } else {
      healthScore -= 10;
    }

    // Nutrient health
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120) {
      // Optimal nutrients
    } else if (totalNutrients >= 70 && totalNutrients <= 140) {
      healthScore -= 5;
    } else {
      healthScore -= 10;
    }

    // Nutrient balance (N:P:K ratio should be roughly 2:1:1)
    final nRatio = nitrogen / (phosphorus + potassium) * 2;
    if (nRatio >= 1.5 && nRatio <= 2.5) {
      // Good balance
    } else {
      healthScore -= 5;
    }

    return double.parse(healthScore.clamp(0, 100).toStringAsFixed(1));
  }

  // Calculate yield confidence based on sensor data
  double _calculateYieldConfidenceFromSensorData(
      Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return 85.0;
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    double confidence = 100.0;

    // Temperature factor (optimal: 20-30°C)
    if (temperature >= 20 && temperature <= 30) {
      // Perfect temperature
    } else if (temperature >= 15 && temperature <= 35) {
      confidence -= 5;
    } else {
      confidence -= 15;
    }

    // Humidity factor (optimal: 60-80%)
    if (humidity >= 60 && humidity <= 80) {
      // Perfect humidity
    } else if (humidity >= 50 && humidity <= 90) {
      confidence -= 5;
    } else {
      confidence -= 10;
    }

    // pH factor (optimal: 6.0-7.0)
    if (ph >= 6.0 && ph <= 7.0) {
      // Perfect pH
    } else if (ph >= 5.5 && ph <= 7.5) {
      confidence -= 5;
    } else {
      confidence -= 15;
    }

    // Soil moisture factor (optimal: 30-50%)
    if (soilMoisture >= 30 && soilMoisture <= 50) {
      // Perfect moisture
    } else if (soilMoisture >= 25 && soilMoisture <= 55) {
      confidence -= 5;
    } else {
      confidence -= 10;
    }

    // Nutrient factors
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120) {
      // Optimal nutrients
    } else if (totalNutrients >= 70 && totalNutrients <= 140) {
      confidence -= 5;
    } else {
      confidence -= 10;
    }

    return double.parse(confidence.clamp(0, 100).toStringAsFixed(1));
  }

  // Calculate overall performance based on sensor data
  double _calculateOverallPerformanceFromSensorData(
      Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return 78.5;
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;
    final rainfall = sensorData['rainfall']?.toDouble() ?? 120.0;

    double performance = 100.0;

    // Environmental conditions (40% weight)
    double envScore = 100.0;
    if (temperature >= 20 && temperature <= 30)
      envScore -= 0;
    else if (temperature >= 15 && temperature <= 35)
      envScore -= 10;
    else
      envScore -= 25;

    if (humidity >= 60 && humidity <= 80)
      envScore -= 0;
    else if (humidity >= 50 && humidity <= 90)
      envScore -= 10;
    else
      envScore -= 20;

    performance = (performance * 0.6) + (envScore * 0.4);

    // Soil conditions (30% weight)
    double soilScore = 100.0;
    if (ph >= 6.0 && ph <= 7.0)
      soilScore -= 0;
    else if (ph >= 5.5 && ph <= 7.5)
      soilScore -= 10;
    else
      soilScore -= 20;

    if (soilMoisture >= 30 && soilMoisture <= 50)
      soilScore -= 0;
    else if (soilMoisture >= 25 && soilMoisture <= 55)
      soilScore -= 10;
    else
      soilScore -= 15;

    performance = (performance * 0.7) + (soilScore * 0.3);

    // Nutrient conditions (20% weight)
    double nutrientScore = 100.0;
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120)
      nutrientScore -= 0;
    else if (totalNutrients >= 70 && totalNutrients <= 140)
      nutrientScore -= 10;
    else
      nutrientScore -= 20;

    performance = (performance * 0.8) + (nutrientScore * 0.2);

    // Rainfall factor (10% weight)
    double rainScore = 100.0;
    if (rainfall >= 100 && rainfall <= 150)
      rainScore -= 0;
    else if (rainfall >= 80 && rainfall <= 200)
      rainScore -= 5;
    else
      rainScore -= 10;

    performance = (performance * 0.9) + (rainScore * 0.1);

    return double.parse(performance.clamp(0, 100).toStringAsFixed(1));
  }

  // Calculate profit margin based on sensor data
  double _calculateProfitMarginFromSensorData(
      Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return 22.3;
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    double baseMargin = 25.0; // Base profit margin

    // Temperature impact on yield and costs
    if (temperature >= 20 && temperature <= 30) {
      baseMargin += 5; // Optimal temperature increases yield
    } else if (temperature < 15 || temperature > 35) {
      baseMargin -= 10; // Extreme temperatures reduce yield
    }

    // Humidity impact
    if (humidity >= 60 && humidity <= 80) {
      baseMargin += 3; // Optimal humidity
    } else if (humidity < 40 || humidity > 90) {
      baseMargin -= 5; // Poor humidity conditions
    }

    // Soil pH impact on fertilizer efficiency
    if (ph >= 6.0 && ph <= 7.0) {
      baseMargin += 4; // Optimal pH for nutrient uptake
    } else if (ph < 5.5 || ph > 7.5) {
      baseMargin -= 8; // Poor pH reduces fertilizer efficiency
    }

    // Soil moisture impact on irrigation costs
    if (soilMoisture >= 30 && soilMoisture <= 50) {
      baseMargin += 3; // Optimal moisture reduces irrigation needs
    } else if (soilMoisture < 20 || soilMoisture > 60) {
      baseMargin -= 6; // Poor moisture increases irrigation costs
    }

    // Nutrient balance impact on fertilizer costs
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120) {
      baseMargin += 2; // Optimal nutrient levels
    } else if (totalNutrients < 70 || totalNutrients > 140) {
      baseMargin -= 4; // Poor nutrient levels require more fertilizer
    }

    return double.parse(baseMargin.clamp(0, 50).toStringAsFixed(1));
  }

  // Calculate farm health score based on real sensor data
  double _calculateFarmHealthFromSensorData(Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      return 75.0; // Default farm health score
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;
    final rainfall = sensorData['rainfall']?.toDouble() ?? 120.0;

    double healthScore = 100.0;

    // Temperature health (optimal: 20-30°C)
    if (temperature >= 20 && temperature <= 30) {
      // Perfect temperature
    } else if (temperature >= 15 && temperature <= 35) {
      healthScore -= 5;
    } else {
      healthScore -= 15;
    }

    // Humidity health (optimal: 60-80%)
    if (humidity >= 60 && humidity <= 80) {
      // Perfect humidity
    } else if (humidity >= 50 && humidity <= 90) {
      healthScore -= 5;
    } else {
      healthScore -= 10;
    }

    // pH health (optimal: 6.0-7.0)
    if (ph >= 6.0 && ph <= 7.0) {
      // Perfect pH
    } else if (ph >= 5.5 && ph <= 7.5) {
      healthScore -= 5;
    } else {
      healthScore -= 15;
    }

    // Soil moisture health (optimal: 30-50%)
    if (soilMoisture >= 30 && soilMoisture <= 50) {
      // Perfect moisture
    } else if (soilMoisture >= 25 && soilMoisture <= 55) {
      healthScore -= 5;
    } else {
      healthScore -= 10;
    }

    // Nutrient health
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120) {
      // Optimal nutrients
    } else if (totalNutrients >= 70 && totalNutrients <= 140) {
      healthScore -= 5;
    } else {
      healthScore -= 10;
    }

    // Nutrient balance (N:P:K ratio should be roughly 2:1:1)
    final nRatio = nitrogen / (phosphorus + potassium) * 2;
    if (nRatio >= 1.5 && nRatio <= 2.5) {
      // Good balance
    } else {
      healthScore -= 5;
    }

    // Rainfall health (optimal: 100-150mm)
    if (rainfall >= 100 && rainfall <= 150) {
      // Perfect rainfall
    } else if (rainfall >= 80 && rainfall <= 200) {
      healthScore -= 3;
    } else {
      healthScore -= 8;
    }

    return double.parse(healthScore.clamp(0, 100).toStringAsFixed(1));
  }

  // Generate trends based on real sensor data
  Map<String, List<double>> _generateTrendsFromSensorData(
      Map<String, dynamic>? sensorData) {
    if (sensorData == null) {
      // Return default trends if no sensor data
      return {
        'yield': [80.0, 82.0, 85.0, 88.0, 90.0, 92.0],
        'profit': [15.0, 17.0, 19.0, 21.0, 23.0, 25.0],
        'environmental': [70.0, 72.0, 75.0, 78.0, 80.0, 82.0],
        'efficiency': [75.0, 77.0, 79.0, 81.0, 83.0, 85.0],
      };
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    // Calculate base values from sensor data
    double baseYield = 1000.0;
    double baseProfit = 25.0;
    double baseEnvironmental = 80.0;
    double baseEfficiency = 85.0;

    // Adjust based on sensor conditions
    // Temperature factor (optimal: 20-30°C)
    if (temperature >= 20 && temperature <= 30) {
      baseYield *= 1.1;
      baseProfit *= 1.05;
    } else if (temperature < 15 || temperature > 35) {
      baseYield *= 0.8;
      baseProfit *= 0.9;
    }

    // Humidity factor (optimal: 60-80%)
    if (humidity >= 60 && humidity <= 80) {
      baseEnvironmental *= 1.05;
      baseEfficiency *= 1.02;
    } else if (humidity < 40 || humidity > 90) {
      baseEnvironmental *= 0.9;
      baseEfficiency *= 0.95;
    }

    // pH factor (optimal: 6.0-7.0)
    if (ph >= 6.0 && ph <= 7.0) {
      baseYield *= 1.05;
      baseEnvironmental *= 1.03;
    } else if (ph < 5.5 || ph > 7.5) {
      baseYield *= 0.85;
      baseEnvironmental *= 0.9;
    }

    // Soil moisture factor (optimal: 30-50%)
    if (soilMoisture >= 30 && soilMoisture <= 50) {
      baseEfficiency *= 1.03;
      baseProfit *= 1.02;
    } else if (soilMoisture < 20 || soilMoisture > 60) {
      baseEfficiency *= 0.9;
      baseProfit *= 0.95;
    }

    // Nutrient factors
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients >= 90 && totalNutrients <= 120) {
      baseYield *= 1.08;
      baseProfit *= 1.05;
    } else if (totalNutrients < 70 || totalNutrients > 140) {
      baseYield *= 0.9;
      baseProfit *= 0.92;
    }

    // Generate 6-month trend based on sensor data
    final yieldTrend = <double>[];
    final profitTrend = <double>[];
    final environmentalTrend = <double>[];
    final efficiencyTrend = <double>[];

    for (int i = 0; i < 6; i++) {
      // Add some variation but keep it realistic based on sensor data
      final monthFactor = 1.0 + (i * 0.02); // Slight upward trend
      final variation = 0.95 + (0.1 * (i % 3)); // Small variation

      yieldTrend.add((baseYield * monthFactor * variation).clamp(500, 1500));
      profitTrend.add((baseProfit * monthFactor * variation).clamp(10, 40));
      environmentalTrend
          .add((baseEnvironmental * monthFactor * variation).clamp(60, 100));
      efficiencyTrend
          .add((baseEfficiency * monthFactor * variation).clamp(70, 100));
    }

    return {
      'yield': yieldTrend,
      'profit': profitTrend,
      'environmental': environmentalTrend,
      'efficiency': efficiencyTrend,
    };
  }

  // Generate recommendations based on real sensor data
  List<String> _generateQuickRecommendationsFromSensorData(
      Map<String, dynamic>? sensorData, double farmHealth) {
    final recommendations = <String>[];

    if (sensorData == null) {
      recommendations.add('Unable to fetch sensor data - check connection');
      recommendations.add('Consider manual data entry for better insights');
      return recommendations;
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    // Temperature recommendations
    if (temperature < 20) {
      recommendations
          .add('Temperature is low - consider greenhouse or season adjustment');
    } else if (temperature > 35) {
      recommendations
          .add('High temperature detected - increase irrigation and shade');
    }

    // Humidity recommendations
    if (humidity < 50) {
      recommendations
          .add('Low humidity - consider misting or humidity control');
    } else if (humidity > 85) {
      recommendations
          .add('High humidity - improve ventilation to prevent diseases');
    }

    // pH recommendations
    if (ph < 6.0) {
      recommendations.add('Soil pH is acidic - add lime to raise pH level');
    } else if (ph > 7.5) {
      recommendations.add('Soil pH is alkaline - add sulfur or organic matter');
    }

    // Soil moisture recommendations
    if (soilMoisture < 30) {
      recommendations
          .add('Soil moisture is low - increase irrigation frequency');
    } else if (soilMoisture > 60) {
      recommendations.add(
          'Soil moisture is high - reduce irrigation to prevent waterlogging');
    }

    // Nutrient recommendations
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients < 80) {
      recommendations
          .add('Nutrient levels are low - apply balanced fertilizer');
    } else if (totalNutrients > 140) {
      recommendations
          .add('Nutrient levels are high - reduce fertilizer application');
    }

    // General health recommendations
    if (farmHealth >= 90) {
      recommendations.add('Excellent farm health - maintain current practices');
    } else if (farmHealth >= 70) {
      recommendations.add('Good farm health - minor optimizations recommended');
    } else {
      recommendations
          .add('Farm health needs improvement - consult agricultural expert');
    }

    return recommendations.take(3).toList();
  }

  // Generate Hindi recommendations based on real sensor data
  List<String> _generateQuickRecommendationsHindiFromSensorData(
      Map<String, dynamic>? sensorData, double farmHealth) {
    final recommendations = <String>[];

    if (sensorData == null) {
      recommendations.add('सेंसर डेटा प्राप्त नहीं कर सकते - कनेक्शन जांचें');
      recommendations
          .add('बेहतर अंतर्दृष्टि के लिए मैनुअल डेटा प्रविष्टि पर विचार करें');
      return recommendations;
    }

    final temperature = sensorData['temperature']?.toDouble() ?? 25.0;
    final humidity = sensorData['humidity']?.toDouble() ?? 65.0;
    final ph = sensorData['ph']?.toDouble() ?? 6.5;
    final soilMoisture = sensorData['soil_moisture_avg']?.toDouble() ?? 35.0;
    final nitrogen = sensorData['N']?.toDouble() ?? 50.0;
    final phosphorus = sensorData['P']?.toDouble() ?? 30.0;
    final potassium = sensorData['K']?.toDouble() ?? 20.0;

    // Temperature recommendations
    if (temperature < 20) {
      recommendations
          .add('तापमान कम है - ग्रीनहाउस या मौसम समायोजन पर विचार करें');
    } else if (temperature > 35) {
      recommendations.add('उच्च तापमान का पता चला - सिंचाई और छाया बढ़ाएं');
    }

    // Humidity recommendations
    if (humidity < 50) {
      recommendations
          .add('कम आर्द्रता - धुंध या आर्द्रता नियंत्रण पर विचार करें');
    } else if (humidity > 85) {
      recommendations.add(
          'उच्च आर्द्रता - रोगों को रोकने के लिए वेंटिलेशन में सुधार करें');
    }

    // pH recommendations
    if (ph < 6.0) {
      recommendations
          .add('मिट्टी का pH अम्लीय है - pH बढ़ाने के लिए चूना मिलाएं');
    } else if (ph > 7.5) {
      recommendations
          .add('मिट्टी का pH क्षारीय है - सल्फर या जैविक पदार्थ मिलाएं');
    }

    // Soil moisture recommendations
    if (soilMoisture < 30) {
      recommendations.add('मिट्टी की नमी कम है - सिंचाई की आवृत्ति बढ़ाएं');
    } else if (soilMoisture > 60) {
      recommendations
          .add('मिट्टी की नमी अधिक है - जलभराव को रोकने के लिए सिंचाई कम करें');
    }

    // Nutrient recommendations
    final totalNutrients = nitrogen + phosphorus + potassium;
    if (totalNutrients < 80) {
      recommendations.add('पोषक तत्वों का स्तर कम है - संतुलित उर्वरक लगाएं');
    } else if (totalNutrients > 140) {
      recommendations
          .add('पोषक तत्वों का स्तर अधिक है - उर्वरक अनुप्रयोग कम करें');
    }

    // General health recommendations
    if (farmHealth >= 90) {
      recommendations
          .add('उत्कृष्ट खेत स्वास्थ्य - वर्तमान प्रथाओं को बनाए रखें');
    } else if (farmHealth >= 70) {
      recommendations.add('अच्छा खेत स्वास्थ्य - मामूली अनुकूलन की सिफारिश');
    } else {
      recommendations.add(
          'खेत स्वास्थ्य में सुधार की आवश्यकता - कृषि विशेषज्ञ से सलाह लें');
    }

    return recommendations.take(3).toList();
  }
}
