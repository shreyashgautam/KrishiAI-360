# MongoDB Integration for Krisi Deep App

This document explains how MongoDB has been integrated into your Flutter app for storing profile and farming data.

## 🗄️ Database Configuration

### Connection Details
- **MongoDB URI**: `mongodb+srv://shreyashgautam2007_db_user:0DuME6I8FjEpMTED@cluster0.jrhuvez.mongodb.net/?retryWrites=true&w=majority`
- **Database Name**: `krisideep`

### Collections Available
1. **user_profiles** - User profile information
2. **crop_data** - Crop planting and management data
3. **weather_data** - Weather information by location
4. **market_prices** - Market price data for crops
5. **farmer_community** - Community posts and discussions
6. **government_schemes** - Government schemes and subsidies
7. **financial_advisory** - Financial advice and recommendations
8. **iot_sensor_data** - IoT sensor readings
9. **analytics_data** - App usage analytics

## 🚀 Features Implemented

### 1. User Profile Management
- **Primary Storage**: MongoDB
- **Fallback**: Firestore + Local Storage
- **Features**:
  - Create/Update user profiles
  - Search profiles by city
  - Offline support with local storage
  - Automatic sync when online

### 2. Farming Data Management
- Crop data storage and retrieval
- Weather data by location
- Market price tracking
- Community posts
- Government schemes
- Financial advisory
- IoT sensor data
- Analytics data

### 3. Offline Support
- Local storage fallback using SharedPreferences
- Automatic sync when connection is restored
- Graceful error handling

## 📱 How to Use

### 1. Test MongoDB Connection
Navigate to `/mongodb-test` route to test the connection and basic operations.

### 2. User Profile Operations
```dart
// Save user profile
final profile = UserProfile(
  uid: 'user123',
  name: 'John Doe',
  phone: '+919876543210',
  city: 'Mumbai',
  email: 'john@example.com',
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

await UserProfileMongoService.createOrUpdateProfile(profile);

// Get user profile
final userProfile = await UserProfileMongoService.getProfile('user123');

// Check if profile exists
final exists = await UserProfileMongoService.profileExists('user123');
```

### 3. Farming Data Operations
```dart
// Save crop data
final cropData = {
  'userId': 'user123',
  'cropName': 'Rice',
  'variety': 'Basmati',
  'plantingDate': DateTime.now().toIso8601String(),
  'area': 2.5,
  'location': 'Mumbai',
  'createdAt': DateTime.now().toIso8601String(),
};

await FarmingDataService.saveCropData(cropData);

// Get crop data by user
final crops = await FarmingDataService.getCropDataByUser('user123');
```

### 4. Weather Data
```dart
// Save weather data
final weatherData = {
  'city': 'Mumbai',
  'temperature': 28.5,
  'humidity': 65,
  'rainfall': 0,
  'date': DateTime.now().toIso8601String(),
  'createdAt': DateTime.now().toIso8601String(),
};

await FarmingDataService.saveWeatherData(weatherData);

// Get weather data by location
final weather = await FarmingDataService.getWeatherDataByLocation('Mumbai');
```

## 🔧 Configuration Files

### 1. Database Config (`lib/config/database_config.dart`)
Contains all MongoDB connection settings and collection names.

### 2. MongoDB Service (`lib/services/mongodb_service.dart`)
Core MongoDB connection and user profile management.

### 3. Farming Data Service (`lib/services/farming_data_service.dart`)
Specialized service for farming-related data operations.

## 🛠️ Dependencies Added

```yaml
dependencies:
  mongo_dart: ^0.10.5
  http: ^0.13.6
```

## 🔄 Integration with Existing Services

### AuthService Integration
- MongoDB is used as primary storage for user profiles
- Firestore serves as fallback
- Local storage provides offline support

### Profile Completion Flow
1. User completes authentication (Firebase Auth)
2. Profile data is saved to MongoDB
3. If MongoDB fails, falls back to Firestore
4. Local storage ensures data persistence

## 🧪 Testing

### Test Screen
Access the MongoDB test screen at `/mongodb-test` to:
- Test database connection
- Perform profile operations
- Test farming data operations
- View stored profiles

### Manual Testing
1. Run the app: `flutter run -d chrome`
2. Navigate to `/mongodb-test`
3. Click "Check Connection"
4. Test profile and farming data operations

## 🚨 Error Handling

### Connection Issues
- Automatic retry mechanism
- Fallback to Firestore
- Local storage backup
- User-friendly error messages

### Data Sync
- Offline data is queued for sync
- Automatic sync when connection is restored
- Conflict resolution for concurrent updates

## 📊 Data Models

### UserProfile
```dart
class UserProfile {
  final String uid;
  String name;
  String? phone;
  String city;
  String? email;
  final DateTime createdAt;
  DateTime updatedAt;
}
```

### Farming Data
All farming data is stored as flexible JSON documents with common fields:
- `userId` - User identifier
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp
- Collection-specific fields

## 🔐 Security

### Connection Security
- MongoDB Atlas with SSL/TLS
- Username/password authentication
- Network access restrictions

### Data Security
- User data isolation by UID
- Input validation and sanitization
- Error message sanitization

## 🚀 Future Enhancements

1. **Real-time Updates**: WebSocket integration for live data
2. **Data Analytics**: Advanced querying and reporting
3. **Backup Strategy**: Automated data backup
4. **Performance Optimization**: Indexing and query optimization
5. **Data Migration**: Tools for data migration and cleanup

## 📞 Support

For issues or questions regarding MongoDB integration:
1. Check the test screen for connection status
2. Review console logs for error messages
3. Verify MongoDB Atlas cluster status
4. Check network connectivity

## 🎯 Next Steps

1. **Test the integration** using the test screen
2. **Customize data models** for your specific needs
3. **Add more collections** as required
4. **Implement real-time features** if needed
5. **Set up monitoring** for production use

---

**Note**: This integration provides a robust foundation for storing and managing farming data while maintaining compatibility with your existing Firebase authentication system.
