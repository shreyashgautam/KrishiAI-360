import 'package:flutter/material.dart';
import '../models/soil_data.dart';
import '../services/soil_data_service.dart';
import '../services/enhanced_soil_data_service.dart';

class EnhancedCropAdviceScreen extends StatefulWidget {
  const EnhancedCropAdviceScreen({super.key});

  @override
  State<EnhancedCropAdviceScreen> createState() =>
      _EnhancedCropAdviceScreenState();
}

class _EnhancedCropAdviceScreenState extends State<EnhancedCropAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController(text: '50.0');
  final _pController = TextEditingController(text: '30.0');
  final _kController = TextEditingController(text: '20.0');
  final _temperatureController = TextEditingController(text: '25.5');
  final _humidityController = TextEditingController(text: '70.2');
  final _phController = TextEditingController(text: '6.5');
  final _rainfallController = TextEditingController(text: '120.3');
  final _soilMoistureController = TextEditingController(text: '35.0');
  final _farmSizeController = TextEditingController(text: '2.0');
  final _locationController = TextEditingController();

  bool _isLoading = false;
  bool _useAPI = true;
  String _connectionStatus = 'Not tested';
  CropPrediction? _prediction;

  @override
  void initState() {
    super.initState();
    _testAPIConnection();
  }

  Future<void> _testAPIConnection() async {
    setState(() {
      _connectionStatus = 'Testing...';
    });

    try {
      final testResults = await EnhancedSoilDataService.testConnection();
      setState(() {
        _connectionStatus =
            EnhancedSoilDataService.getConnectionStatus(testResults);
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'CORS Issue - Using Local Mode';
      });
    }
  }

  Future<void> _getCropRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _prediction = null;
    });

    try {
      // Create soil data
      final soilData = SoilData(
        n: double.parse(_nController.text),
        p: double.parse(_pController.text),
        k: double.parse(_kController.text),
        temperature: double.parse(_temperatureController.text),
        humidity: double.parse(_humidityController.text),
        ph: double.parse(_phController.text),
        rainfall: double.parse(_rainfallController.text),
        soilMoistureAvg: double.parse(_soilMoistureController.text),
      );

      CropPrediction? prediction;
      if (_useAPI) {
        prediction = await EnhancedSoilDataService.getCropPrediction(soilData);
      } else {
        // Use fallback prediction
        prediction = SoilDataService.getFallbackPrediction(soilData);
      }

      setState(() {
        _prediction = prediction;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Crop recommendation generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Crop Advice'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _testAPIConnection,
            tooltip: 'Test API Connection',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // API Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ML API Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _connectionStatus.contains('Connected')
                              ? Icons.check_circle
                              : _connectionStatus.contains('CORS') ||
                                      _connectionStatus.contains('Blocked')
                                  ? Icons.warning
                                  : Icons.error,
                          color: _connectionStatus.contains('Connected')
                              ? Colors.green
                              : _connectionStatus.contains('CORS') ||
                                      _connectionStatus.contains('Blocked')
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(_connectionStatus),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Use API:'),
                        const SizedBox(width: 8),
                        Switch(
                          value: _useAPI,
                          onChanged: (value) {
                            setState(() {
                              _useAPI = value;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(_useAPI ? 'API Mode' : 'Local Mode'),
                      ],
                    ),
                    if (_connectionStatus.contains('CORS') ||
                        _connectionStatus.contains('Blocked'))
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Note: API access is blocked by CORS policy. Using intelligent local recommendations based on your soil data.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.orange.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Soil Data Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Soil Data Input',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Nutrients
                      Text(
                        'Nutrients (ppm)',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nController,
                              decoration: const InputDecoration(
                                labelText: 'Nitrogen (N)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter nitrogen value';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _pController,
                              decoration: const InputDecoration(
                                labelText: 'Phosphorus (P)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phosphorus value';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _kController,
                              decoration: const InputDecoration(
                                labelText: 'Potassium (K)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter potassium value';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Environmental Factors
                      Text(
                        'Environmental Factors',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _temperatureController,
                              decoration: const InputDecoration(
                                labelText: 'Temperature (°C)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter temperature';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _humidityController,
                              decoration: const InputDecoration(
                                labelText: 'Humidity (%)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter humidity';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _phController,
                              decoration: const InputDecoration(
                                labelText: 'pH Level',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter pH';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _rainfallController,
                              decoration: const InputDecoration(
                                labelText: 'Rainfall (mm)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter rainfall';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _soilMoistureController,
                              decoration: const InputDecoration(
                                labelText: 'Soil Moisture (%)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter soil moisture';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _farmSizeController,
                              decoration: const InputDecoration(
                                labelText: 'Farm Size (acres)',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter farm size';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location (Optional)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Get Recommendation Button
            ElevatedButton(
              onPressed: _isLoading ? null : _getCropRecommendation,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 16),
                        Text('Analyzing...'),
                      ],
                    )
                  : const Text('Get Crop Recommendation'),
            ),

            const SizedBox(height: 16),

            // Results
            if (_prediction != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation Results',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Recommended Crop
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.eco, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Recommended Crop:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                  Text(
                                    _prediction!.cropName,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confidence
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            'Confidence: ${_prediction!.confidence.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Description
                      if (_prediction!.description != null) ...[
                        Text(
                          'Description:',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _prediction!.description!,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _phController.dispose();
    _rainfallController.dispose();
    _soilMoistureController.dispose();
    _farmSizeController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
