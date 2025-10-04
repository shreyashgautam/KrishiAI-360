import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/soil_data.dart';
import '../models/land_data.dart' as land_models;
import '../services/enhanced_soil_data_service.dart';
import '../services/land_service.dart';
import '../services/auth_service.dart';

class CropAdviceScreen extends StatefulWidget {
  const CropAdviceScreen({super.key});

  @override
  State<CropAdviceScreen> createState() => _CropAdviceScreenState();
}

class _CropAdviceScreenState extends State<CropAdviceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nController = TextEditingController();
  final _pController = TextEditingController();
  final _kController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _phController = TextEditingController();
  final _rainfallController = TextEditingController();
  final _soilMoistureController = TextEditingController();
  final _farmSizeController = TextEditingController(text: '2.0');
  final _locationController = TextEditingController();

  bool _isLoading = false;
  CropPrediction? _prediction;
  bool _showSensorData = false;

  // Mode selection
  bool _isSensorMode = true; // true = Sensor Mode, false = Local Mode

  // Land selection variables
  List<land_models.LandData> _farmerLands = [];
  land_models.LandData? _selectedLand;
  final LandService _landService = LandService();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _fetchFarmerLands();
  }

  Future<void> _fetchFarmerLands() async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final lands = await _landService.getFarmerLands(currentUser.uid);
        setState(() {
          _farmerLands =
              lands.where((land) => land.status == 'approved').toList();
          // Auto-select the first land with sensor data
          final landsWithSensorData =
              _farmerLands.where((land) => land.sensorData != null).toList();
          if (landsWithSensorData.isNotEmpty) {
            _selectedLand = landsWithSensorData.first;

            // Update form fields with real sensor data (only in Sensor Mode)
            if (_isSensorMode && _selectedLand!.sensorData != null) {
              _nController.text = _selectedLand!.sensorData!.n.toString();
              _pController.text = _selectedLand!.sensorData!.p.toString();
              _kController.text = _selectedLand!.sensorData!.k.toString();
              _temperatureController.text =
                  _selectedLand!.sensorData!.temperature.toString();
              _humidityController.text =
                  _selectedLand!.sensorData!.humidity.toString();
              _phController.text = _selectedLand!.sensorData!.ph.toString();
              _rainfallController.text =
                  _selectedLand!.sensorData!.rainfall.toString();
              _soilMoistureController.text =
                  _selectedLand!.sensorData!.soilMoisture.toString();
            }
          }
        });
        print('Fetched ${_farmerLands.length} approved lands');
        print(
            'Lands with sensor data: ${_farmerLands.where((land) => land.sensorData != null).length}');
      } else {
        // Use mock data for testing when no user is logged in
        final lands = await _landService.getFarmerLands('farmer_001');
        setState(() {
          _farmerLands =
              lands.where((land) => land.status == 'approved').toList();
          // Auto-select the first land with sensor data
          final landsWithSensorData =
              _farmerLands.where((land) => land.sensorData != null).toList();
          if (landsWithSensorData.isNotEmpty) {
            _selectedLand = landsWithSensorData.first;

            // Update form fields with real sensor data (only in Sensor Mode)
            if (_isSensorMode && _selectedLand!.sensorData != null) {
              _nController.text = _selectedLand!.sensorData!.n.toString();
              _pController.text = _selectedLand!.sensorData!.p.toString();
              _kController.text = _selectedLand!.sensorData!.k.toString();
              _temperatureController.text =
                  _selectedLand!.sensorData!.temperature.toString();
              _humidityController.text =
                  _selectedLand!.sensorData!.humidity.toString();
              _phController.text = _selectedLand!.sensorData!.ph.toString();
              _rainfallController.text =
                  _selectedLand!.sensorData!.rainfall.toString();
              _soilMoistureController.text =
                  _selectedLand!.sensorData!.soilMoisture.toString();
            }
          }
        });
        print('Using mock data: ${_farmerLands.length} approved lands');
      }
    } catch (e) {
      print('Error fetching farmer lands: $e');
    }
  }

  Future<void> _refreshSensorData() async {
    if (_selectedLand == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Refresh the selected land's sensor data
      final updatedLand = await _landService.getLandDetails(_selectedLand!.id);
      setState(() {
        _selectedLand = updatedLand;

        // Update form fields with the new sensor data (only in Sensor Mode)
        if (_isSensorMode && updatedLand.sensorData != null) {
          _nController.text = updatedLand.sensorData!.n.toString();
          _pController.text = updatedLand.sensorData!.p.toString();
          _kController.text = updatedLand.sensorData!.k.toString();
          _temperatureController.text =
              updatedLand.sensorData!.temperature.toString();
          _humidityController.text =
              updatedLand.sensorData!.humidity.toString();
          _phController.text = updatedLand.sensorData!.ph.toString();
          _rainfallController.text =
              updatedLand.sensorData!.rainfall.toString();
          _soilMoistureController.text =
              updatedLand.sensorData!.soilMoisture.toString();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('sensor_data_refreshed'.tr()),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error refreshing sensor data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'failed_refresh_sensor'.tr()}: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
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
      SoilData soilData;

      // Use sensor data if in sensor mode and available
      if (_isSensorMode &&
          _selectedLand != null &&
          _selectedLand!.sensorData != null) {
        final sensorData = _selectedLand!.sensorData!;
        // Use sensor data for available fields, use form data for missing fields
        soilData = SoilData(
          n: double.parse(_nController.text), // Keep manual input for nutrients
          p: double.parse(_pController.text),
          k: double.parse(_kController.text),
          temperature: sensorData.temperature,
          humidity: sensorData.humidity,
          ph: sensorData.ph,
          rainfall: double.parse(
              _rainfallController.text), // Keep manual input for rainfall
          soilMoistureAvg: sensorData.soilMoisture,
        );

        // Update form fields with sensor data for display
        _temperatureController.text = sensorData.temperature.toString();
        _humidityController.text = sensorData.humidity.toString();
        _phController.text = sensorData.ph.toString();
        _soilMoistureController.text = sensorData.soilMoisture.toString();
      } else {
        // Use manual input data
        soilData = SoilData(
          n: double.parse(_nController.text),
          p: double.parse(_pController.text),
          k: double.parse(_kController.text),
          temperature: double.parse(_temperatureController.text),
          humidity: double.parse(_humidityController.text),
          ph: double.parse(_phController.text),
          rainfall: double.parse(_rainfallController.text),
          soilMoistureAvg: double.parse(_soilMoistureController.text),
        );
      }

      CropPrediction? prediction;
      // Always use API for predictions
      prediction = await EnhancedSoilDataService.getCropPrediction(soilData);

      setState(() {
        _prediction = prediction;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isSensorMode
              ? 'Crop recommendation generated using sensor data from ${_selectedLand!.name}!'
              : 'Crop recommendation generated using manual input!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'error'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSensorDataItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crop_advice'.tr()),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshSensorData,
            tooltip: 'Refresh Sensor Data',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sensor Connection Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.sensors,
                          color: _selectedLand?.sensorData != null
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sensor Connection',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _selectedLand?.sensorData != null
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedLand?.sensorData != null
                                  ? Colors.green
                                  : Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _selectedLand?.sensorData != null
                                ? 'Connected'
                                : 'Disconnected',
                            style: TextStyle(
                              color: _selectedLand?.sensorData != null
                                  ? Colors.green
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Eye button to show/hide sensor data
                    if (_selectedLand?.sensorData != null)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showSensorData = !_showSensorData;
                              });
                            },
                            icon: Icon(
                              _showSensorData
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue,
                            ),
                            tooltip: _showSensorData
                                ? 'Hide sensor data'
                                : 'Show sensor data',
                          ),
                          Text(
                            'View Sensor Data',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    // Sensor Data Dropdown
                    if (_showSensorData && _selectedLand?.sensorData != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📡 Live Sensor Data from ${_selectedLand!.name}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _refreshSensorData,
                                  icon: Icon(Icons.refresh, color: Colors.blue),
                                  tooltip: 'Refresh sensor data',
                                ),
                                Text(
                                    'Last Update: ${_selectedLand!.sensorData!.lastUpdated}'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              runSpacing: 8,
                              children: [
                                _buildSensorDataItem(
                                    'N (Nitrogen)',
                                    '${_selectedLand!.sensorData!.n} ppm',
                                    Colors.blue),
                                _buildSensorDataItem(
                                    'P (Phosphorus)',
                                    '${_selectedLand!.sensorData!.p} ppm',
                                    Colors.orange),
                                _buildSensorDataItem(
                                    'K (Potassium)',
                                    '${_selectedLand!.sensorData!.k} ppm',
                                    Colors.purple),
                                _buildSensorDataItem(
                                    'Temperature',
                                    '${_selectedLand!.sensorData!.temperature}°C',
                                    Colors.red),
                                _buildSensorDataItem(
                                    'Humidity',
                                    '${_selectedLand!.sensorData!.humidity}%',
                                    Colors.cyan),
                                _buildSensorDataItem(
                                    'pH Level',
                                    '${_selectedLand!.sensorData!.ph}',
                                    Colors.green),
                                _buildSensorDataItem(
                                    'Rainfall',
                                    '${_selectedLand!.sensorData!.rainfall}mm',
                                    Colors.indigo),
                                _buildSensorDataItem(
                                    'Soil Moisture',
                                    '${_selectedLand!.sensorData!.soilMoisture}%',
                                    Colors.brown),
                              ],
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    // Single Mode Toggle
                    Row(
                      children: [
                        Text('${'mode'.tr()}:'),
                        const SizedBox(width: 8),
                        Switch(
                          value: _isSensorMode,
                          onChanged: (value) {
                            setState(() {
                              _isSensorMode = value;
                              if (!value) {
                                // Clear form fields when switching to Local Mode
                                _nController.clear();
                                _pController.clear();
                                _kController.clear();
                                _temperatureController.clear();
                                _humidityController.clear();
                                _phController.clear();
                                _rainfallController.clear();
                                _soilMoistureController.clear();
                                _selectedLand = null;
                              } else {
                                // When switching to Sensor Mode, fetch sensor data
                                _fetchFarmerLands();
                              }
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(_isSensorMode
                            ? 'sensor_mode'.tr()
                            : 'local_mode'.tr()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sensor Data Selection Card (only show in Sensor Mode)
            if (_isSensorMode && _farmerLands.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sensor Data from Approved Lands',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Land selection - Simple button approach
                      Text(
                        'Select Land:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _farmerLands
                                .where((land) => land.sensorData != null)
                                .isNotEmpty
                            ? Text(
                                _selectedLand?.name ?? 'Land 1',
                                style: const TextStyle(fontSize: 16),
                              )
                            : const Text(
                                'No lands with sensor data available',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // No approved lands message (only in Sensor Mode)
            if (_isSensorMode && _farmerLands.isEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 48,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No Approved Lands Available',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You need to register and get approval for your lands to use sensor data for crop recommendations.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to land management screen
                          Navigator.pushNamed(context, '/land-management');
                        },
                        icon: const Icon(Icons.add),
                        label: Text('register_land'.tr()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Soil Data Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Soil Data Input',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          if (_isSensorMode &&
                              _selectedLand != null &&
                              _selectedLand!.sensorData != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.green.shade300),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sensors,
                                      size: 16, color: Colors.green.shade700),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Auto-filled from API',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
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
                  ? Text('analyzing'.tr())
                  : Text('get_crop_recommendation'.tr()),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🌱 Recommended Crop:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _prediction!.cropName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Confidence
                      Text(
                        '📊 Confidence: ${_prediction!.confidence.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 16,
                        ),
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
