import 'package:flutter/material.dart';
import '../services/weather_service.dart';
import '../models/weather.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedLocation = 'Delhi';

  // Real weather data from API
  WeatherData? _currentWeather;
  List<WeatherForecast> _forecast = [];
  List<WeatherAlert> _alerts = [];
  List<String> _recommendations = [];

  // Available locations
  final List<Map<String, String>> _locations = [
    {'name': 'Delhi', 'coordinates': '28.6139,77.2090'},
    {'name': 'Mumbai', 'coordinates': '19.0760,72.8777'},
    {'name': 'Bangalore', 'coordinates': '12.9716,77.5946'},
    {'name': 'Kolkata', 'coordinates': '22.5726,88.3639'},
    {'name': 'Chennai', 'coordinates': '13.0827,80.2707'},
    {'name': 'Hyderabad', 'coordinates': '17.3850,78.4867'},
    {'name': 'Pune', 'coordinates': '18.5204,73.8567'},
    {'name': 'Ahmedabad', 'coordinates': '23.0225,72.5714'},
  ];

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      // Load current weather and forecast
      final weather = await _weatherService.getCurrentWeather(_selectedLocation);
      final alerts = await _weatherService.getWeatherAlerts(_selectedLocation);
      final recommendations =
          await _weatherService.getWeatherRecommendations(weather, 'Rice');

      setState(() {
        _currentWeather = weather;
        _forecast = weather.forecast;
        _alerts = alerts;
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load weather data: $e';
        _isLoading = false;
      });
    }
  }

  // Dummy weather data (fallback)
  final List<DisplayWeatherData> _weatherData = [
    WeatherData(
      date: DateTime.now(),
      temperature: 28,
      humidity: 65,
      rainfall: 0,
      windSpeed: 12,
      condition: 'Sunny',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 1)),
      temperature: 26,
      humidity: 70,
      rainfall: 5,
      windSpeed: 15,
      condition: 'Partly Cloudy',
      icon: Icons.wb_cloudy,
      color: Colors.blue,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 2)),
      temperature: 24,
      humidity: 80,
      rainfall: 15,
      windSpeed: 18,
      condition: 'Rainy',
      icon: Icons.grain,
      color: Colors.indigo,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 3)),
      temperature: 25,
      humidity: 75,
      rainfall: 8,
      windSpeed: 14,
      condition: 'Cloudy',
      icon: Icons.cloud,
      color: Colors.grey,
    ),
    WeatherData(
      date: DateTime.now().add(const Duration(days: 4)),
      temperature: 27,
      humidity: 68,
      rainfall: 2,
      windSpeed: 10,
      condition: 'Sunny',
      icon: Icons.wb_sunny,
      color: Colors.orange,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade700, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Location Selection Dropdown
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedLocation,
                    isExpanded: true,
                    hint: const Text('Select Location'),
                    items: _locations.map((location) {
                      return DropdownMenuItem<String>(
                        value: location['name'],
                        child: Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(location['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedLocation = newValue;
                        });
                        _loadWeatherData();
                      }
                    },
                  ),
                ),
              ),
              
              // Weather Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadWeatherData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                // Current Weather Card
                _buildCurrentWeatherCard(),
                const SizedBox(height: 20),

                // Weather Alerts
                if (_alerts.isNotEmpty) ...[
                  _buildAlertsSection(),
                  const SizedBox(height: 20),
                ],

                // 5-Day Forecast
                _buildForecastSection(),
                const SizedBox(height: 20),

                // Weather Tips
                _buildWeatherTips(),
                        ],
                      ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    if (_currentWeather == null) return const SizedBox.shrink();
    final currentWeather = _currentWeather!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Weather',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${currentWeather.temperature.round()}°C',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    currentWeather.condition,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Icon(
                _getWeatherIcon(currentWeather.condition),
                size: 80,
                color: _getWeatherColor(currentWeather.condition),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(
                  'Humidity', '${currentWeather.humidity.round()}%', Icons.water_drop),
              _buildWeatherDetail(
                  'Wind', '${currentWeather.windSpeed.round()} km/h', Icons.air),
              _buildWeatherDetail(
                  'Rainfall', '${currentWeather.rainfall.round()}mm', Icons.grain),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weather Alerts',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ..._alerts.map((alert) => _buildAlertCard(alert)),
      ],
    );
  }

  Widget _buildAlertCard(WeatherAlert alert) {
    Color alertColor;
    switch (alert.type) {
      case AlertType.warning:
        alertColor = Colors.orange;
        break;
      case AlertType.info:
        alertColor = Colors.blue;
        break;
      case AlertType.danger:
        alertColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: alertColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: alertColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: alertColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'In ${_getTimeUntil(alert.time)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5-Day Forecast',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: _weatherData
                .map((weather) => _buildForecastItem(weather))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(WeatherData weather) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              _getDayName(weather.date),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Icon(
              weather.icon,
              color: weather.color,
              size: 24,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              weather.condition,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${weather.temperature}°C',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Farming Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildTipItem(
                'Irrigation',
                'Reduce irrigation frequency due to expected rainfall',
                Icons.water_drop,
                Colors.blue,
              ),
              const Divider(),
              _buildTipItem(
                'Crop Protection',
                'Monitor for fungal diseases after rainfall',
                Icons.eco,
                Colors.green,
              ),
              const Divider(),
              _buildTipItem(
                'Harvesting',
                'Ideal conditions for harvesting in 2-3 days',
                Icons.agriculture,
                Colors.orange,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(
      String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    if (date.day == DateTime.now().day) return 'Today';
    if (date.day == DateTime.now().add(const Duration(days: 1)).day)
      return 'Tomorrow';
    return _getWeekdayName(date.weekday);
  }

  String _getWeekdayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Icons.wb_sunny;
      case 'partly cloudy':
      case 'partly_cloudy':
        return Icons.cloud_queue;
      case 'cloudy':
      case 'overcast':
        return Icons.cloud;
      case 'rain':
      case 'rainy':
        return Icons.grain;
      case 'thunderstorm':
      case 'storm':
        return Icons.thunderstorm;
      case 'snow':
      case 'snowy':
        return Icons.ac_unit;
      case 'fog':
      case 'foggy':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  Color _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return Colors.orange;
      case 'partly cloudy':
      case 'partly_cloudy':
        return Colors.amber;
      case 'cloudy':
      case 'overcast':
        return Colors.grey;
      case 'rain':
      case 'rainy':
        return Colors.blue;
      case 'thunderstorm':
      case 'storm':
        return Colors.purple;
      case 'snow':
      case 'snowy':
        return Colors.lightBlue;
      case 'fog':
      case 'foggy':
        return Colors.blueGrey;
      default:
        return Colors.orange;
    }
  }

  String _getTimeUntil(DateTime time) {
    final difference = time.difference(DateTime.now());
    if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'Now';
    }
  }
}

class WeatherData {
  final DateTime date;
  final int temperature;
  final int humidity;
  final int rainfall;
  final int windSpeed;
  final String condition;
  final IconData icon;
  final Color color;

  WeatherData({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.rainfall,
    required this.windSpeed,
    required this.condition,
    required this.icon,
    required this.color,
  });
}

class WeatherAlert {
  final String title;
  final String message;
  final AlertType type;
  final DateTime time;

  WeatherAlert({
    required this.title,
    required this.message,
    required this.type,
    required this.time,
  });
}

enum AlertType { info, warning, danger }
