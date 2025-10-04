# Random Notification System for Krisi Deep

## Overview
This implementation adds a random notification system to the Krisi Deep farming app that sends farming-related notifications every 30 seconds to 1 minute.

## Features
- **Random Timing**: Notifications appear at random intervals between 30 seconds and 1 minute
- **Farming Content**: 20+ farming-related notification messages including:
  - Crop health reminders
  - Weather alerts
  - Market price updates
  - Government scheme notifications
  - Farming tips and advice
- **Permission Handling**: Automatic permission requests with fallback to app settings
- **User Control**: Toggle notifications on/off from the home screen
- **Test Notifications**: Send immediate test notifications for verification

## Implementation Details

### Files Added/Modified

#### 1. Dependencies (`pubspec.yaml`)
```yaml
flutter_local_notifications: ^17.2.2
timezone: ^0.9.4
```

#### 2. Android Permissions (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.VIBRATE" />
```

#### 3. Notification Service (`lib/services/notification_service.dart`)
- Singleton service for managing notifications
- Random message selection from 20+ farming tips
- Permission handling and request
- Timer-based random notification scheduling
- Test notification functionality

#### 4. Home Screen Integration (`lib/screens/home_screen_new.dart`)
- Added notification service initialization
- Added notification toggle button
- Added test notification button
- Visual indicators for notification status

## Usage

### For Users
1. **Enable Notifications**: Tap the notification icon in the header (bell icon with green color when active)
2. **Test Notifications**: Tap the "+" notification icon to send a test notification
3. **Disable Notifications**: Tap the notification icon again to disable
4. **Permission Issues**: If permissions are denied, the app will open system settings

### For Developers
```dart
// Initialize the service
final notificationService = NotificationService();
await notificationService.initialize();

// Request permissions
final hasPermission = await notificationService.requestPermissions();

// Start random notifications
await notificationService.startRandomNotifications();

// Stop notifications
await notificationService.stopRandomNotifications();

// Send test notification
await notificationService.showTestNotification();
```

## Notification Messages
The system includes 20+ farming-related messages such as:
- "🌱 Time to check your crop health! Use our disease detection feature."
- "🌧️ Weather alert: Rain expected in your area. Plan accordingly."
- "💰 New MSP rates updated! Check current market prices."
- "📊 Your farm analytics are ready. View your IoT dashboard."

## Testing
Run the test file to verify the notification system:
```bash
dart test_notification_system.dart
```

## Platform Support
- ✅ Android (fully supported)
- ⚠️ iOS (requires iOS project setup)
- ✅ Web (basic support)
- ✅ macOS (basic support)

## Troubleshooting

### Common Issues
1. **Notifications not appearing**: Check if permissions are granted
2. **Permission denied**: User needs to manually enable in system settings
3. **No sound/vibration**: Check device notification settings

### Debug Steps
1. Check permission status: `await notificationService.isNotificationPermissionGranted()`
2. Send test notification: `await notificationService.showTestNotification()`
3. Check Android notification settings in device settings

## Future Enhancements
- [ ] Scheduled notifications for specific farming activities
- [ ] Location-based weather alerts
- [ ] Integration with IoT sensor data
- [ ] Personalized notification preferences
- [ ] Notification history and management
- [ ] Push notifications via Firebase

## Dependencies
- `flutter_local_notifications`: ^17.2.2
- `timezone`: ^0.9.4
- `permission_handler`: ^11.4.0 (already included)

## Notes
- Notifications are automatically stopped when the app is disposed
- Random timing prevents notification spam
- All notifications include farming-related emojis for better visual appeal
- The system respects user preferences and can be toggled on/off


