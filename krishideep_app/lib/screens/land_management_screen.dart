import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/land_data.dart';
import '../services/land_service.dart';
import '../services/auth_service.dart';
import 'land_registration_screen.dart';
import 'land_details_screen.dart';

class LandManagementScreen extends StatefulWidget {
  const LandManagementScreen({super.key});

  @override
  State<LandManagementScreen> createState() => _LandManagementScreenState();
}

class _LandManagementScreenState extends State<LandManagementScreen> {
  final _landService = LandService();
  final _authService = AuthService();

  List<LandData> _lands = [];
  bool _isLoading = true;
  String? _selectedLandId;

  @override
  void initState() {
    super.initState();
    _loadLands();
  }

  Future<void> _loadLands() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        final lands = await _landService.getFarmerLands(currentUser.uid);
        setState(() {
          _lands = lands;
          // Set "Land One" as default selection
          _selectedLandId = 'land_one';
        });
      }
    } catch (e) {
      _showSnackBar('Error loading lands: $e');
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

  void _navigateToRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LandRegistrationScreen()),
    ).then((_) {
      _loadLands(); // Refresh the list after registration
    });
  }

  void _navigateToLandDetails(LandData land) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandDetailsScreen(land: land),
      ),
    );
  }

  Widget _buildLandCard(LandData land) {
    final isSelected = _selectedLandId == land.id;
    final statusColor = _getStatusColor(land.status);
    final statusIcon = _getStatusIcon(land.status);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? Colors.green.shade400 : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedLandId = land.id;
          });
          _navigateToLandDetails(land);
          _showSnackBar('Selected: ${land.name}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Land Icon
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.agriculture,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),

                  // Land Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          land.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          land.location,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 12, color: statusColor),
                        SizedBox(width: 4),
                        Text(
                          land.status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Land Details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      Icons.eco,
                      'Crop',
                      land.cropType,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.straighten,
                      'Area',
                      '${land.area} acres',
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      Icons.sensors,
                      'Sensor',
                      land.sensorId,
                      Colors.purple,
                    ),
                  ),
                ],
              ),

              // Sensor Status (if approved)
              if (land.status == 'approved' && land.sensorData != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: land.sensorData!.isOnline
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: land.sensorData!.isOnline
                          ? Colors.green.shade200
                          : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        land.sensorData!.isOnline ? Icons.wifi : Icons.wifi_off,
                        size: 16,
                        color: land.sensorData!.isOnline
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      SizedBox(width: 8),
                      Text(
                        land.sensorData!.isOnline
                            ? 'Sensor Online - ${land.sensorData!.batteryLevel}'
                            : 'Sensor Offline',
                        style: TextStyle(
                          fontSize: 12,
                          color: land.sensorData!.isOnline
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'approved':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.agriculture,
            size: 80,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            'No Lands Registered',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Register your first land to start receiving\nsensor data and crop predictions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _navigateToRegistration,
            icon: Icon(Icons.add),
            label: Text('Register Land'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
        title: Text('My Lands'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadLands,
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text('Loading your lands...'),
                ],
              ),
            )
          : _lands.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Header with dropdown and stats
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border(
                          bottom: BorderSide(color: Colors.green.shade200),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Land Selection Dropdown
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green.shade300),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedLandId,
                                isExpanded: true,
                                hint: Text('Select a land'),
                                items: [
                                  // Add "Land One" as the first option
                                  DropdownMenuItem<String>(
                                    value: 'land_one',
                                    child: Row(
                                      children: [
                                        Icon(Icons.agriculture,
                                            size: 16,
                                            color: Colors.green.shade700),
                                        SizedBox(width: 8),
                                        Text('Land One'),
                                      ],
                                    ),
                                  ),
                                  // Add existing lands
                                  ..._lands
                                      .map((land) => DropdownMenuItem<String>(
                                            value: land.id,
                                            child: Row(
                                              children: [
                                                Icon(Icons.agriculture,
                                                    size: 16,
                                                    color:
                                                        Colors.green.shade700),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(land.name),
                                                      Text(
                                                        land.location,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .grey.shade600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ],
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedLandId = newValue;
                                  });
                                  if (newValue == 'land_one') {
                                    _showSnackBar('Selected: Land One');
                                  } else if (newValue != null) {
                                    final selectedLand = _lands.firstWhere(
                                        (land) => land.id == newValue);
                                    _showSnackBar(
                                        'Selected: ${selectedLand.name}');
                                  }
                                },
                              ),
                            ),
                          ),

                          SizedBox(height: 12),

                          // Stats Row
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${'total_lands'.tr()}: ${_lands.length + 1}', // +1 for "Land One"
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Approved: ${_lands.where((l) => l.status == 'approved').length} | '
                                      'Pending: ${_lands.where((l) => l.status == 'pending').length}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _navigateToRegistration,
                                icon: Icon(Icons.add, size: 16),
                                label: Text('Add Land'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade700,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Lands List
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        itemCount: _lands.length,
                        itemBuilder: (context, index) {
                          return _buildLandCard(_lands[index]);
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToRegistration,
        icon: Icon(Icons.add),
        label: Text('Register Land'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }
}
