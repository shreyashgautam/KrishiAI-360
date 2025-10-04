# Firebase Authentication Setup Guide

This guide will help you complete the Firebase authentication setup for your Krisi Deep Flutter app.

## ✅ What's Already Done

1. **Dependencies Added**: Firebase Core, Firebase Auth, and Google Sign-In packages added to `pubspec.yaml`
2. **Auth Service Updated**: Complete Firebase authentication service with multiple sign-in methods
3. **Login Screen Enhanced**: Tabbed interface with Phone, Email, and Google authentication
4. **Main App Integration**: Firebase initialization and auth state management
5. **Translation Files**: Updated with authentication-related strings in English, Hindi, and Tamil
6. **Android Configuration**: Google Services plugin and build configuration updated

## 🔧 Required Setup Steps

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" or "Add project"
3. Enter project name: `krisi-deep` (or your preferred name)
4. Enable Google Analytics (optional)
5. Create the project

### 2. Add Android App to Firebase

1. In Firebase Console, click "Add app" → Android
2. Enter package name: `com.example.krisi_deep`
3. Enter app nickname: `Krisi Deep Android`
4. Download `google-services.json`
5. Replace the placeholder file at `android/app/google-services.json` with the downloaded file

### 3. Add iOS App to Firebase (if needed)

1. In Firebase Console, click "Add app" → iOS
2. Enter bundle ID: `com.example.krisi_deep`
3. Enter app nickname: `Krisi Deep iOS`
4. Download `GoogleService-Info.plist`
5. Add it to `ios/Runner/` directory in Xcode

### 4. Enable Authentication Methods

1. In Firebase Console, go to "Authentication" → "Sign-in method"
2. Enable the following providers:
   - **Email/Password**: Enable and configure
   - **Phone**: Enable and configure (requires verification)
   - **Google**: Enable and configure (requires OAuth setup)

### 5. Configure Google Sign-In

1. In Firebase Console, go to "Authentication" → "Sign-in method" → "Google"
2. Click "Enable"
3. Add your app's SHA-1 fingerprint:
   ```bash
   # Get debug SHA-1
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
4. Add the SHA-1 to Firebase Console

### 6. Update Firebase Configuration

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase project configuration:

```dart
// Get these values from your Firebase project settings
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-actual-android-api-key',
  appId: 'your-actual-android-app-id',
  messagingSenderId: 'your-actual-sender-id',
  projectId: 'your-actual-project-id',
  storageBucket: 'your-actual-project-id.appspot.com',
);
```

### 7. Test the Setup

1. Run the app: `flutter run`
2. Test each authentication method:
   - Phone authentication (requires real phone number for OTP)
   - Email/password authentication
   - Google Sign-In

## 🔐 Authentication Features

### Phone Authentication
- Send OTP to phone number
- Verify OTP code
- Auto-verification support

### Email/Password Authentication
- Sign up with email and password
- Sign in with existing credentials
- Password reset functionality
- Form validation

### Google Sign-In
- One-tap Google authentication
- Automatic account linking
- Profile information access

## 🛠️ Troubleshooting

### Common Issues

1. **Google Sign-In not working**:
   - Ensure SHA-1 fingerprint is added to Firebase
   - Check if Google Services plugin is properly configured
   - Verify OAuth client configuration

2. **Phone authentication failing**:
   - Ensure phone authentication is enabled in Firebase Console
   - Check if you have sufficient quota for SMS
   - Verify phone number format

3. **Build errors**:
   - Run `flutter clean` and `flutter pub get`
   - Ensure all dependencies are properly installed
   - Check if `google-services.json` is in the correct location

### Debug Commands

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run

# Check Firebase configuration
flutter doctor
```

## 📱 Platform-Specific Notes

### Android
- Requires `google-services.json` in `android/app/`
- Google Services plugin must be applied
- SHA-1 fingerprint must be configured

### iOS
- Requires `GoogleService-Info.plist` in `ios/Runner/`
- URL schemes must be configured
- Bundle ID must match Firebase configuration

### Web
- Firebase configuration is handled automatically
- No additional setup required for web deployment

## 🔒 Security Considerations

1. **API Keys**: Never commit real API keys to version control
2. **SHA-1 Fingerprints**: Keep production SHA-1 fingerprints secure
3. **Authentication Rules**: Configure Firebase Security Rules appropriately
4. **User Data**: Implement proper data validation and sanitization

## 📚 Additional Resources

- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)

## 🎯 Next Steps

After completing the setup:

1. Test all authentication flows
2. Implement user profile management
3. Add role-based access control
4. Set up user data storage
5. Implement offline authentication handling

---

**Note**: This setup provides a complete authentication system. Make sure to replace all placeholder values with your actual Firebase project configuration before deploying to production.
