import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/land_data.dart';
import '../services/land_service.dart';
import '../services/auth_service.dart';

class LandRegistrationScreen extends StatefulWidget {
  const LandRegistrationScreen({super.key});

  @override
  State<LandRegistrationScreen> createState() => _LandRegistrationScreenState();
}

class _LandRegistrationScreenState extends State<LandRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _landService = LandService();
  final _authService = AuthService();

  // Form controllers
  final _nameController = TextEditingController();
  final _sensorIdController = TextEditingController();
  final _locationController = TextEditingController();
  final _cropTypeController = TextEditingController();
  final _areaController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Location data
  double? _latitude;
  double? _longitude;
  bool _isLoadingLocation = false;
  bool _isSubmitting = false;

  // Crop types
  final List<String> _cropTypes = [
    'Rice',
    'Wheat',
    'Corn',
    'Sugarcane',
    'Cotton',
    'Potato',
    'Tomato',
    'Onion',
    'Chilli',
    'Other'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _sensorIdController.dispose();
    _locationController.dispose();
    _cropTypeController.dispose();
    _areaController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar('Location services are disabled. Please enable them.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('Location permissions are permanently denied.');
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _locationController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });

      _showSnackBar('Location captured successfully!');
    } catch (e) {
      _showSnackBar('Error getting location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_latitude == null || _longitude == null) {
      _showSnackBar('Please get your current location first.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final form = LandRegistrationForm(
        name: _nameController.text.trim(),
        sensorId: _sensorIdController.text.trim(),
        location: _locationController.text.trim(),
        latitude: _latitude!,
        longitude: _longitude!,
        cropType: _cropTypeController.text.trim(),
        area: double.parse(_areaController.text.trim()),
        description: _descriptionController.text.trim(),
      );

      // Get current user ID (you might need to adjust this based on your auth system)
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        _showSnackBar('Please login to register land.');
        return;
      }

      final success = await _landService.registerLand(form, currentUser.uid);

      if (success) {
        _showSuccessDialog();
      } else {
        _showSnackBar('Failed to register land. Please try again.');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 28),
              SizedBox(width: 12),
              Text('Registration Submitted'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your land registration has been submitted successfully!'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What happens next?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Admin will review your registration\n• You will receive notification once approved\n• Sensor data will start appearing in your dashboard',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register New Land'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.sensors, color: Colors.green.shade700, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connect Your Land with Sensor',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Register your land to start receiving real-time sensor data and crop predictions.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Land Name
              Text(
                'Land Name *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., North Field, Main Farm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.agriculture),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter land name';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Sensor ID
              Text(
                'Sensor ID *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _sensorIdController,
                decoration: InputDecoration(
                  hintText: 'Enter your unique sensor number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.sensors),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.help_outline),
                    onPressed: () {
                      _showSensorHelpDialog();
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter sensor ID';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Location
              Text(
                'Location *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _locationController,
                      decoration: InputDecoration(
                        hintText: 'Get current location or enter manually',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please get location or enter manually';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    icon: _isLoadingLocation
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.my_location),
                    label: Text(_isLoadingLocation ? 'Getting...' : 'Get'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Crop Type
              Text(
                'Crop Type *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _cropTypeController.text.isEmpty
                    ? null
                    : _cropTypeController.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.eco),
                ),
                hint: Text('Select crop type'),
                items: _cropTypes.map((String crop) {
                  return DropdownMenuItem<String>(
                    value: crop,
                    child: Text(crop),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _cropTypeController.text = newValue;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select crop type';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Area
              Text(
                'Land Area (Acres) *',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _areaController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'e.g., 2.5',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.straighten),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter land area';
                  }
                  final area = double.tryParse(value);
                  if (area == null || area <= 0) {
                    return 'Please enter a valid area';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Description
              Text(
                'Description (Optional)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Additional information about your land...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.description),
                ),
              ),

              SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isSubmitting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Submitting...'),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 8),
                            Text('Submit Registration'),
                          ],
                        ),
                ),
              ),

              SizedBox(height: 16),

              // Info Card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Registration Process',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Fill out this form with your land and sensor details\n'
                      '2. Admin will review and approve your registration\n'
                      '3. Once approved, you\'ll start receiving sensor data\n'
                      '4. Get crop predictions and farming recommendations',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSensorHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sensor ID Help'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Your sensor ID is a unique identifier provided with your sensor device.'),
              SizedBox(height: 12),
              Text('It usually looks like:'),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SENSOR_001\nSENSOR_ABC123\nSNR_2024_001',
                  style: TextStyle(fontFamily: 'monospace'),
                ),
              ),
              SizedBox(height: 12),
              Text(
                  'If you don\'t have a sensor ID, contact support for assistance.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
