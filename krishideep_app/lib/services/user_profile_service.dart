import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';

class UserProfileService {
  static const String _collection = 'user_profiles';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or update user profile
  Future<void> createOrUpdateProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(profile.uid)
          .set(profile.toFirestoreMap(), SetOptions(merge: true));

      // Also save locally as backup
      await _saveProfileLocally(profile);
    } catch (e) {
      // If Firestore fails, save locally
      print('Firestore save failed, saving locally: $e');
      await _saveProfileLocally(profile);
    }
  }

  // Get user profile by UID
  Future<UserProfile?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists) {
        final profile = UserProfile.fromSnapshot(doc);
        // Save locally as backup
        await _saveProfileLocally(profile);
        return profile;
      }
      return null;
    } catch (e) {
      // If Firestore is offline or unavailable, try local storage
      print('Firestore offline or error getting profile: $e');
      return await _getProfileLocally(uid);
    }
  }

  // Update specific fields of user profile
  Future<void> updateProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _firestore.collection(_collection).doc(uid).update(updates);

      // Also update local storage
      final currentProfile = await getProfile(uid);
      if (currentProfile != null) {
        final updatedProfile = currentProfile.copyWith(
          name: updates['name'] ?? currentProfile.name,
          phone: updates['phone'] ?? currentProfile.phone,
          city: updates['city'] ?? currentProfile.city,
          email: updates['email'] ?? currentProfile.email,
          updatedAt: DateTime.now(),
        );
        await _saveProfileLocally(updatedProfile);
      }
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Delete user profile
  Future<void> deleteProfile(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  // Check if profile exists
  Future<bool> profileExists(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      // If Firestore is offline or unavailable, check local storage
      print('Firestore offline or error: $e');
      return await _profileExistsLocally(uid);
    }
  }

  // Stream user profile for real-time updates
  Stream<UserProfile?> getProfileStream(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserProfile.fromSnapshot(doc);
      }
      return null;
    });
  }

  // Get all profiles (admin function)
  Future<List<UserProfile>> getAllProfiles() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => UserProfile.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all profiles: $e');
    }
  }

  // Search profiles by city
  Future<List<UserProfile>> getProfilesByCity(String city) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('city', isEqualTo: city)
          .get();
      return querySnapshot.docs
          .map((doc) => UserProfile.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get profiles by city: $e');
    }
  }

  // Local storage methods for offline support
  Future<void> _saveProfileLocally(UserProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Convert DateTime objects to ISO strings for JSON serialization
      final profileMap = profile.toMap();
      profileMap['createdAt'] = profile.createdAt.toIso8601String();
      profileMap['updatedAt'] = profile.updatedAt.toIso8601String();
      final profileJson = jsonEncode(profileMap);
      await prefs.setString('user_profile_${profile.uid}', profileJson);
    } catch (e) {
      print('Failed to save profile locally: $e');
    }
  }

  Future<UserProfile?> _getProfileLocally(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString('user_profile_$uid');
      if (profileJson != null) {
        final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
        return UserProfile.fromMap(profileMap);
      }
      return null;
    } catch (e) {
      print('Failed to get profile locally: $e');
      return null;
    }
  }

  Future<bool> _profileExistsLocally(String uid) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey('user_profile_$uid');
    } catch (e) {
      print('Failed to check local profile existence: $e');
      return false;
    }
  }
}
