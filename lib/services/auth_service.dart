import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String _keyNotifications = "notifications_enabled";

  Stream<User?> get userStream => _auth.authStateChanges();

  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> saveProfile({
    required String name,
    required String role,
    required String pharmacy,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).set({
      'name': name,
      'role': role,
      'pharmacy': pharmacy,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, String>> getProfile() async {
    final user = _auth.currentUser;
    if (user == null) return {'name': '', 'role': '', 'pharmacy': ''};

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return {'name': '', 'role': '', 'pharmacy': ''};

    final data = doc.data()!;
    return {
      'name': data['name']?.toString() ?? '',
      'role': data['role']?.toString() ?? '',
      'pharmacy': data['pharmacy']?.toString() ?? '',
    };
  }

  Future<void> saveNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
  }

  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifications) ?? true;
  }
}
