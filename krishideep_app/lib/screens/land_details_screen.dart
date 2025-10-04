import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/land_data.dart';
import '../services/land_service.dart';

class LandDetailsScreen extends StatefulWidget {
  final LandData land;

  const LandDetailsScreen({super.key, required this.land});

  @override
  State<LandDetailsScreen> createState() => _LandDetailsScreenState();
}

class _LandDetailsScreenState extends State<LandDetailsScreen>
    with TickerProviderStateMixin {
  final _landService = LandService();

  late TabController _tabController;
  SensorData? _sensorData;
  CropPrediction? _cropPrediction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load sensor data
      final sensorData = await _landService.getSensorData(widget.land.sensorId);

      // Load crop prediction
      final cropPrediction =
          await _landService.getCropPrediction(widget.land.id);

      setState(() {
        _sensorData = sensorData;
        _cropPrediction = cropPrediction;
      });
    } catch (e) {
      _showSnackBar('Error loading data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade600, Colors.green.shade800],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.agriculture,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.land.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.land.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.land.status)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStatusColor(widget.land.status),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        widget.land.status.toUpperCase(),
                        style: TextStyle(
                          color: _getStatusColor(widget.land.status),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _buildHeaderStat('Crop', widget.land.cropType, Icons.eco),
              SizedBox(width: 16),
              _buildHeaderStat(
                  'Area', '${widget.land.area} acres', Icons.straighten),
              SizedBox(width: 16),
              _buildHeaderStat('Sensor', widget.land.sensorId, Icons.sensors),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_sensorData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sensors_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Sensor Data Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Sensor data will appear here once connected'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sensor Status Card
          _buildSensorStatusCard(),
          SizedBox(height: 16),

          // Real-time Data Cards
          _buildDataCards(),
          SizedBox(height: 16),

          // Charts
          _buildCharts(),
        ],
      ),
    );
  }

  Widget _buildSensorStatusCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _sensorData!.isOnline ? Icons.wifi : Icons.wifi_off,
                  color: _sensorData!.isOnline ? Colors.green : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Sensor Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem(
                    'Status',
                    _sensorData!.isOnline ? 'Online' : 'Offline',
                    _sensorData!.isOnline ? Colors.green : Colors.red,
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    'Battery',
                    _sensorData!.batteryLevel,
                    _getBatteryColor(_sensorData!.batteryLevel),
                  ),
                ),
                Expanded(
                  child: _buildStatusItem(
                    'Last Update',
                    _formatTime(_sensorData!.lastUpdated),
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildDataCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Real-time Sensor Data',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildDataCard(
                'Temperature',
                '${_sensorData!.temperature.toStringAsFixed(1)}°C',
                Icons.thermostat,
                Colors.orange,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildDataCard(
                'Humidity',
                '${_sensorData!.humidity.toStringAsFixed(1)}%',
                Icons.water_drop,
                Colors.blue,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDataCard(
                'Soil Moisture',
                '${_sensorData!.soilMoisture.toStringAsFixed(1)}%',
                Icons.grass,
                Colors.green,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _buildDataCard(
                'pH Level',
                _sensorData!.ph.toStringAsFixed(1),
                Icons.science,
                Colors.purple,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildDataCard(
                'Light Intensity',
                '${_sensorData!.lightIntensity.toStringAsFixed(0)} lux',
                Icons.light_mode,
                Colors.yellow.shade700,
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Container(), // Empty space for alignment
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDataCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Trends',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature & Humidity',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, _sensorData!.temperature),
                            FlSpot(1, _sensorData!.temperature + 2),
                            FlSpot(2, _sensorData!.temperature - 1),
                            FlSpot(3, _sensorData!.temperature + 1),
                          ],
                          isCurved: true,
                          color: Colors.orange,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: [
                            FlSpot(0, _sensorData!.humidity),
                            FlSpot(1, _sensorData!.humidity - 5),
                            FlSpot(2, _sensorData!.humidity + 3),
                            FlSpot(3, _sensorData!.humidity - 2),
                          ],
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 3,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCropPredictionTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_cropPrediction == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Crop Predictions Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Crop predictions will appear here once data is available'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Prediction Overview
          _buildPredictionOverview(),
          SizedBox(height: 16),

          // Recommendations
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildPredictionOverview() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crop Prediction Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPredictionItem(
                    'Expected Yield',
                    '${_cropPrediction!.yieldPrediction.toStringAsFixed(1)} tons/acre',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildPredictionItem(
                    'Growth Stage',
                    _cropPrediction!.growthStage,
                    Icons.timeline,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPredictionItem(
                    'Confidence',
                    '${(_cropPrediction!.confidence * 100).toStringAsFixed(0)}%',
                    Icons.analytics,
                    Colors.purple,
                  ),
                ),
                Expanded(
                  child: _buildPredictionItem(
                    'Prediction Date',
                    _formatDate(_cropPrediction!.predictionDate),
                    Icons.calendar_today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...(_cropPrediction!.recommendations.map(
              (recommendation) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildLandInfoTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Land Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildInfoRow('Name', widget.land.name),
                  _buildInfoRow('Location', widget.land.location),
                  _buildInfoRow('Crop Type', widget.land.cropType),
                  _buildInfoRow('Area', '${widget.land.area} acres'),
                  _buildInfoRow('Sensor ID', widget.land.sensorId),
                  _buildInfoRow('Status', widget.land.status.toUpperCase()),
                  _buildInfoRow(
                      'Registered', _formatDate(widget.land.createdAt)),
                  if (widget.land.approvedAt != null)
                    _buildInfoRow(
                        'Approved', _formatDate(widget.land.approvedAt!)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getBatteryColor(String batteryLevel) {
    final level = int.tryParse(batteryLevel.replaceAll('%', '')) ?? 0;
    if (level > 50) return Colors.green;
    if (level > 20) return Colors.orange;
    return Colors.red;
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

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          TabBar(
            controller: _tabController,
            labelColor: Colors.green.shade700,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green.shade700,
            tabs: [
              Tab(text: 'Sensor Data', icon: Icon(Icons.sensors)),
              Tab(text: 'Predictions', icon: Icon(Icons.analytics)),
              Tab(text: 'Land Info', icon: Icon(Icons.info)),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSensorDataTab(),
                _buildCropPredictionTab(),
                _buildLandInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
