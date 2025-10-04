import 'dart:convert';
import 'package:http/http.dart' as http;
import 'enhanced_soil_data_service.dart';
import 'soil_data_service.dart';
import '../models/soil_data.dart';

class APITestService {
  // Test all API endpoints and methods
  static Future<Map<String, dynamic>> runComprehensiveTest() async {
    final results = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'tests': <String, dynamic>{},
      'summary': <String, dynamic>{},
    };

    print('🧪 Starting comprehensive API test...');

    // Test 1: Direct API connection
    print('📡 Testing direct API connection...');
    results['tests']['direct_connection'] = await _testDirectConnection();

    // Test 2: Enhanced service with fallback
    print('🔄 Testing enhanced service...');
    results['tests']['enhanced_service'] = await _testEnhancedService();

    // Test 3: CORS proxy service
    print('🌐 Testing CORS proxy service...');
    results['tests']['cors_proxy'] = await _testCORSProxy();

    // Test 4: Soil data validation
    print('✅ Testing soil data validation...');
    results['tests']['soil_validation'] = await _testSoilDataValidation();

    // Test 5: Crop prediction
    print('🌱 Testing crop prediction...');
    results['tests']['crop_prediction'] = await _testCropPrediction();

    // Test 6: Land 1 data fetch
    print('🏞️ Testing land 1 data fetch...');
    results['tests']['land1_data'] = await _testLand1DataFetch();

    // Generate summary
    results['summary'] =
        _generateSummary(results['tests'] as Map<String, dynamic>);

    print('✅ API test completed!');
    print('📊 Summary: ${results['summary']}');

    return results;
  }

  // Test direct API connection
  static Future<Map<String, dynamic>> _testDirectConnection() async {
    try {
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

      final response = await http.post(
        Uri.parse('https://backend-krisi-ml.onrender.com/predict'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(testData),
      );

      return {
        'status': 'success',
        'status_code': response.statusCode,
        'response': response.body,
        'cors_working': response.statusCode == 200,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
        'cors_working': false,
        'is_cors_error': e.toString().contains('CORS') ||
            e.toString().contains('XMLHttpRequest'),
      };
    }
  }

  // Test automatic data fetching for land 1 (using available endpoints)
  static Future<Map<String, dynamic>> _testLand1DataFetch() async {
    try {
      // Try to get latest soil data first
      final response = await http.get(
        Uri.parse('https://backend-krisi.onrender.com/soildata/latest'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'status': 'success',
          'status_code': response.statusCode,
          'land_data': data,
          'data_fetched': true,
          'endpoint_used': 'soildata/latest',
        };
      } else {
        // Fallback to get all soil data
        final allResponse = await http.get(
          Uri.parse('https://backend-krisi.onrender.com/soildata/all'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (allResponse.statusCode == 200) {
          final allData = jsonDecode(allResponse.body);
          return {
            'status': 'success',
            'status_code': allResponse.statusCode,
            'land_data': allData,
            'data_fetched': true,
            'endpoint_used': 'soildata/all',
          };
        } else {
          return {
            'status': 'error',
            'status_code': allResponse.statusCode,
            'error': 'Failed to fetch soil data from both endpoints',
            'data_fetched': false,
          };
        }
      }
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
        'data_fetched': false,
      };
    }
  }

  // Test enhanced service
  static Future<Map<String, dynamic>> _testEnhancedService() async {
    try {
      final testResults = await EnhancedSoilDataService.testConnection();
      return {
        'status': 'success',
        'test_results': testResults,
        'connection_status':
            EnhancedSoilDataService.getConnectionStatus(testResults),
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  // Test CORS proxy service
  static Future<Map<String, dynamic>> _testCORSProxy() async {
    try {
      // Test with a simple GET request first
      final response = await http.get(
        Uri.parse('https://httpbin.org/get'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      return {
        'status': 'success',
        'status_code': response.statusCode,
        'basic_http_working': response.statusCode == 200,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  // Test soil data validation
  static Future<Map<String, dynamic>> _testSoilDataValidation() async {
    try {
      final validSoilData = SoilData(
        n: 50.0,
        p: 30.0,
        k: 20.0,
        temperature: 25.5,
        humidity: 70.2,
        ph: 6.5,
        rainfall: 120.3,
        soilMoistureAvg: 35.0,
      );

      final invalidSoilData = SoilData(
        n: -10.0, // Invalid negative value
        p: 30.0,
        k: 20.0,
        temperature: 25.5,
        humidity: 70.2,
        ph: 6.5,
        rainfall: 120.3,
        soilMoistureAvg: 35.0,
      );

      final validResult = SoilDataService.validateSoilData(validSoilData);
      final invalidResult = SoilDataService.validateSoilData(invalidSoilData);

      return {
        'status': 'success',
        'valid_data_passes': validResult,
        'invalid_data_fails': !invalidResult,
        'validation_working': validResult && !invalidResult,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  // Test crop prediction
  static Future<Map<String, dynamic>> _testCropPrediction() async {
    try {
      final soilData = SoilData(
        n: 110.0,
        p: 115.0,
        k: 120.0,
        temperature: 18.0,
        humidity: 100.0,
        ph: 1.8,
        rainfall: 20.0,
        soilMoistureAvg: 20.0,
      );

      // Test with enhanced service (includes fallback)
      final prediction =
          await EnhancedSoilDataService.getCropPrediction(soilData);

      return {
        'status': 'success',
        'prediction_received': prediction != null,
        'crop_name': prediction?.cropName,
        'confidence': prediction?.confidence,
        'description': prediction?.description,
      };
    } catch (e) {
      return {
        'status': 'error',
        'error': e.toString(),
      };
    }
  }

  // Generate test summary
  static Map<String, dynamic> _generateSummary(Map<String, dynamic> tests) {
    int successCount = 0;
    int totalTests = tests.length;
    List<String> workingFeatures = [];
    List<String> issues = [];

    tests.forEach((testName, result) {
      if (result['status'] == 'success') {
        successCount++;
        workingFeatures.add(testName);
      } else {
        issues.add('$testName: ${result['error'] ?? 'Unknown error'}');
      }
    });

    final successRate = (successCount / totalTests * 100).round();

    return {
      'total_tests': totalTests,
      'successful_tests': successCount,
      'success_rate': '$successRate%',
      'working_features': workingFeatures,
      'issues': issues,
      'overall_status': successRate >= 80
          ? 'Good'
          : successRate >= 60
              ? 'Fair'
              : 'Poor',
      'recommendations': _getRecommendations(tests),
    };
  }

  // Get recommendations based on test results
  static List<String> _getRecommendations(Map<String, dynamic> tests) {
    List<String> recommendations = [];

    if (tests['direct_connection']?['cors_working'] != true) {
      recommendations.add(
          'CORS issue detected - consider deploying the CORS proxy server');
    }

    if (tests['enhanced_service']?['status'] != 'success') {
      recommendations.add('Enhanced service not working - check API endpoints');
    }

    if (tests['crop_prediction']?['prediction_received'] != true) {
      recommendations
          .add('Crop prediction not working - check ML API connection');
    }

    if (recommendations.isEmpty) {
      recommendations.add('All systems working correctly! 🎉');
    }

    return recommendations;
  }

  // Quick test for development
  static Future<void> quickTest() async {
    print('🚀 Running quick API test...');

    try {
      final results = await runComprehensiveTest();
      final summary = results['summary'] as Map<String, dynamic>;

      print('📊 Test Results:');
      print('   Success Rate: ${summary['success_rate']}');
      print('   Status: ${summary['overall_status']}');
      print('   Working Features: ${summary['working_features']}');

      if (summary['issues'].isNotEmpty) {
        print('   Issues: ${summary['issues']}');
      }

      print('   Recommendations: ${summary['recommendations']}');
    } catch (e) {
      print('❌ Test failed: $e');
    }
  }

  // Automatically fetch land 1 data (using available soil data endpoints)
  static Future<Map<String, dynamic>?> fetchLand1Data() async {
    print('🏞️ Fetching soil data automatically (as land 1 data)...');

    try {
      // Try to get latest soil data first
      final response = await http.get(
        Uri.parse('https://backend-krisi.onrender.com/soildata/latest'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Latest soil data fetched successfully: $data');
        return {
          'status': 'success',
          'data': data,
          'endpoint_used': 'soildata/latest',
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        print('❌ Latest soil data not available, trying all soil data...');

        // Fallback to get all soil data
        final allResponse = await http.get(
          Uri.parse('https://backend-krisi.onrender.com/soildata/all'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (allResponse.statusCode == 200) {
          final allData = jsonDecode(allResponse.body);
          print('✅ All soil data fetched successfully: $allData');
          return {
            'status': 'success',
            'data': allData,
            'endpoint_used': 'soildata/all',
            'timestamp': DateTime.now().toIso8601String(),
          };
        } else {
          print('❌ Failed to fetch soil data: ${allResponse.statusCode}');
          return {
            'status': 'error',
            'error': 'HTTP ${allResponse.statusCode}',
            'timestamp': DateTime.now().toIso8601String(),
          };
        }
      }
    } catch (e) {
      print('❌ Error fetching soil data: $e');
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}
