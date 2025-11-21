// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> createUser(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw switch (e.code) {
        'email-already-in-use' => 'Email already registered.',
        'weak-password' => 'Password too weak.',
        'invalid-email' => 'Invalid email.',
        _ => 'Sign up failed.',
      };
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return cred.user!;
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }
  String _mapError(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' => 'No user found for that email.',
      'wrong-password' => 'Incorrect password.',
      'invalid-email' => 'Please enter a valid email.',
      'user-disabled' => 'This account has been disabled.',
      _ => 'Login failed. Please try again.',
    };
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapError(e);
    }
  }
}