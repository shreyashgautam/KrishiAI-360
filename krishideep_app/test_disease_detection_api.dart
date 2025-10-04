import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Test script to verify the disease detection API integration
/// This script tests the API endpoint directly to ensure it's working correctly
void main() async {
  print('🧪 Testing Disease Detection API Integration');
  print('==========================================');

  // Test API endpoint availability
  await testApiEndpoint();

  // Test with a sample image (if available)
  await testWithSampleImage();
}

Future<void> testApiEndpoint() async {
  print('\n1. Testing API endpoint availability...');

  try {
    // Test basic connectivity to the API endpoint
    final response = await http
        .get(
          Uri.parse('https://backend-krisi-ml-crophealth.onrender.com/'),
        )
        .timeout(const Duration(seconds: 10));

    print('✅ API endpoint is reachable');
    print('   Status Code: ${response.statusCode}');
    print('   Response Headers: ${response.headers}');

    if (response.statusCode == 200) {
      print('   Response Body: ${response.body.substring(0, 100)}...');
    }
  } catch (e) {
    print('❌ API endpoint test failed: $e');
  }
}

Future<void> testWithSampleImage() async {
  print('\n2. Testing with sample image...');

  // Create a simple test image file (1x1 pixel PNG)
  final testImageBytes = _createTestImage();
  final testFile = File('test_image.png');
  await testFile.writeAsBytes(testImageBytes);

  try {
    print('   Created test image: ${testFile.path}');
    print('   Image size: ${await testFile.length()} bytes');

    // Test the actual API call
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://backend-krisi-ml-crophealth.onrender.com/predict'),
    );

    request.files.add(await http.MultipartFile.fromPath(
      'file',
      testFile.path,
    ));

    print('   Sending request to API...');
    var response = await request.send().timeout(
          const Duration(seconds: 30),
        );

    print('   Response Status: ${response.statusCode}');
    print('   Response Headers: ${response.headers}');

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      print('   ✅ API call successful!');
      print('   Response: $responseBody');

      // Try to parse the JSON response
      try {
        var jsonResponse = json.decode(responseBody);
        print('   Parsed JSON: $jsonResponse');

        // Check for expected fields
        if (jsonResponse.containsKey('disease_name') ||
            jsonResponse.containsKey('diseaseName')) {
          print('   ✅ Response contains disease information');
        } else {
          print('   ⚠️  Response may not contain expected disease fields');
        }
      } catch (e) {
        print('   ⚠️  Could not parse JSON response: $e');
      }
    } else {
      var errorBody = await response.stream.bytesToString();
      print('   ❌ API call failed');
      print('   Error Response: $errorBody');
    }
  } catch (e) {
    print('   ❌ Test failed: $e');
  } finally {
    // Clean up test file
    if (await testFile.exists()) {
      await testFile.delete();
      print('   Cleaned up test file');
    }
  }
}

/// Create a minimal test PNG image (1x1 pixel)
List<int> _createTestImage() {
  // This is a minimal 1x1 pixel PNG in bytes
  return [
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
    0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
    0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 dimensions
    0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77,
    0x53, // bit depth, color type, etc.
    0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, // IDAT chunk
    0x54, 0x08, 0x99, 0x01, 0x01, 0x00, 0x00, 0x00, // compressed data
    0xFF, 0xFF, 0x00, 0x00, 0x00, 0x02, 0x00, 0x01, // image data
    0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, // IEND chunk
    0xAE, 0x42, 0x60, 0x82
  ];
}
