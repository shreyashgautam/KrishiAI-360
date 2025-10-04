import 'dart:async';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  Timer? _notificationTimer;
  int _notificationId = 0;

  // Random farming-related notification messages
  final List<String> _notificationMessages = [
    "🌱 Time to check your crop health! Use our disease detection feature.",
    "🌧️ Weather alert: Rain expected in your area. Plan accordingly.",
    "💰 New MSP rates updated! Check current market prices.",
    "📊 Your farm analytics are ready. View your IoT dashboard.",
    "🌾 Rice cultivation tip: Ensure proper water management during this season.",
    "🚜 Government scheme alert: New agricultural loan schemes available.",
    "🌱 Crop rotation reminder: Consider rotating your crops for better yield.",
    "💧 Irrigation tip: Water your crops early morning for best results.",
    "🌾 Harvest time: Check if your crops are ready for harvesting.",
    "📱 Community update: New farming tips shared by fellow farmers.",
    "🌱 Soil health check: Consider testing your soil nutrients.",
    "💰 Market update: Prices for your crops have increased!",
    "🌧️ Weather forecast: Clear skies expected for the next 3 days.",
    "🌾 Fertilizer reminder: Time to apply organic fertilizers.",
    "📊 Farm monitoring: Your sensors detected optimal growing conditions.",
    "🌱 Seed selection: Choose high-yield varieties for next season.",
    "💧 Water management: Check your irrigation system efficiency.",
    "🌾 Pest control: Monitor for common pests in your area.",
    "📱 Knowledge base: New farming techniques added to your library.",
    "💰 Financial tip: Track your farming expenses for better planning.",
  ];

  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    // iOS initialization settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  Future<bool> requestPermissions() async {
    // Request notification permission
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  Future<void> startRandomNotifications() async {
    // Check permissions first
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      print('Notification permission not granted');
      return;
    }

    // Cancel any existing timer
    _notificationTimer?.cancel();

    // Start random notifications every 30 seconds to 1 minute
    _scheduleNextNotification();
  }

  void _scheduleNextNotification() {
    // Random delay between 30 seconds and 1 minute
    final random = Random();
    final delaySeconds = 30 + random.nextInt(31); // 30-60 seconds

    _notificationTimer = Timer(Duration(seconds: delaySeconds), () {
      _showRandomNotification();
      _scheduleNextNotification(); // Schedule the next one
    });
  }

  Future<void> _showRandomNotification() async {
    final random = Random();
    final message =
        _notificationMessages[random.nextInt(_notificationMessages.length)];

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'farming_notifications',
      'Farming Updates',
      channelDescription: 'Random farming tips and updates',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      _notificationId++,
      'Krisi Deep',
      message,
      notificationDetails,
    );
  }

  Future<void> stopRandomNotifications() async {
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
    // You can add navigation logic here based on the notification
  }

  // Method to show immediate notification for testing
  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'test_notifications',
      'Test Notifications',
      channelDescription: 'Test notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      999,
      'Krisi Deep Test',
      'This is a test notification from Krisi Deep!',
      notificationDetails,
    );
  }

  // Get notification permission status
  Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Open app settings for permission
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  // Sample notifications data
  List<NotificationModel> _sampleNotifications = [];

  // Initialize sample notifications
  Future<void> initializeSampleNotifications() async {
    _sampleNotifications = [
      NotificationModel(
        id: '1',
        title: 'Weather Alert',
        message:
            'Heavy rain expected in your area. Take necessary precautions.',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
        type: 'weather',
      ),
      NotificationModel(
        id: '2',
        title: 'Crop Health Update',
        message:
            'Your rice crop is showing signs of healthy growth. Keep monitoring.',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isRead: false,
        type: 'crop',
      ),
      NotificationModel(
        id: '3',
        title: 'Market Price Update',
        message: 'Rice prices have increased by 5% in your local market.',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        type: 'market',
      ),
      NotificationModel(
        id: '4',
        title: 'Government Scheme',
        message: 'New agricultural loan scheme available. Check eligibility.',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        type: 'government',
      ),
      NotificationModel(
        id: '5',
        title: 'Irrigation Reminder',
        message: 'Time to water your crops. Optimal irrigation window is now.',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isRead: false,
        type: 'irrigation',
      ),
    ];
  }

  // Get all notifications
  List<NotificationModel> get notifications => _sampleNotifications;

  // Get unread count
  int get unreadCount => _sampleNotifications.where((n) => !n.isRead).length;

  // Mark all as read
  void markAllAsRead() {
    for (int i = 0; i < _sampleNotifications.length; i++) {
      _sampleNotifications[i] = _sampleNotifications[i].copyWith(isRead: true);
    }
  }

  // Mark specific notification as read
  void markAsRead(String id) {
    for (int i = 0; i < _sampleNotifications.length; i++) {
      if (_sampleNotifications[i].id == id) {
        _sampleNotifications[i] =
            _sampleNotifications[i].copyWith(isRead: true);
        break;
      }
    }
  }

  // Delete notification
  void deleteNotification(String id) {
    _sampleNotifications.removeWhere((n) => n.id == id);
  }
}
