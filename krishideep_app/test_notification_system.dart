import 'package:flutter/material.dart';
import 'lib/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();

  // Initialize the notification service
  await notificationService.initialize();

  print('Notification service initialized');

  // Request permissions
  final hasPermission = await notificationService.requestPermissions();
  print('Permission granted: $hasPermission');

  if (hasPermission) {
    // Start random notifications
    await notificationService.startRandomNotifications();
    print('Random notifications started');

    // Show a test notification immediately
    await notificationService.showTestNotification();
    print('Test notification sent');

    // Wait for 2 minutes to see random notifications
    print('Waiting for 2 minutes to see random notifications...');
    await Future.delayed(Duration(minutes: 2));

    // Stop notifications
    await notificationService.stopRandomNotifications();
    print('Random notifications stopped');
  } else {
    print('Permission not granted. Cannot show notifications.');
  }
}


