import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable location services in your device settings.');
      }

      // Check location permissions using permission_handler
      PermissionStatus permissionStatus = await Permission.location.status;

      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
        if (permissionStatus.isDenied) {
          throw Exception(
              'Location permissions are denied. Please grant location permission to use this feature.');
        }
      }

      if (permissionStatus.isPermanentlyDenied) {
        throw Exception(
            'Location permissions are permanently denied. Please enable location permission in app settings.');
      }

      // Get current position with timeout
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      throw Exception('Failed to get location: ${e.toString()}');
    }
  }

  // Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      // For demonstration, return a formatted string
      // In a real app, you would use a geocoding service
      return 'Lat: ${latitude.toStringAsFixed(4)}, Lng: ${longitude.toStringAsFixed(4)}';
    } catch (e) {
      throw Exception('Failed to get address: ${e.toString()}');
    }
  }

  // Check location permission
  Future<bool> hasLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    return status.isGranted;
  }

  // Request location permission
  Future<bool> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    return status.isGranted;
  }
}
