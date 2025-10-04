import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  String name;
  String? phone;
  String city;
  String? email;
  final DateTime createdAt;
  DateTime updatedAt;

  UserProfile({
    required this.uid,
    required this.name,
    this.phone,
    required this.city,
    this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert UserProfile to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'city': city,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Convert UserProfile to Map for Firestore (with Timestamp)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'city': city,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Create UserProfile from Map (works for Firestore)
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic dateValue) {
      if (dateValue == null) return DateTime.now();
      if (dateValue is Timestamp) return dateValue.toDate();
      if (dateValue is DateTime) return dateValue;
      if (dateValue is String) return DateTime.parse(dateValue);
      return DateTime.now();
    }

    return UserProfile(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'],
      city: map['city'] ?? '',
      email: map['email'],
      createdAt: parseDate(map['createdAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  // Create UserProfile from Firestore DocumentSnapshot
  factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserProfile.fromMap(data);
  }

  // Copy with method for updating
  UserProfile copyWith({
    String? uid,
    String? name,
    String? phone,
    String? city,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, name: $name, phone: $phone, city: $city, email: $email, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.uid == uid &&
        other.name == name &&
        other.phone == phone &&
        other.city == city &&
        other.email == email;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        city.hashCode ^
        email.hashCode;
  }
}
