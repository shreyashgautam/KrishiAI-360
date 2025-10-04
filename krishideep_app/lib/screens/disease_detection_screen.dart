import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/crop_service.dart';
import '../models/disease_detection.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final CropService _cropService = CropService();
  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;
  bool _isAnalyzing = false;
  DiseaseDetectionResult? _result;
  List<String> _debugLogs = [];
  bool _showDebugPanel = false;

  void _addDebugLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    final logMessage = '[$timestamp] $message';
    setState(() {
      _debugLogs.add(logMessage);
      if (_debugLogs.length > 50) {
        _debugLogs.removeAt(0); // Keep only last 50 logs
      }
    });
    print('🔍 DEBUG: $message');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crop_disease_detection'.tr()),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
                _showDebugPanel ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: () {
              setState(() {
                _showDebugPanel = !_showDebugPanel;
              });
            },
            tooltip: 'toggle_debug_panel'.tr(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade700, Colors.green.shade50],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'crop_disease_detection'.tr(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'upload_photo_description'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Image Display Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        if (_selectedImage == null)
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'no_image_selected'.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Camera/Upload Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _pickImage(ImageSource.camera),
                                icon: const Icon(Icons.camera_alt),
                                label: Text('take_photo'.tr()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.photo_library),
                                label: Text('upload_image'.tr()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (_selectedImage != null) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isAnalyzing ? null : _analyzeImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                foregroundColor: Colors.white,
                              ),
                              child: _isAnalyzing
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text('analyzing_with_ai'.tr()),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.analytics),
                                        const SizedBox(width: 8),
                                        Text('analyze_disease'.tr()),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Results Card
                if (_result != null) ...[
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _result!.diseaseName == 'healthy_plant'.tr()
                                    ? Icons.check_circle
                                    : Icons.warning,
                                color:
                                    _result!.diseaseName == 'healthy_plant'.tr()
                                        ? Colors.green
                                        : Colors.orange,
                                size: 32,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'disease_detection_result'.tr(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${'confidence_label'.tr()}: ${_result!.confidence.toStringAsFixed(1)}%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Disease Name
                          Text(
                            _result!.diseaseName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _result!.diseaseNameHindi,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Description
                          Text(
                            _result!.description,
                            style: const TextStyle(fontSize: 14),
                          ),

                          if (_result!.diseaseName != 'healthy_plant'.tr()) ...[
                            const SizedBox(height: 16),

                            // Severity
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getSeverityColor(
                                  _result!.severity,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${'severity_label'.tr()}: ${_result!.severity}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getSeverityColor(_result!.severity),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Treatments
                            _buildSection(
                                'treatments'.tr(), _result!.treatments),

                            const SizedBox(height: 16),

                            // Prevention
                            _buildSection(
                                'prevention'.tr(), _result!.prevention),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Info Card
                Card(
                  color: Colors.blue.shade50,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'ai_detection_info'.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Debug Panel
                if (_showDebugPanel) ...[
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.grey.shade900,
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bug_report,
                                  color: Colors.green.shade400),
                              const SizedBox(width: 8),
                              Text(
                                'debug_logs'.tr(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade400,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.clear,
                                    color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _debugLogs.clear();
                                  });
                                },
                                tooltip: 'clear_logs'.tr(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade700),
                            ),
                            child: _debugLogs.isEmpty
                                ? Center(
                                    child: Text(
                                      'no_debug_logs'.tr(),
                                      style: TextStyle(
                                          color: Colors.grey.shade400),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: _debugLogs.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          _debugLogs[index],
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.green.shade700)),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'mild':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'severe':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _pickImage(ImageSource source) async {
    _addDebugLog('Starting image picker with source: $source');
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        _addDebugLog('Image selected successfully');
        _addDebugLog('Image path: ${image.path}');
        _addDebugLog('Image name: ${image.name}');
        _addDebugLog('Image size: ${await image.length()} bytes');

        setState(() {
          _selectedImage = File(image.path);
          _result = null; // Clear previous results
        });

        _addDebugLog(
            'Image state updated, _selectedImage set to: ${_selectedImage!.path}');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('image_selected_successfully'.tr()),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _addDebugLog('No image selected (user cancelled)');
      }
    } catch (e) {
      _addDebugLog('Image picker failed with error: $e');
      _addDebugLog('Error type: ${e.runtimeType}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'failed_to_pick_image'.tr()}: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _analyzeImage() async {
    if (_selectedImage == null) {
      _addDebugLog('No image selected for analysis');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('please_select_image_first'.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _addDebugLog('Starting disease detection analysis...');
    _addDebugLog('Selected image path: ${_selectedImage!.path}');
    _addDebugLog('Image exists: ${await _selectedImage!.exists()}');
    _addDebugLog('Image size: ${await _selectedImage!.length()} bytes');

    setState(() {
      _isAnalyzing = true;
    });

    try {
      _addDebugLog('Calling cropService.detectDisease()...');
      _addDebugLog(
          'API endpoint: https://backend-krisi-ml-crophealth.onrender.com/predict');
      _addDebugLog('Using form data with key: file');
      _addDebugLog('This may take 30-60 seconds for ML processing...');

      final result = await _cropService.detectDisease(_selectedImage!);

      _addDebugLog('Disease detection completed successfully!');
      _addDebugLog('Result - Disease: ${result.diseaseName}');
      _addDebugLog('Result - Confidence: ${result.confidence}%');
      _addDebugLog('Result - Severity: ${result.severity}');
      _addDebugLog(
          'Result - Treatments: ${result.treatments.length} treatments');

      setState(() {
        _result = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'analysis_completed'.tr()}: ${result.diseaseName}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      _addDebugLog('Disease detection failed with error: $e');
      _addDebugLog('Error type: ${e.runtimeType}');
      _addDebugLog('Stack trace: ${StackTrace.current}');

      // Show detailed error message to user
      String errorMessage = 'analysis_failed'.tr();
      if (e.toString().contains('timeout') ||
          e.toString().contains('TimeoutException')) {
        errorMessage = 'request_timed_out'.tr();
      } else if (e.toString().contains('status: 500')) {
        errorMessage = 'server_error'.tr();
      } else if (e.toString().contains('status: 404')) {
        errorMessage = 'api_endpoint_not_found'.tr();
      } else if (e.toString().contains('status: 400')) {
        errorMessage = 'invalid_request'.tr();
      } else if (e.toString().contains('Connection refused') ||
          e.toString().contains('Failed host lookup')) {
        errorMessage = 'cannot_connect_server'.tr();
      } else {
        errorMessage = '${'analysis_failed'.tr()}: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      _addDebugLog('Analysis process completed, setting _isAnalyzing to false');
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
}
