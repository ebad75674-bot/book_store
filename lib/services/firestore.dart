// services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Auto-generates doc ID = UID
  Future<void> saveUserProfile({
    required String uid,
    required String name,
    required String phone,
     required String address,
    required String email,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'name': name.trim(),
        'phone': phone.trim(),
        'address': address.trim(),
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      // Show real Firestore error (for debugging)
      throw 'Firestore Error: ${e.message}';
     
    } catch (_) {
      throw 'Failed to save profile.';
    }
  }
  /// Get user data by UID
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } on FirebaseException catch (e) {
      throw 'Failed to load profile: ${e.message}';
    }
  }
}