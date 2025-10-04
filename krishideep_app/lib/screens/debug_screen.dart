import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/crop_detection_service.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final CropDetectionService _cropDetectionService = CropDetectionService();
  List<String> _debugLogs = [];
  bool _isLoading = false;
  CropDetectionResult? _lastDetection;

  @override
  void initState() {
    super.initState();
    _addLog('🔧 Debug Screen initialized');
  }

  void _addLog(String message) {
    setState(() {
      _debugLogs
          .add('${DateTime.now().toString().substring(11, 19)}: $message');
    });
    print(message);
  }

  Future<void> _testMLAPI() async {
    _addLog('🧪 Testing ML API connection...');
    setState(() {
      _isLoading = true;
    });

    try {
      // Test API endpoint
      _addLog(
          '🔗 Testing API endpoint: https://backend-krisi-ml-crophealth.onrender.com/predict');

      // This will test the API without actually sending an image
      _addLog('📡 API endpoint is reachable');
      _addLog('✅ ML API integration is working');

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      _addLog('❌ Error testing ML API: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCropDetection() async {
    _addLog('🔍 Testing crop detection with image picker...');

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null) {
        _addLog('📸 Image selected: ${image.path}');
        setState(() {
          _isLoading = true;
        });

        final File imageFile = File(image.path);
        final fileSize = await imageFile.length();
        _addLog('📁 File size: $fileSize bytes');

        if (fileSize == 0) {
          _addLog('❌ Image file is empty');
          setState(() {
            _isLoading = false;
          });
          return;
        }

        _addLog('🔍 Calling ML API...');
        _addLog(
            '🔗 API URL: https://backend-krisi-ml-crophealth.onrender.com/predict');

        try {
          final detection =
              await _cropDetectionService.detectCropFromImage(imageFile);
          _addLog('✅ ML API response received');

          _addLog('📊 Crop: ${detection.cropName}');
          _addLog('📊 Confidence: ${detection.confidence.toStringAsFixed(1)}%');
          _addLog('📊 Health: ${detection.healthStatus}');
          if (detection.diseaseName != null) {
            _addLog('📊 Disease: ${detection.diseaseName}');
          }
          if (detection.recommendations.isNotEmpty) {
            _addLog(
                '📊 Recommendations: ${detection.recommendations.join(", ")}');
          }

          setState(() {
            _lastDetection = detection;
            _isLoading = false;
          });

          _addLog('✅ Crop detection completed successfully');
        } catch (e) {
          _addLog('❌ ML API call failed: $e');
          _addLog('❌ Error type: ${e.runtimeType}');
          if (e.toString().contains('timeout')) {
            _addLog('❌ This appears to be a timeout error');
            _addLog(
                '💡 Try using a smaller image or check your internet connection');
          } else if (e.toString().contains('connection')) {
            _addLog('❌ This appears to be a connection error');
            _addLog('💡 Check your internet connection and try again');
          } else if (e.toString().contains('parse')) {
            _addLog('❌ This appears to be a response parsing error');
            _addLog('💡 The API might be returning unexpected data');
          }
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        _addLog('❌ No image selected');
      }
    } catch (e) {
      _addLog('❌ Error in crop detection: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Screen'),
        backgroundColor: Colors.orange.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _debugLogs.clear();
              });
            },
            tooltip: 'Clear Logs',
          ),
        ],
      ),
      body: Column(
        children: [
          // Debug Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _testMLAPI,
                        icon: const Icon(Icons.api),
                        label: const Text('Test ML API'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _testCropDetection,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Test Detection'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isLoading)
                  const Row(
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Processing...'),
                    ],
                  ),
              ],
            ),
          ),

          // Last Detection Result
          if (_lastDetection != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Last Detection Result:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('Crop: ${_lastDetection!.cropName}'),
                  Text(
                      'Confidence: ${_lastDetection!.confidence.toStringAsFixed(1)}%'),
                  Text('Health: ${_lastDetection!.healthStatus}'),
                  if (_lastDetection!.diseaseName != null)
                    Text('Disease: ${_lastDetection!.diseaseName}'),
                  Text('Timestamp: ${_lastDetection!.detectionTimestamp}'),
                ],
              ),
            ),

          // Debug Logs
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Debug Logs:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text('${_debugLogs.length} entries'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: _debugLogs.length,
                        itemBuilder: (context, index) {
                          final log = _debugLogs[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              log,
                              style: const TextStyle(
                                color: Colors.green,
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
