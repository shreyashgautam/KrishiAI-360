import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/iot_sensor_service.dart';
import '../models/iot_sensor.dart';

class IoTDashboardScreen extends StatefulWidget {
  const IoTDashboardScreen({super.key});

  @override
  State<IoTDashboardScreen> createState() => _IoTDashboardScreenState();
}

class _IoTDashboardScreenState extends State<IoTDashboardScreen> {
  final IoTSensorService _iotService = IoTSensorService();
  List<SoilData> _sensorData = [];
  bool _isLoading = true;
  String _error = '';
  DateTime? _lastUpdated;
  static const String _backendUrl = 'https://backend-krisi.onrender.com';

  @override
  void initState() {
    super.initState();
    print('🚀 IoT Dashboard: Screen initialized, starting data load...');
    _loadSensorData();
  }

  Future<void> _loadSensorData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      print('🔄 Loading IoT Dashboard sensor data...');
      print('🔄 IoT Dashboard: Starting data load process...');

      // Try to fetch real sensor data from backend API
      final realSensorData = await _fetchRealSensorData();
      if (realSensorData != null) {
        print('✅ Real sensor data fetched for IoT Dashboard: $realSensorData');

        // Convert API data to SoilData
        final soilData = SoilData(
          sensorId: 'SENSOR_001',
          timestamp: DateTime.now(),
          moistureLevel:
              realSensorData['soil_moisture_avg']?.toDouble() ?? 35.0,
          temperature: realSensorData['temperature']?.toDouble() ?? 25.5,
          humidity: realSensorData['humidity']?.toDouble() ?? 70.2,
          phLevel: realSensorData['ph']?.toDouble() ?? 6.5,
          nitrogen: realSensorData['N']?.toDouble() ?? 50.0,
          phosphorus: realSensorData['P']?.toDouble() ?? 30.0,
          potassium: realSensorData['K']?.toDouble() ?? 20.0,
          location: 'Field 1',
          electricalConductivity: 1.2, // Default value
          organicMatter: 3.5, // Default value
          locationHindi: 'फील्ड 1', // Default value
        );

        setState(() {
          _sensorData = [soilData];
          _lastUpdated = DateTime.now();
          _isLoading = false;
        });

        print('📊 IoT Dashboard Real Data Display:');
        print('   Temperature: ${soilData.temperature}°C');
        print('   Humidity: ${soilData.humidity}%');
        print('   Soil Moisture: ${soilData.moistureLevel}%');
        print('   pH Level: ${soilData.phLevel}');
        print('   Nitrogen: ${soilData.nitrogen} ppm');
        print('   Phosphorus: ${soilData.phosphorus} ppm');
        print('   Potassium: ${soilData.potassium} ppm');
      } else {
        // Fallback to mock data if API fails
        print('⚠️ Using mock data for IoT Dashboard');
        final sensors = await _iotService.getRegisteredSensors();
        final data = <SoilData>[];
        for (String sensorId in sensors) {
          final sensorData = await _iotService.getLatestSoilData(sensorId);
          if (sensorData != null) {
            data.add(sensorData);
          }
        }

        setState(() {
          _sensorData = data;
          _lastUpdated = DateTime.now();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading IoT Dashboard data: $e');
      setState(() {
        _error = 'Failed to load sensor data: $e';
        _isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchRealSensorData() async {
    try {
      print(
          '🔄 IoT Dashboard: Attempting to fetch real sensor data from $_backendUrl/soildata/latest');
      final response = await http.get(
        Uri.parse('$_backendUrl/soildata/latest'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('📡 IoT Dashboard: API Response Status: ${response.statusCode}');
      print('📡 IoT Dashboard: API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Real sensor data fetched for IoT Dashboard: $data');
        return data;
      } else {
        print('❌ Failed to fetch sensor data: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error fetching sensor data: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('iot_dashboard'.tr()),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSensorData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red.shade300),
                      const SizedBox(height: 16),
                      Text(_error, style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadSensorData,
                        child: Text('retry'.tr()),
                      ),
                    ],
                  ),
                )
              : _sensorData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.sensors_off,
                              size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'no_sensor_data'.tr(),
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Last Updated Info
                          if (_lastUpdated != null)
                            Card(
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(Icons.update,
                                        color: Colors.blue.shade600, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Last updated: ${_lastUpdated!.toString().substring(11, 19)}',
                                      style: TextStyle(
                                        color: Colors.blue.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.green.shade300),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.sensors,
                                              color: Colors.green.shade600,
                                              size: 12),
                                          const SizedBox(width: 4),
                                          Text(
                                            'LIVE DATA',
                                            style: TextStyle(
                                              color: Colors.green.shade700,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),

                          // Summary Cards
                          _buildSummaryCards(),
                          const SizedBox(height: 24),

                          // Smart Alerts Section
                          _buildSmartAlerts(),
                          const SizedBox(height: 24),

                          // Sensor Data List
                          Text(
                            'sensor_data'.tr(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),

                          ..._sensorData.map((data) => _buildSensorCard(data)),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildSummaryCards() {
    if (_sensorData.isEmpty) return const SizedBox.shrink();

    final latestData = _sensorData.first;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'moisture'.tr(),
            '${latestData.moistureLevel.toStringAsFixed(1)}%',
            Icons.water_drop,
            Colors.blue,
            latestData.moistureStatus,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'temperature'.tr(),
            '${latestData.temperature.toStringAsFixed(1)}°C',
            Icons.thermostat,
            Colors.orange,
            _getTemperatureStatus(latestData.temperature),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color, String status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              status,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(SoilData data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sensor ${data.sensorId}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _formatTime(data.timestamp),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),

            // Debug info for real data
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                'Real Data: ${data.temperature}°C, ${data.humidity}%, ${data.moistureLevel}%, pH ${data.phLevel}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sensor readings grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _buildReadingItem('moisture'.tr(),
                    '${data.moistureLevel.toStringAsFixed(1)}%', Colors.blue),
                _buildReadingItem('temperature'.tr(),
                    '${data.temperature.toStringAsFixed(1)}°C', Colors.orange),
                _buildReadingItem('humidity'.tr(),
                    '${data.humidity.toStringAsFixed(1)}%', Colors.green),
                _buildReadingItem('ph_level'.tr(),
                    data.phLevel.toStringAsFixed(1), Colors.purple),
                _buildReadingItem('nitrogen'.tr(),
                    '${data.nitrogen.toStringAsFixed(0)} ppm', Colors.red),
                _buildReadingItem('phosphorus'.tr(),
                    '${data.phosphorus.toStringAsFixed(0)} ppm', Colors.teal),
              ],
            ),

            const SizedBox(height: 16),

            // Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  data.location,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
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
            style: TextStyle(fontSize: 10, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  String _getTemperatureStatus(double temperature) {
    if (temperature < 15) return 'Cold';
    if (temperature < 25) return 'Optimal';
    if (temperature < 35) return 'Warm';
    return 'Hot';
  }

  Widget _buildSmartAlerts() {
    if (_sensorData.isEmpty) return const SizedBox.shrink();

    final latestData = _sensorData.first;
    final alerts = _generateSmartAlerts(latestData);

    if (alerts.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'smart_alerts'.tr(),
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'all_sensor_readings_optimal'.tr(),
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'smart_alerts'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                '${alerts.length}',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...alerts.map((alert) => _buildAlertCard(alert)),
      ],
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            alert['color'].withOpacity(0.1),
            alert['color'].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alert['color'].withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: alert['color'].withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: alert['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                alert['icon'],
                color: alert['color'],
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: alert['color'],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: alert['priority'] == 'high'
                              ? Colors.red.shade100
                              : alert['priority'] == 'medium'
                                  ? Colors.orange.shade100
                                  : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          alert['priority'] == 'high'
                              ? 'alert_priority_high'.tr()
                              : alert['priority'] == 'medium'
                                  ? 'alert_priority_medium'.tr()
                                  : 'alert_priority_low'.tr(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: alert['priority'] == 'high'
                                ? Colors.red.shade700
                                : alert['priority'] == 'medium'
                                    ? Colors.orange.shade700
                                    : Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert['message'],
                    style: TextStyle(
                      fontSize: 13,
                      color: alert['color'].withOpacity(0.8),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'view_details'.tr(),
                        style: TextStyle(
                          fontSize: 12,
                          color: alert['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 10,
                        color: alert['color'],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _generateSmartAlerts(SoilData data) {
    final alerts = <Map<String, dynamic>>[];

    // Temperature alerts
    if (data.temperature < 10) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.blue,
        'title': 'low_temperature_alert'.tr(),
        'message': 'temperature_very_low'
            .tr()
            .replaceAll('{temp}', data.temperature.toStringAsFixed(1)),
        'priority': 'high',
      });
    } else if (data.temperature > 35) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.red,
        'title': 'high_temperature_alert'.tr(),
        'message': 'temperature_very_high'
            .tr()
            .replaceAll('{temp}', data.temperature.toStringAsFixed(1)),
        'priority': 'high',
      });
    } else if (data.temperature > 30) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'warm_temperature_notice'.tr(),
        'message': 'temperature_warm'
            .tr()
            .replaceAll('{temp}', data.temperature.toStringAsFixed(1)),
        'priority': 'medium',
      });
    }

    // Soil moisture alerts
    if (data.moistureLevel < 20) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.red,
        'title': 'low_soil_moisture_alert'.tr(),
        'message': 'soil_moisture_very_low'
            .tr()
            .replaceAll('{moisture}', data.moistureLevel.toStringAsFixed(1)),
        'priority': 'high',
      });
    } else if (data.moistureLevel < 30) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'low_soil_moisture_notice'.tr(),
        'message': 'soil_moisture_low'
            .tr()
            .replaceAll('{moisture}', data.moistureLevel.toStringAsFixed(1)),
        'priority': 'medium',
      });
    } else if (data.moistureLevel > 80) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.blue,
        'title': 'high_soil_moisture_alert'.tr(),
        'message': 'soil_moisture_very_high'
            .tr()
            .replaceAll('{moisture}', data.moistureLevel.toStringAsFixed(1)),
        'priority': 'high',
      });
    }

    // pH level alerts
    if (data.phLevel < 5.5) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.red,
        'title': 'acidic_soil_alert'.tr(),
        'message': 'soil_ph_too_acidic'
            .tr()
            .replaceAll('{ph}', data.phLevel.toStringAsFixed(1)),
        'priority': 'high',
      });
    } else if (data.phLevel > 8.0) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.red,
        'title': 'alkaline_soil_alert'.tr(),
        'message': 'soil_ph_too_alkaline'
            .tr()
            .replaceAll('{ph}', data.phLevel.toStringAsFixed(1)),
        'priority': 'high',
      });
    }

    // Humidity alerts
    if (data.humidity < 30) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'low_humidity_notice'.tr(),
        'message': 'humidity_low'
            .tr()
            .replaceAll('{humidity}', data.humidity.toStringAsFixed(1)),
        'priority': 'medium',
      });
    } else if (data.humidity > 90) {
      alerts.add({
        'icon': Icons.warning,
        'color': Colors.blue,
        'title': 'high_humidity_alert'.tr(),
        'message': 'humidity_very_high'
            .tr()
            .replaceAll('{humidity}', data.humidity.toStringAsFixed(1)),
        'priority': 'high',
      });
    }

    // Nutrient alerts
    if (data.nitrogen < 30) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'low_nitrogen_notice'.tr(),
        'message': 'nitrogen_levels_low'
            .tr()
            .replaceAll('{nitrogen}', data.nitrogen.toStringAsFixed(0)),
        'priority': 'medium',
      });
    } else if (data.nitrogen > 80) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.green,
        'title': 'high_nitrogen_notice'.tr(),
        'message': 'nitrogen_levels_high'
            .tr()
            .replaceAll('{nitrogen}', data.nitrogen.toStringAsFixed(0)),
        'priority': 'low',
      });
    }

    if (data.phosphorus < 20) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'low_phosphorus_notice'.tr(),
        'message': 'phosphorus_levels_low'
            .tr()
            .replaceAll('{phosphorus}', data.phosphorus.toStringAsFixed(0)),
        'priority': 'medium',
      });
    }

    if (data.potassium < 15) {
      alerts.add({
        'icon': Icons.info,
        'color': Colors.orange,
        'title': 'low_potassium_notice'.tr(),
        'message': 'potassium_levels_low'
            .tr()
            .replaceAll('{potassium}', data.potassium.toStringAsFixed(0)),
        'priority': 'medium',
      });
    }

    // Optimal conditions notice
    if (alerts.isEmpty) {
      // This will be handled in the _buildSmartAlerts method
    } else {
      // Add a general recommendation based on overall conditions
      final avgTemp = data.temperature;
      final avgMoisture = data.moistureLevel;

      if (avgTemp >= 20 &&
          avgTemp <= 30 &&
          avgMoisture >= 40 &&
          avgMoisture <= 70) {
        alerts.insert(0, {
          'icon': Icons.check_circle,
          'color': Colors.green,
          'title': 'optimal_growing_conditions'.tr(),
          'message': 'optimal_conditions_message'.tr(),
          'priority': 'low',
        });
      }
    }

    return alerts;
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
