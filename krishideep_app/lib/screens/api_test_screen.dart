import 'package:flutter/material.dart';
import '../services/api_test_service.dart';
import '../services/enhanced_soil_data_service.dart';
import '../models/soil_data.dart';

class APITestScreen extends StatefulWidget {
  const APITestScreen({super.key});

  @override
  State<APITestScreen> createState() => _APITestScreenState();
}

class _APITestScreenState extends State<APITestScreen> {
  bool _isLoading = false;
  Map<String, dynamic>? _testResults;
  Map<String, dynamic>? _land1Data;
  String _status = 'Ready to test';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test & CORS Debug'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: _getStatusColor(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Test Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _runQuickTest,
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Quick Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _runFullTest,
                    icon: const Icon(Icons.science),
                    label: const Text('Full Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Test Results
            if (_testResults != null) ...[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Test Results',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Flexible(
                          child: SingleChildScrollView(
                            child: _buildTestResults(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Land 1 Data Display
            if (_land1Data != null) ...[
              const SizedBox(height: 20),
              Card(
                color: Colors.teal.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.landscape, color: Colors.teal.shade700),
                          const SizedBox(width: 8),
                          const Text(
                            'Land 1 Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.teal.shade200),
                        ),
                        child: _buildLand1DataDisplay(),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Quick Actions
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testCropPrediction,
                            icon: const Icon(Icons.eco),
                            label: const Text('Test Prediction'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testSoilDataInsert,
                            icon: const Icon(Icons.save),
                            label: const Text('Test Insert'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _fetchLand1Data,
                            icon: const Icon(Icons.landscape),
                            label: const Text('Fetch Land 1 Data'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResults() {
    if (_testResults == null) return const SizedBox();

    final summary = _testResults!['summary'] as Map<String, dynamic>?;
    final tests = _testResults!['tests'] as Map<String, dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        if (summary != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getSummaryColor(summary['overall_status']),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Status: ${summary['overall_status']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Success Rate: ${summary['success_rate']}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Working Features: ${summary['working_features'].length}',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Individual Test Results
        if (tests != null) ...[
          const Text(
            'Individual Tests:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...tests.entries
              .map((entry) => _buildTestCard(entry.key, entry.value)),
        ],

        // Recommendations
        if (summary?['recommendations'] != null) ...[
          const SizedBox(height: 16),
          const Text(
            'Recommendations:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...(summary!['recommendations'] as List).map(
            (rec) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• $rec'),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTestCard(String testName, Map<String, dynamic> result) {
    final isSuccess = result['status'] == 'success';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: isSuccess ? Colors.green : Colors.red,
        ),
        title: Text(testName.replaceAll('_', ' ').toUpperCase()),
        subtitle: Text(
          isSuccess ? 'Success' : result['error'] ?? 'Unknown error',
        ),
        trailing: isSuccess
            ? const Icon(Icons.check, color: Colors.green)
            : const Icon(Icons.close, color: Colors.red),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isLoading) return Colors.orange;
    if (_testResults != null) {
      final summary = _testResults!['summary'] as Map<String, dynamic>?;
      final status = summary?['overall_status'] as String?;
      if (status == 'Good') return Colors.green;
      if (status == 'Fair') return Colors.orange;
      return Colors.red;
    }
    return Colors.blue;
  }

  IconData _getStatusIcon() {
    if (_isLoading) return Icons.hourglass_empty;
    if (_testResults != null) {
      final summary = _testResults!['summary'] as Map<String, dynamic>?;
      final status = summary?['overall_status'] as String?;
      if (status == 'Good') return Icons.check_circle;
      if (status == 'Fair') return Icons.warning;
      return Icons.error;
    }
    return Icons.play_arrow;
  }

  Color _getSummaryColor(String? status) {
    switch (status) {
      case 'Good':
        return Colors.green;
      case 'Fair':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _runQuickTest() async {
    setState(() {
      _isLoading = true;
      _status = 'Running quick test...';
    });

    try {
      await APITestService.quickTest();
      setState(() {
        _status = 'Quick test completed';
      });
    } catch (e) {
      setState(() {
        _status = 'Quick test failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _runFullTest() async {
    setState(() {
      _isLoading = true;
      _status = 'Running comprehensive test...';
    });

    try {
      final results = await APITestService.runComprehensiveTest();
      setState(() {
        _testResults = results;
        final summary = results['summary'] as Map<String, dynamic>;
        _status = 'Test completed - ${summary['overall_status']}';
      });
    } catch (e) {
      setState(() {
        _status = 'Test failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testCropPrediction() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing crop prediction...';
    });

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

      final prediction =
          await EnhancedSoilDataService.getCropPrediction(soilData);

      setState(() {
        _status = prediction != null
            ? 'Prediction: ${prediction.cropName}'
            : 'Prediction failed';
      });

      if (prediction != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Crop: ${prediction.cropName} (${prediction.confidence}% confidence)'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = 'Prediction error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSoilDataInsert() async {
    setState(() {
      _isLoading = true;
      _status = 'Testing soil data insert...';
    });

    try {
      final soilData = SoilData(
        n: 50.0,
        p: 30.0,
        k: 20.0,
        temperature: 25.5,
        humidity: 70.2,
        ph: 6.5,
        rainfall: 120.3,
        soilMoistureAvg: 35.0,
      );

      await EnhancedSoilDataService.insertSoilData(soilData);

      setState(() {
        _status = 'Insert successful';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Soil data inserted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _status = 'Insert error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchLand1Data() async {
    setState(() {
      _isLoading = true;
      _status = 'Fetching land 1 data...';
    });

    try {
      final result = await APITestService.fetchLand1Data();

      setState(() {
        _land1Data = result;
        if (result != null && result['status'] == 'success') {
          _status = 'Land 1 data fetched successfully';
        } else {
          _status = 'Failed to fetch land 1 data';
        }
      });

      if (result != null && result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Land 1 data fetched successfully!'),
            backgroundColor: Colors.teal,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to fetch land 1 data: ${result?['error'] ?? 'Unknown error'}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _status = 'Land 1 fetch error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildLand1DataDisplay() {
    if (_land1Data == null) return const SizedBox();

    final data = _land1Data!['data'];
    if (data == null) {
      return Text(
        'Error: ${_land1Data!['error'] ?? 'Unknown error'}',
        style: const TextStyle(color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fetched at: ${_land1Data!['timestamp'] ?? 'Unknown time'}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Land Data:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.teal.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            data.toString(),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
